bsma_sources = [
    'SysMonitorApplet.vala',
    'Providers/Memory.vala',
    'Providers/CPU.vala',
    'Providers/Net.vala',
    'Providers/Uptime.vala',
    'Widgets/Popover.vala',
    'Widgets/MainView.vala',
    'Widgets/SettingsView.vala',
    'Utils.vala'
]

bsma_deps = [
    dep_gtk3,
    dep_glib,
    dep_peas,
    dep_budgie,
    dep_gobject,
    dep_gtop,
    dep_libgee
]

shared_library('budgiesmapplet',
    bsma_sources,
    dependencies: bsma_deps,
    link_args : ['-lm', '-nostartfiles'],
    vala_args: [
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install: true,
    install_dir: LIB_INSTALL_DIR,
)
