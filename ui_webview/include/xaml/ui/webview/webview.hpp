#ifndef XAML_UI_WEBVIEW_WEBVIEW_HPP
#define XAML_UI_WEBVIEW_WEBVIEW_HPP

#include <atomic>
#include <functional>
#include <xaml/ui/control.hpp>

#ifdef XAML_UI_GTK3
#include <webkit2/webkit2.h>
#endif

namespace xaml
{
#ifdef XAML_UI_WINDOWS
    struct native_webview
    {
    public:
        virtual ~native_webview() {}
        virtual void create_async(HWND parent, rectangle const& rect, std::function<void()>&& callback = {}) = 0;
        virtual operator bool() const = 0;
        virtual void navigate(string_view_t uri) = 0;
        virtual void set_location(point p) = 0;
        virtual void set_size(size s) = 0;
        virtual void set_rect(rectangle const& rect) = 0;

    private:
        std::function<void(string_view_t)> m_navigated{};

    public:
        void set_navigated(std::function<void(string_view_t)>&& callback) { m_navigated = std::move(callback); }
        void invoke_navigated(string_view_t uri)
        {
            if (m_navigated) m_navigated(uri);
        }
    };
#endif // XAML_UI_WINDOWS

    class webview : public control
    {
    public:
        XAML_UI_WEBVIEW_API webview();
        XAML_UI_WEBVIEW_API ~webview() override;

    private:
        std::atomic<bool> m_navigating{ false };

#ifdef XAML_UI_WINDOWS
    public:
        using __native_webview_type = std::shared_ptr<native_webview>;

    private:
        __native_webview_type m_webview{ OBJC_NIL };

    public:
        __native_webview_type __get_webview() const noexcept { return m_webview; }

    protected:
        void __set_webview(__native_webview_type value) OBJC_BLOCK({ m_webview = value; });
#endif // XAML_UI_WINDOWS

#ifdef XAML_UI_GTK3
    private:
        static void on_load_changed(WebKitWebView* web_view, WebKitLoadEvent load_event, gpointer data);
#endif // XAML_UI_GTK3

#ifdef XAML_UI_COCOA
    public:
        void __on_navigated();
#endif // XAML_UI_COCOA

    public:
        XAML_UI_WEBVIEW_API void __draw(rectangle const& region) override;

#ifdef XAML_UI_WINDOWS
    private:
        void draw_create();
#endif // XAML_UI_WINDOWS

    private:
        void draw_size();
        void draw_uri();

    public:
        EVENT(uri_changed, webview&, string_view_t)
        PROP_STRING_EVENT(uri)

    public:
#define ADD_WEBVIEW_MEMBERS() \
    ADD_CONTROL_MEMBERS();    \
    ADD_PROP_EVENT(uri)

        static void register_class() noexcept
        {
            REGISTER_TYPE(xaml, webview);
            ADD_CTOR_DEF();
            ADD_WEBVIEW_MEMBERS();
        }
    };
} // namespace xaml

#endif // !XAML_UI_WEBVIEW_WEBVIEW_HPP
