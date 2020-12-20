project('com.prateekmedia.systemmonitor',
    ['c', 'vala'],
    version: '0.1.2',
    license: 'GPL-2.0',
    default_options: [
        'c_std=c11',
    ],
)

gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

am_cflags = [
    '-fstack-protector',
    '-pedantic',
    '-Wstrict-prototypes',
    '-Wundef',
    '-Werror-implicit-function-declaration',
    '-Wformat',
    '-Wformat-security',
    '-Werror=format-security',
    '-Wconversion',
    '-Wunused-variable',
    '-Wunreachable-code',
    '-Wall',
    '-W',
]

add_global_arguments(am_cflags, language: 'c')

dep_gtk3 = dependency('gtk+-3.0', version: '>=3.18')
dep_glib = dependency('glib-2.0', version: '>= 2.46.0')
dep_peas = dependency('libpeas-1.0', version: '>= 1.8.0')
dep_budgie = dependency('budgie-1.0', version: '>= 2')
dep_gobject = dependency('gobject-2.0')
dep_gtop = dependency('libgtop-2.0')
dep_libgee = dependency('gee-0.8')

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))
datadir = join_paths(prefix, get_option('datadir'))

PIXMAPS_DIR = join_paths(datadir, 'pixmaps')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language:'c'
)

LIB_INSTALL_DIR = join_paths(libdir, 'budgie-desktop', 'plugins', meson.project_name())

install_data('schema/com.prateekmedia.systemmonitor.gschema.xml',
    install_dir: '/usr/share/glib-2.0/schemas'
)

subdir('icons')
subdir('po')
subdir('src')

meson.add_install_script('meson/meson_post_install.py')
