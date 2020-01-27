if(UNIX)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(GTK3 REQUIRED gtk+-3.0)
    link_directories(${GTK3_LIBRARY_DIRS})
    add_definitions(${GTK3_CFLAGS_OTHER})
else()
    find_path(GTK_gtk_INCLUDE_PATH gtk/gtk.h)
    find_path(GTK_glibconfig_INCLUDE_PATH glibconfig.h)
    find_path(GTK_glib_INCLUDE_PATH glib.h)
    find_path(GTK_cairo_INLUDE_PATH cairo.h)
    find_library(GTK_gtk_LIBRARY gtk-3.0)
    find_library(GTK_gdk_LIBRARY gdk-3.0)
    find_library(GTK_glib_LIBRARY glib-2.0)
    find_library(GTK_gobject_LIBRARY gobject-2.0)
    find_library(GTK_pango_LIBRARY pango-1.0)
    find_library(GTK_pangocairo_LIBRARY pangocairo-1.0)
    find_library(GTK_harfbuzz_LIBRARY harfbuzz)
    find_library(GTK_atk_LIBRARY atk-1.0)
    find_library(GTK_cairo_LIBRARY cairo)
    find_library(GTK_cairogobject_LIBRARY cairo-gobject)
    find_library(GTK_gdk_pixbuf_LIBRARY gdk_pixbuf-2.0)
    find_library(GTK_gio_LIBRARY gio-2.0)

    message("-- Found GTK3")

    set(GTK3_FOUND TRUE)
    set(GTK3_INCLUDE_DIRS ${GTK_gtk_INCLUDE_PATH} ${GTK_glibconfig_INCLUDE_PATH} ${GTK_glib_INCLUDE_PATH} ${GTK_cairo_INLUDE_PATH})
    set(GTK3_LIBRARIES ${GTK_gtk_LIBRARY} ${GTK_gdk_LIBRARY} ${GTK_glib_LIBRARY} ${GTK_gobject_LIBRARY} ${GTK_pango_LIBRARY} ${GTK_pangocairo_LIBRARY} ${GTK_harfbuzz_LIBRARY} ${GTK_atk_LIBRARY} ${GTK_cairo_LIBRARY} ${GTK_cairogobject_LIBRARY} ${GTK_gdk_pixbuf_LIBRARY} ${GTK_gio_LIBRARY})
endif()
