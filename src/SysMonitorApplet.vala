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
        private Gtk.Image mem_image;
        private Gtk.Label mem_label;
        
        private Gtk.Label cpu_val;
        private Gtk.Label cpu_label;
        private Gtk.Image cpu_image;
        
        private Gtk.Label netu_val;
        private Gtk.Image netu_image;
        private Gtk.Label netu_label;
        
        private Gtk.Label netd_val;
        private Gtk.Label netd_label;
        private Gtk.Image netd_image;
        
        private Gtk.Label netc_val;
        private Gtk.Image netc_image;
        private Gtk.Label netc_label;
        
        private Gtk.Label nett_val;
        private Gtk.Label nett_label;
        private Gtk.Image nett_image;

        private bool cpu_flag;
        private bool ram_flag;
        private bool nets_flag;
        private bool netc_flag;
        private bool nett_flag;
        
        public string[] current = {"0","0"};
        public int[] lastnet = {0,0,0,0};

        public string uuid { public set; public get; }
        private uint source_id;
        private uint source_id_pop;

        private Settings? settings;

        public Applet(string uuid) {
            Object(uuid: uuid);

            settings_schema = "com.prateekmedia.systemmonitor";
            settings_prefix = "/com/prateekmedia/systemmonitor";
            settings = get_applet_settings(uuid);
            settings.changed.connect(on_settings_change);

            cpu_label = new Gtk.Label ("cpu");
            cpu_image = new Gtk.Image.from_icon_name("cpu-symbolic", Gtk.IconSize.BUTTON);
            cpu_val = new Gtk.Label ("-");

            mem_label = new Gtk.Label ("mem");
            mem_image = new Gtk.Image.from_icon_name("ram-symbolic", Gtk.IconSize.BUTTON);
            mem_val = new Gtk.Label ("-");
            
            netu_label = new Gtk.Label ("up");
            netu_image = new Gtk.Image.from_icon_name("net-up-symbolic", Gtk.IconSize.BUTTON);
            netu_val = new Gtk.Label ("-");

            netd_label = new Gtk.Label ("down");
            netd_image = new Gtk.Image.from_icon_name("net-down-symbolic", Gtk.IconSize.BUTTON);
            netd_val = new Gtk.Label ("-");
            
            netc_label = new Gtk.Label ("total");
            netc_image = new Gtk.Image.from_icon_name("net-compact-symbolic", Gtk.IconSize.BUTTON);
            netc_val = new Gtk.Label ("-");

            nett_label = new Gtk.Label ("data");
            nett_image = new Gtk.Image.from_icon_name("net-sigma-symbolic", Gtk.IconSize.BUTTON);
            nett_val = new Gtk.Label ("-");

            Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            
            Gtk.Image[] elements = {cpu_image, mem_image, netu_image, netd_image, netc_image, nett_image};
            Gtk.Label[] e_labels = {cpu_label, mem_label, netu_label, netd_label, netc_label, nett_label};
            Gtk.Label[] e_vals = {cpu_val, mem_val, netu_val, netd_val, netc_val, nett_val};
            
            for(int i=0; i < elements.length; i++){
                box.pack_start (elements[i], false, false, 0);
                box.pack_start (e_labels[i], false, false, 0); 
                box.pack_start (e_vals[i], false, false, 0);
            }

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
            on_settings_change ("show-cpu");
            on_settings_change ("show-ram");
            on_settings_change ("show-nets");
            on_settings_change ("show-netc");
            on_settings_change ("show-nett");
            enable_timer ();
        }

        protected void on_settings_change(string key) {
            cpu_flag = settings.get_boolean("show-cpu");
            ram_flag = settings.get_boolean("show-ram");
            nets_flag = settings.get_boolean("show-nets");
            netc_flag = settings.get_boolean("show-netc");
            nett_flag = settings.get_boolean("show-nett");
            int show_what = settings.get_int("show-what");

            switch (key) {
                case "update-interval":
                    enable_timer ();
                    break;

                case "show-what":
                    show_label_or_image(show_what, mem_label, mem_image, ram_flag);
                    show_label_or_image(show_what, cpu_label, cpu_image, cpu_flag);
                    show_label_or_image(show_what, netu_label, netu_image, nets_flag);
                    show_label_or_image(show_what, netd_label, netd_image, nets_flag);
                    show_label_or_image(show_what, netc_label, netc_image, netc_flag);
                    show_label_or_image(show_what, nett_label, nett_image, nett_flag);
                    break;

                case "show-cpu":
                    show_label_or_image(show_what, cpu_label, cpu_image, cpu_flag, cpu_val);
                    break;

                case "show-ram":
                    show_label_or_image(show_what, mem_label, mem_image, ram_flag, mem_val);
                    break;

                case "show-nets":
                    show_label_or_image(show_what, netu_label, netu_image, nets_flag, netu_val);
                    show_label_or_image(show_what, netd_label, netd_image, nets_flag, netd_val);
                    break;

                case "show-netc":
                    show_label_or_image(show_what, netc_label, netc_image, netc_flag, netc_val);
                    break;

                case "show-nett":
                    show_label_or_image(show_what, nett_label, nett_image, nett_flag, nett_val);
                    break;
            }

            queue_resize();
        }
        
        protected void show_label_or_image(int show_what, Gtk.Label which_label, Gtk.Image which_image, bool which_flag, Gtk.Label which_val = new Gtk.Label(null)){
            which_val.set_visible(which_flag);
            
            which_label.set_visible(false);
            which_image.set_visible(false);
            
            if(which_flag){
                if (show_what == 1){
                    which_label.set_visible(true);
                } else if (show_what == 2){
                    which_image.set_visible(true);
                }
            }
        }

        private void enable_timer () {
            if (source_id > 0) {
                Source.remove(source_id);
            }

            uint interval = settings.get_int("update-interval");
            interval = interval * 1000;
            source_id = GLib.Timeout.add_full(GLib.Priority.DEFAULT, interval, update);
        }

        private unowned bool update () {
            // print("\n 1");
            Gee.HashMap<string,string> net_val = new Providers.Net ().get_bytes();
            
            current = {"0","0"};
            
            foreach (var entry in net_val.entries) {
                string[] val_array = entry.value.split (":");
                if (val_array[0] != "0" || val_array[1] != "0") {
                    lastnet[2] = int.parse(val_array[0]) - lastnet[0];
                    lastnet[3] = int.parse(val_array[1]) - lastnet[1];
                    lastnet[0] = int.parse(val_array[0]);
                    lastnet[1] = int.parse(val_array[1]);
                    current[0] = Utils.format_net_speed (lastnet[2]);
                    current[1] = Utils.format_net_speed (lastnet[3]);
                }
            }
            
            if (ram_flag) {
                set_value (mem_val, Providers.Memory.memory_percent);
            }

            if (cpu_flag) {
                set_value (cpu_val, Providers.CPU.percentage_used);
            }
            
            if (nets_flag) {
                set_net_value (netu_val, current[0]);
                set_net_value (netd_val, current[1]);
            }
            
            if (netc_flag) {
                set_net_value (netc_val, Utils.format_net_speed (lastnet[2] + lastnet[3]));
            }
            
            if (nett_flag) {
                set_net_value (nett_val, Utils.format_net_speed (lastnet[0] + lastnet[1], true));
            }

            return true;
        }

        private void set_value (Gtk.Label changeable_label, int val) {
            changeable_label.label = " %d%% ".printf(val);
            Gtk.StyleContext ctx = changeable_label.get_style_context();
            if (val > 85 && !ctx.has_class("alert")) {
                ctx.add_class("alert");
            } else if (val < 85 && ctx.has_class("alert")) {
                ctx.remove_class("alert");
            }
        }

        private void set_net_value (Gtk.Label changeable_label, string val) {
            changeable_label.label = val;
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
