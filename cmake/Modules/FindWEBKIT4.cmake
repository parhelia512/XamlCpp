if(UNIX AND NOT APPLE)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(WEBKIT4 REQUIRED webkit2gtk-4.0)
endif()

if(${WEBKIT4_FOUND})
    add_library(webkit4 INTERFACE IMPORTED)
    target_link_directories(webkit4 INTERFACE ${WEBKIT4_LIBRARY_DIRS})
    target_compile_options(webkit4 INTERFACE ${WEBKIT4_CFLAGS_OTHER})
    target_include_directories(webkit4 INTERFACE ${WEBKIT4_INCLUDE_DIRS})
    target_link_libraries(webkit4 INTERFACE ${WEBKIT4_LIBRARIES})
endif()
