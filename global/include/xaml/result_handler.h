#ifndef XAML_UI_RESULT_HANDLER_H
#define XAML_UI_RESULT_HANDLER_H

#include <xaml/delegate.h>
#include <xaml/result.h>

EXTERN_C XAML_API void XAML_CALL xaml_result_handler_default(xaml_result, xaml_result_raise_level, char const*) XAML_NOEXCEPT;
EXTERN_C XAML_API void XAML_CALL xaml_result_handler_empty(xaml_result, xaml_result_raise_level, char const*) XAML_NOEXCEPT;

typedef void(XAML_CALL* xaml_result_handler)(xaml_result, xaml_result_raise_level, char const*) XAML_NOEXCEPT;

EXTERN_C XAML_API xaml_result XAML_CALL xaml_result_handler_set(xaml_result_handler) XAML_NOEXCEPT;

#ifdef __cplusplus
    #ifdef SUPPORT_FUNCTION2
using __xaml_result_handler_prototype_noexcept = void(xaml_result, xaml_result_raise_level, char const*) noexcept;
XAML_API xaml_result XAML_CALL xaml_result_handler_set(fu2::function<__xaml_result_handler_prototype_noexcept> const&) XAML_NOEXCEPT;
    #endif // SUPPORT_FUNCTION2

    #if !defined(SUPPORT_FUNCTION2) || defined(XAML_BUILD)
using __xaml_result_handler_prototype = void(xaml_result, xaml_result_raise_level, char const*);
XAML_API xaml_result XAML_CALL xaml_result_handler_set(std::function<__xaml_result_handler_prototype> const&) XAML_NOEXCEPT;
    #endif
#endif // __cplusplus

#endif // !XAML_UI_RESULT_HANDLER_H
