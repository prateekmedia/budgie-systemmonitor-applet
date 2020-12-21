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
