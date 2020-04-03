#include <cmath>
#import <cocoa/XamlCanvasView.h>
#include <cocoa/strings.hpp>
#include <functional>
#include <xaml/ui/controls/canvas.hpp>
#include <xaml/ui/controls/native_canvas.hpp>
#include <xaml/ui/native_control.hpp>
#include <xaml/ui/native_drawing.hpp>

@implementation XamlCanvasView : NSView
@synthesize classPointer;

- (id)initWithClassPointer:(void*)ptr
{
    if ([self init])
    {
        self.classPointer = ptr;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    xaml::canvas* cv = (xaml::canvas*)self.classPointer;
    cv->__on_draw_rect();
}
@end

#if __has_include(<numbers>)
#include <numbers>
using std::numbers::pi;
#else
inline constexpr double pi = M_PI;
#endif // __has_include(<numbers>)

using namespace std;

namespace xaml
{
    static NSColor* get_NSColor(color c)
    {
        return [NSColor colorWithCalibratedRed:(c.r / 255.0) green:(c.g / 255.0) blue:(c.b / 255.0) alpha:(c.a / 255.0)];
    }

    static void set_pen(NSBezierPath* path, drawing_pen const& pen)
    {
        [path setLineWidth:pen.width];
        [get_NSColor(pen.stroke) set];
    }

    static void set_brush(NSBezierPath* path, drawing_brush const& brush)
    {
        [get_NSColor(brush.fill) set];
    }

    static NSBezierPath* path_arc(size base_size, rectangle const& region, double start_angle, double end_angle)
    {
        NSBezierPath* path = [NSBezierPath bezierPath];
        size radius = { region.width / 2, region.height / 2 };
        point centerp = { region.x + radius.width, region.y + radius.height };
        point startp = centerp + point{ radius.width * cos(start_angle), radius.height * sin(start_angle) };
        [path moveToPoint:NSMakePoint(startp.x, base_size.height - startp.y)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(centerp.x, base_size.height - centerp.y)
                                         radius:radius.width
                                     startAngle:-start_angle / pi * 180
                                       endAngle:-end_angle / pi * 180
                                      clockwise:YES];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform scaleXBy:1 yBy:radius.height / radius.width];
        return path;
    }

    void drawing_context::draw_arc(drawing_pen const& pen, rectangle const& region, double start_angle, double end_angle)
    {
        NSBezierPath* arc = path_arc(m_size, region, start_angle, end_angle);
        set_pen(arc, pen);
        [arc stroke];
    }

    void drawing_context::fill_pie(drawing_brush const& brush, rectangle const& region, double start_angle, double end_angle)
    {
        NSBezierPath* arc = path_arc(m_size, region, start_angle, end_angle);
        [arc closePath];
        set_brush(arc, brush);
        [arc fill];
    }

    static NSBezierPath* path_ellipse(size base_size, rectangle const& region)
    {
        return [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(region.x, base_size.height - region.height - region.y, region.width, region.height)];
    }

    void drawing_context::draw_ellipse(drawing_pen const& pen, rectangle const& region)
    {
        NSBezierPath* ellipse = path_ellipse(m_size, region);
        set_pen(ellipse, pen);
        [ellipse stroke];
    }

    void drawing_context::fill_ellipse(drawing_brush const& brush, rectangle const& region)
    {
        NSBezierPath* ellipse = path_ellipse(m_size, region);
        set_brush(ellipse, brush);
        [ellipse fill];
    }

    void drawing_context::draw_line(drawing_pen const& pen, point startp, point endp)
    {
        NSBezierPath* line = [NSBezierPath bezierPath];
        [line moveToPoint:NSMakePoint(startp.x, m_size.height - startp.y)];
        [line lineToPoint:NSMakePoint(endp.x, m_size.height - endp.y)];
        set_pen(line, pen);
        [line stroke];
    }

    static NSBezierPath* path_rect(size base_size, rectangle const& rect)
    {
        return [NSBezierPath bezierPathWithRect:NSMakeRect(rect.x, base_size.height - rect.height - rect.y, rect.width, rect.height)];
    }

    void drawing_context::draw_rect(drawing_pen const& pen, rectangle const& rect)
    {
        NSBezierPath* path = path_rect(m_size, rect);
        set_pen(path, pen);
        [path stroke];
    }

    void drawing_context::fill_rect(drawing_brush const& brush, rectangle const& rect)
    {
        NSBezierPath* path = path_rect(m_size, rect);
        set_brush(path, brush);
        [path fill];
    }

    static NSBezierPath* path_round_rect(size base_size, rectangle const& rect, size round)
    {
        return [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(rect.x, base_size.height - rect.height - rect.y, rect.width, rect.height)
                                               xRadius:round.width / 2
                                               yRadius:round.height / 2];
    }

    void drawing_context::draw_round_rect(drawing_pen const& pen, rectangle const& rect, size round)
    {
        NSBezierPath* path = path_round_rect(m_size, rect, round);
        set_pen(path, pen);
        [path stroke];
    }

    void drawing_context::fill_round_rect(drawing_brush const& brush, rectangle const& rect, size round)
    {
        NSBezierPath* path = path_round_rect(m_size, rect, round);
        set_brush(path, brush);
        [path fill];
    }

    void drawing_context::draw_string(drawing_brush const& brush, drawing_font const& font, point p, string_view_t str)
    {
        NSFontDescriptor* fontdes = [NSFontDescriptor fontDescriptorWithName:to_native(font.font_family)
                                                                        size:font.size];
        NSFontDescriptorSymbolicTraits traits = 0;
        if (font.italic) traits |= NSFontDescriptorTraitItalic;
        if (font.bold) traits |= NSFontDescriptorTraitBold;
        if (traits)
        {
            fontdes = [fontdes fontDescriptorWithSymbolicTraits:traits];
        }
        NSFont* nfont = [NSFont fontWithDescriptor:fontdes size:font.size];
        NSDictionary* attrs = @{
            NSFontAttributeName : nfont,
            NSForegroundColorAttributeName : get_NSColor(brush.fill)
        };
        NSAttributedString* astr = [[NSAttributedString alloc] initWithString:to_native(str)
                                                                   attributes:attrs];
        NSSize str_size = astr.size;
        NSPoint location = NSMakePoint(p.x, m_size.height - p.y - str_size.height);
        switch (font.halign)
        {
        case halignment_t::center:
            location.x -= str_size.width / 2;
            break;
        case halignment_t::right:
            location.x -= str_size.width;
            break;
        default:
            break;
        }
        switch (font.valign)
        {
        case valignment_t::center:
            location.y += str_size.height / 2;
            break;
        case valignment_t::bottom:
            location.y += str_size.height;
            break;
        default:
            break;
        }
        [astr drawAtPoint:location];
    }

    void canvas::__draw(const rectangle& region)
    {
        if (!get_handle())
        {
            XamlCanvasView* view = [[XamlCanvasView alloc] initWithClassPointer:this];
            auto h = make_shared<native_control>();
            h->handle = view;
            set_handle(h);
            draw_visible();
        }
        __set_rect(region);
        XamlCanvasView* view = (XamlCanvasView*)get_handle()->handle;
        [view setNeedsDisplay:YES];
    }

    void canvas::__on_draw_rect()
    {
        auto dc = make_shared<drawing_context>(nullptr);
        dc->__set_size(get_size());
        m_redraw(shared_from_this<canvas>(), dc);
    }
}
