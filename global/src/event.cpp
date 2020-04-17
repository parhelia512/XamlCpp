#include <atomic>
#include <map>
#include <xaml/event.h>
#include <xaml/object.h>
#include <xaml/xaml_ptr.hpp>

using namespace std;

struct xaml_event_impl : xaml_implement<xaml_event_impl, xaml_event, xaml_callback, xaml_object>
{
private:
    atomic<size_t> index{ 0 };
    map<size_t, xaml_ptr<xaml_callback>> m_callbacks{};

public:
    xaml_result XAML_CALL add(xaml_callback* handler, size_t* ptoken) noexcept override
    {
        size_t token = ++index;
        try
        {
            handler->add_ref();
            m_callbacks.emplace(token, handler);
            *ptoken = token;
            return XAML_S_OK;
        }
        catch (bad_alloc const&)
        {
            handler->release();
            return XAML_E_OUTOFMEMORY;
        }
        catch (...)
        {
            handler->release();
            return XAML_E_FAIL;
        }
    }

    xaml_result XAML_CALL remove(size_t token) noexcept override
    {
        auto it = m_callbacks.find(token);
        if (it == m_callbacks.end()) return XAML_E_INVALIDARG;
        m_callbacks.erase(it);
        return XAML_S_OK;
    }

    xaml_result XAML_CALL invoke(xaml_object* sender, xaml_object* args) const noexcept override
    {
        for (auto& pair : m_callbacks)
        {
            xaml_result hr = pair.second->invoke(sender, args);
            if (XAML_FAILED(hr)) return hr;
        }
        return XAML_S_OK;
    }
};

xaml_result xaml_event_new(xaml_event** ptr) noexcept
{
    return xaml_object_new<xaml_event_impl>(ptr);
}
