#ifndef XAML_MARKUP_EXTENSION_HPP
#define XAML_MARKUP_EXTENSION_HPP

#include <xaml/meta/meta_macro.hpp>

namespace xaml
{
    struct markup_context
    {
        virtual std::weak_ptr<meta_class> current_element() const = 0;
        virtual std::string_view current_property() const = 0;
        virtual std::weak_ptr<meta_class> find_element(std::string_view name) const = 0;
        virtual ~markup_context() {}
    };

    class markup_extension : public meta_class
    {
    public:
        virtual ~markup_extension() {}

        virtual void provide(markup_context& context) = 0;

#define ADD_MARKUP_EXTENSION_MEMBERS()

    public:
        static void register_class() noexcept
        {
            REGISTER_TYPE(xaml, markup_extension);
            ADD_MARKUP_EXTENSION_MEMBERS();
        }
    };
} // namespace xaml

#endif // !XAML_MARKUP_EXTENSION_HPP
