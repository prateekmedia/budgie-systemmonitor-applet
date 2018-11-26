/*
* Copyright (c) 2018 Dirli <litandrej85@gmail.com>
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*/

namespace SysMonitorApplet {
    public class Plugin : GLib.Object, Budgie.Plugin {
        public Budgie.Applet get_panel_widget(string uuid) {return new Applet(uuid);}
    }

    public class Applet : Budgie.Applet {
        private Gtk.EventBox widget;

        Budgie.Popover? popover = null;
        unowned Budgie.PopoverManager? manager = null;
        SysMonitorApplet.Widgets.Popover? popover_grid = null;

        private Gtk.Label mem_val;
        private Gtk.Label mem_label;
        private Gtk.Label cpu_val;
        private Gtk.Label cpu_label;

        private bool ram_flag;
        private bool cpu_flag;

        public string uuid { public set; public get; }
        private uint source_id;
        private uint source_id_pop;

        private Settings? settings;

        public Applet(string uuid) {
            Object(uuid: uuid);

            settings_schema = "com.github.dirli.budgie-sys-monitor-applet";
            settings_prefix = "/com/github/dirli/budgie-sys-monitor-applet";
            settings = get_applet_settings(uuid);
            settings.changed.connect(on_settings_change);

            cpu_label = new Gtk.Label ("cpu");
            cpu_val = new Gtk.Label ("-");

            mem_label = new Gtk.Label ("mem");
            mem_val = new Gtk.Label ("-");

            Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            box.pack_start (cpu_label, false, false, 0);
            box.pack_start (cpu_val, false, false, 0);
            box.pack_start (mem_label, false, false, 0);
            box.pack_start (mem_val, false, false, 0);

            widget = new Gtk.EventBox();
            widget.add(box);
            add(widget);

            popover_grid = new SysMonitorApplet.Widgets.Popover (settings);
            popover = new Budgie.Popover (widget);
            popover.add(popover_grid);
            popover.closed.connect((e) => {
                Source.remove(source_id_pop);
            });

            widget.button_press_event.connect((e) => {
                if (e.button != 1) {
                    return Gdk.EVENT_PROPAGATE;
                }

                if (popover.get_visible()) {
                    popover.hide();
                } else {
                    source_id_pop = GLib.Timeout.add_full(GLib.Priority.DEFAULT, 1000, update_popover);
                    this.manager.show_popover(widget);
                }

                return Gdk.EVENT_STOP;
            });

            update ();
            popover.get_child().show_all();
            show_all();
            on_settings_change ("show-ram");
            on_settings_change ("show-cpu");
            enable_timer ();
        }

        protected void on_settings_change(string key) {
            cpu_flag = settings.get_boolean("show-cpu");
            ram_flag = settings.get_boolean("show-ram");
            bool title_flag = settings.get_boolean("show-title");

            switch (key) {
                case "update-interval":
                    enable_timer ();
                    break;
                case "show-title":
                    if (ram_flag) {
                        mem_label.set_visible(title_flag);
                    } else {
                        mem_label.set_visible(false);
                    }

                    if (cpu_flag) {
                        cpu_label.set_visible(title_flag);
                    } else {
                        cpu_label.set_visible(false);
                    }

                    break;
                case "show-ram":
                    mem_val.set_visible(ram_flag);
                    if (ram_flag) {
                        mem_label.set_visible(title_flag);
                    } else if (title_flag) {
                        mem_label.set_visible(false);
                    }

                    break;
                case "show-cpu":
                    cpu_val.set_visible(cpu_flag);
                    if (cpu_flag) {
                        cpu_label.set_visible(title_flag);
                    } else if (title_flag) {
                        cpu_label.set_visible(false);
                    }

                    break;
            }

            queue_resize();
        }

        private void enable_timer () {

            if (source_id > 0) {
                Source.remove(source_id);
            }

            uint interval = this.settings.get_int("update-interval");
            interval = interval * 1000;
            source_id = GLib.Timeout.add_full(GLib.Priority.DEFAULT, interval, update);
        }

        private unowned bool update () {
            if (ram_flag) {
                mem_val.label = " %d%% ".printf(Providers.Memory.memory_percent);
            }

            if (cpu_flag) {
                cpu_val.label = " %d%% ".printf(Providers.CPU.percentage_used);
            }

            return true;
        }

        private unowned bool update_popover () {
            popover_grid.main_view.update ();
            return true;
        }

        public override void update_popovers(Budgie.PopoverManager? manager){
            this.manager = manager;
            manager.register_popover(widget, popover);
        }
    }

    /* void print(string? message) {
        if (message == null) message = "";
        stdout.printf ("Budgie-Sys-Monitor: %s\n", message);
    } */

}

[ModuleInit]
public void peas_register_types(TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof(Budgie.Plugin), typeof(SysMonitorApplet.Plugin));
}
