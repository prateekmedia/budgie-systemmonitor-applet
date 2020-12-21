/*
* Copyright (c) 2018 Dirli <litandrej85@gmail.com>
*
* Copyright (c) 2020 Prateek SU <prateekmedia@github.com>
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*/

public class SysMonitorApplet.Widgets.SettingsView : Gtk.Grid {
    private Gtk.Switch cpu_switch;
    private Gtk.Switch ram_switch;
    private Gtk.Switch nets_switch;
    private Gtk.Switch netc_switch;
    private Gtk.Switch nett_switch;
    private Gtk.ComboBoxText prefix_combox;
    private Gtk.SpinButton interval_btn;

    private Settings? settings;

    public SettingsView (Settings? settings) {
        this.settings = settings;
        orientation = Gtk.Orientation.HORIZONTAL;
        hexpand = true;
        row_spacing = 6;

        var prefix_label = new Gtk.Label (_("Prefix"));
        prefix_combox = new Gtk.ComboBoxText ();
        prefix_combox.set_halign (Gtk.Align.END);
        prefix_combox.set_hexpand (true);
        prefix_combox.margin_top = prefix_label.margin_top = 6;
        prefix_combox.margin_end = prefix_label.margin_start = 9;
        
        prefix_combox.append_text("No Prefix");
        prefix_combox.append_text("Title Only");
        prefix_combox.append_text("Icon Only");

        var vis_label = new Gtk.Label (_("<b>Visibility Options</b>"));
        vis_label.use_markup = true;
        vis_label.halign = Gtk.Align.CENTER;
        vis_label.margin_bottom = 6;
        
        var cpu_label = new Gtk.Label (_("CPU"));
        cpu_switch = new Gtk.Switch ();
        cpu_switch.set_halign (Gtk.Align.END);
        cpu_switch.set_hexpand (true);
        cpu_switch.margin_end = cpu_label.margin_start = 9;

        var ram_label = new Gtk.Label (_("RAM"));
        ram_switch = new Gtk.Switch ();
        ram_switch.set_halign (Gtk.Align.END);
        ram_switch.set_hexpand (true);
        ram_switch.margin_end = ram_label.margin_start = 9;
        
        var nets_label = new Gtk.Label (_("NetSpeed"));
        nets_switch = new Gtk.Switch ();
        nets_switch.set_halign (Gtk.Align.END);
        nets_switch.set_hexpand (true);
        nets_switch.margin_end = nets_label.margin_start = 9;
        
        var netc_label = new Gtk.Label (_("TOTAL NetSpeed"));
        netc_switch = new Gtk.Switch ();
        netc_switch.set_halign (Gtk.Align.END);
        netc_switch.set_hexpand (true);
        netc_switch.margin_end = netc_label.margin_start = 9;
        
        var nett_label = new Gtk.Label (_("TOTAL Data Used"));
        nett_switch = new Gtk.Switch ();
        nett_switch.set_halign (Gtk.Align.END);
        nett_switch.set_hexpand (true);
        nett_switch.margin_end = nett_label.margin_start = 9;

        var interval_label = new Gtk.Label (_("Update interval (s)"));
        interval_btn = new Gtk.SpinButton.with_range (0, 60, 1);
        interval_btn.set_halign (Gtk.Align.END);
        interval_btn.set_width_chars (6);
        interval_btn.margin_end = interval_label.margin_start = 9;

        attach (prefix_label,   0, 0, 1, 1);
        attach (prefix_combox,  1, 0, 1, 1);
        attach (vis_label,      0, 1, 2, 1);
        attach (cpu_label,      0, 2, 1, 1);
        attach (cpu_switch,     1, 2, 1, 1);
        attach (ram_label,      0, 3, 1, 1);
        attach (ram_switch,     1, 3, 1, 1);
        attach (nets_label,     0, 4, 1, 1);
        attach (nets_switch,    1, 4, 1, 1);
        attach (netc_label,     0, 5, 1, 1);
        attach (netc_switch,    1, 5, 1, 1);
        attach (nett_label,     0, 6, 1, 1);
        attach (nett_switch,    1, 6, 1, 1);
        attach (interval_label, 0, 7, 1, 1);
        attach (interval_btn,   1, 7, 1, 1);

        this.settings.bind("update-interval", interval_btn, "value", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-what", prefix_combox, "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-ram", ram_switch, "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-cpu", cpu_switch, "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-nets", nets_switch, "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-netc", netc_switch, "active", SettingsBindFlags.DEFAULT);
        this.settings.bind("show-nett", nett_switch, "active", SettingsBindFlags.DEFAULT);
    }
}
