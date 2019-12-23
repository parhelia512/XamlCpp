if(UNIX)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(GTK3 REQUIRED gtk+-3.0)

    link_directories(${GTK3_LIBRARY_DIRS})

    add_definitions(${GTK3_CFLAGS_OTHER})
else()
    find_path(GTK_gtk_INCLUDE_PATH gtk/gtk.h)
    find_path(GTK_glibconfig_INCLUDE_PATH glibconfig.h)
    find_path(GTK_glib_INCLUDE_PATH glib.h)
    find_library(GTK_gtk_LIBRARY gtk-3.0)
    find_library(GTK_gdk_LIBRARY gdk-3.0)
    find_library(GTK_glib_LIBRARY glib-2.0)
    find_library(GTK_gobject_LIBRARY gobject-2.0)

    set(GTK3_FOUND TRUE)
    set(GTK3_INCLUDE_DIRS ${GTK_gtk_INCLUDE_PATH} ${GTK_glibconfig_INCLUDE_PATH} ${GTK_glib_INCLUDE_PATH})
    set(GTK3_LIBRARIES ${GTK_gtk_LIBRARY} ${GTK_gdk_LIBRARY} ${GTK_glib_LIBRARY} ${GTK_gobject_LIBRARY})
endif()
