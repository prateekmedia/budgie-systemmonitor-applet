namespace SysMonitorApplet {
    public class Widgets.Popover : Gtk.Grid {

        public SysMonitorApplet.Widgets.MainView main_view;
        public SysMonitorApplet.Widgets.SettingsView settings_view;
        private Gtk.Stack stack;

        public Popover(Settings? settings) {
            main_view = new SysMonitorApplet.Widgets.MainView (settings);
            main_view.hexpand = true;
            settings_view = new SysMonitorApplet.Widgets.SettingsView (settings);

            stack = new Gtk.Stack ();
            stack.hexpand = true;
            stack.add_titled (main_view, main_view.name, _("Main"));
            stack.add_titled (settings_view, settings_view.name, _("Settings"));

            var stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.margin = 3;
            stack_switcher.halign = Gtk.Align.FILL;
            stack_switcher.margin_start = 15;
            stack_switcher.margin_end = 15;
            stack_switcher.homogeneous = true;
            stack_switcher.stack = stack;

            attach (stack_switcher,  0, 0, 1, 1);
            attach (stack,           0, 1, 1, 1);
        }
    }
}
