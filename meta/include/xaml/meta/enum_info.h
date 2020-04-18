#ifndef XAML_META_ENUM_INFO_H
#define XAML_META_ENUM_INFO_H

#include <xaml/box.h>
#include <xaml/map.h>
#include <xaml/meta/reflection_info.h>
#include <xaml/xaml_ptr.hpp>

XAML_CLASS(xaml_enum_info, { 0x51dcc841, 0xc0d0, 0x4c8b, { 0x9f, 0x9f, 0xed, 0x7b, 0x48, 0xa1, 0xa9, 0xd9 } })

#ifdef __cplusplus
struct XAML_NOVTBL xaml_enum_info : xaml_reflection_info
{
    virtual xaml_result XAML_CALL get_values(xaml_map_view**) noexcept = 0;
    virtual xaml_result XAML_CALL get_value(xaml_string*, xaml_box**) noexcept = 0;

    template <typename T>
    xaml_result get_value(xaml_string* str, T& value)
    {
        xaml_ptr<xaml_box> box;
        XAML_RETURN_IF_FAILED(get_value(str, &box));
        return unbox_value(box.get(), value);
    }
};
#else

#endif // __cplusplus

#endif // !XAML_META_ENUM_INFO_H
