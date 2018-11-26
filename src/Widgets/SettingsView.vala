public class SysMonitorApplet.Widgets.SettingsView : Gtk.Grid {
    private Gtk.Switch cpu_switch;
    private Gtk.Switch ram_switch;
    private Gtk.Switch title_switch;
    private Gtk.SpinButton interval_btn;

    private Settings? settings;

    public SettingsView (Settings? settings) {
        this.settings = settings;
        orientation = Gtk.Orientation.HORIZONTAL;
        hexpand = true;

        var title_label = new Gtk.Label (_("Show title's"));
        title_switch = new Gtk.Switch ();
        title_switch.set_halign (Gtk.Align.END);
        title_switch.set_hexpand (true);
        title_switch.margin_bottom = title_label.margin_bottom = 6;
        title_switch.margin_top = title_label.margin_top = 6;
        title_switch.margin_end = title_label.margin_start = 9;

        var cpu_label = new Gtk.Label (_("Show cpu"));
        cpu_switch = new Gtk.Switch ();
        cpu_switch.set_halign (Gtk.Align.END);
        cpu_switch.set_hexpand (true);
        cpu_switch.margin_bottom = cpu_label.margin_bottom = 6;
        cpu_switch.margin_end = cpu_label.margin_start = 9;

        var ram_label = new Gtk.Label (_("Show ram"));
        ram_switch = new Gtk.Switch ();
        ram_switch.set_halign (Gtk.Align.END);
        ram_switch.set_hexpand (true);
        ram_switch.margin_bottom = ram_label.margin_bottom = 6;
        ram_switch.margin_end = ram_label.margin_start = 9;

        var interval_label = new Gtk.Label (_("Update interval (s)"));
        interval_btn = new Gtk.SpinButton.with_range (0, 60, 1);
        interval_btn.set_halign (Gtk.Align.END);
        interval_btn.set_width_chars (6);
        interval_btn.margin_end = interval_label.margin_start = 9;

        attach (title_label,    0, 0, 1, 1);
        attach (title_switch,   1, 0, 1, 1);
        attach (cpu_label,      0, 1, 1, 1);
        attach (cpu_switch,     1, 1, 1, 1);
        attach (ram_label,      0, 2, 1, 1);
        attach (ram_switch,     1, 2, 1, 1);
        attach (interval_label, 0, 3, 1, 1);
        attach (interval_btn,   1, 3, 1, 1);

        this.settings.bind("update-interval", interval_btn, "value", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-title", title_switch, "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-ram", ram_switch, "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-cpu", cpu_switch, "active", SettingsBindFlags.DEFAULT);
    }
}
