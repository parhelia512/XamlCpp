#include <Windows.h>
#include <map>
#include <wil/resource.h>
#include <wil/result_macros.h>
#include <xaml/ui/application.hpp>
#include <xaml/ui/container.hpp>
#include <xaml/ui/control.hpp>
#include <xaml/ui/native_control.hpp>
#include <xaml/ui/native_drawing.hpp>
#include <xaml/ui/win/dpi.h>

using namespace std;

namespace xaml
{
    void control::__create(window_create_params const& params)
    {
        auto h = make_shared<native_control>();
        h->handle = THROW_IF_NULL_ALLOC(CreateWindowEx(
            params.ex_style, params.class_name.c_str(), params.window_name.c_str(),
            params.style, params.x, params.y, params.width, params.height,
            params.parent ? params.parent->get_handle()->handle : nullptr,
            nullptr, GetModuleHandle(nullptr), nullptr));
        set_handle(h);
        SendMessage(get_handle()->handle, WM_SETFONT, (WPARAM)application::current()->__default_font(XamlGetDpiForWindow(get_handle()->handle)), TRUE);
    }

    void control::__set_rect(rectangle const& region)
    {
        rectangle real = region - get_margin();
        UINT udpi = XamlGetDpiForWindow(get_handle()->handle);
        rectangle real_real = real * udpi / USER_DEFAULT_SCREEN_DPI;
        THROW_IF_WIN32_BOOL_FALSE(SetWindowPos(get_handle()->handle, HWND_TOP, (int)real_real.x, (int)real_real.y, (int)real_real.width, (int)real_real.height, SWP_NOZORDER));
        __set_size_noevent({ real.width, real.height });
    }

    size control::__measure_text_size(string_view_t str, size offset) const
    {
        wil::unique_hdc_window hDC = wil::GetWindowDC(get_handle()->handle);
        if (hDC)
        {
            SIZE s = {};
            THROW_IF_WIN32_BOOL_FALSE(GetTextExtentPoint32(hDC.get(), str.data(), (int)str.length(), &s));
            return from_native(s) + offset;
        }
        return {};
    }

    size control::__get_real_size() const
    {
        UINT udpi = XamlGetDpiForWindow(get_handle()->handle);
        return get_size() * udpi / USER_DEFAULT_SCREEN_DPI;
    }

    void control::__set_real_size(size value)
    {
        UINT udpi = XamlGetDpiForWindow(get_handle()->handle);
        set_size(value * USER_DEFAULT_SCREEN_DPI / udpi);
    }

    margin control::__get_real_margin() const
    {
        UINT udpi = XamlGetDpiForWindow(get_handle()->handle);
        return get_margin() * udpi / USER_DEFAULT_SCREEN_DPI;
    }

    void control::__set_real_margin(margin const& value)
    {
        UINT udpi = XamlGetDpiForWindow(get_handle()->handle);
        set_margin(value * USER_DEFAULT_SCREEN_DPI / udpi);
    }

    void control::draw_size()
    {
        auto real_size = __get_real_size();
        THROW_IF_WIN32_BOOL_FALSE(SetWindowPos(get_handle()->handle, HWND_TOP, 0, 0, (int)real_size.width, (int)real_size.height, SWP_NOZORDER | SWP_NOMOVE));
    }

    void control::draw_visible()
    {
        ShowWindow(get_handle()->handle, m_is_visible ? SW_SHOWNORMAL : SW_HIDE);
    }

    void control::__size_to_fit() {}
} // namespace xaml
