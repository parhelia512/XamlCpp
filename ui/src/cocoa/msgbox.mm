#import <Cocoa/Cocoa.h>
#include <cocoa/strings.hpp>
#include <vector>
#include <xaml/ui/msgbox.hpp>

using namespace std;

namespace xaml
{
    static NSAlertStyle get_style(msgbox_style style)
    {
        switch (style)
        {
        case msgbox_style::warning:
        case msgbox_style::error:
            return NSAlertStyleCritical;
        case msgbox_style::info:
            return NSAlertStyleInformational;
        default:
            return NSAlertStyleWarning;
        }
    }

    msgbox_result msgbox(shared_ptr<window> parent, string_view_t message, string_view_t title, string_view_t instruction, msgbox_style style, array_view<msgbox_button> buttons)
    {
        NSAlert* alert = [NSAlert new];
        if (!title.empty())
            alert.window.title = to_native(title);
        if (instruction.empty())
        {
            if (!message.empty())
                [alert setMessageText:to_native(message)];
        }
        else
        {
            [alert setMessageText:to_native(instruction)];
            if (!message.empty())
                [alert setInformativeText:to_native(message)];
        }
        alert.alertStyle = get_style(style);
        vector<msgbox_result> res;
        for (auto& button : buttons)
        {
            switch (button.index())
            {
            case 0:
                switch (get<msgbox_common_button>(button))
                {
                case msgbox_common_button::ok:
                    [alert addButtonWithTitle:@"OK"];
                    res.push_back(msgbox_result::ok);
                    break;
                case msgbox_common_button::yes:
                    [alert addButtonWithTitle:@"Yes"];
                    res.push_back(msgbox_result::yes);
                    break;
                case msgbox_common_button::no:
                    [alert addButtonWithTitle:@"No"];
                    res.push_back(msgbox_result::no);
                    break;
                case msgbox_common_button::cancel:
                    [alert addButtonWithTitle:@"Cancel"];
                    res.push_back(msgbox_result::cancel);
                    break;
                case msgbox_common_button::retry:
                    [alert addButtonWithTitle:@"Retry"];
                    res.push_back(msgbox_result::retry);
                    break;
                case msgbox_common_button::close:
                    [alert addButtonWithTitle:@"Close"];
                    res.push_back(msgbox_result::cancel);
                    break;
                }
                break;
            case 1:
            {
                msgbox_custom_button const& b = get<msgbox_custom_button>(button);
                [alert addButtonWithTitle:to_native(b.text)];
                res.push_back(b.result);
                break;
            }
            }
        }
        auto ret = (ptrdiff_t)[alert runModal] - (ptrdiff_t)NSAlertFirstButtonReturn;
        if (ret < 0 || ret >= (ptrdiff_t)res.size())
            return msgbox_result::error_result;
        else
            return res[ret];
    }
}
