namespace SysMonitorApplet {
    public class Widgets.MainView : Gtk.Grid {
        private Gtk.Label ram_value_label;
        private Gtk.Label swap_value_label;
        private Gtk.Label freq_value_label;
        private Gtk.Label uptime_value_label;
        private Gee.HashMap<string, Gtk.Label> net_map;
        private Providers.Net net;

        private Settings? settings;

        public MainView (Settings? settings) {
            name = "main";
            orientation = Gtk.Orientation.HORIZONTAL;
            hexpand = true;
            column_spacing = 40; // to add space between label and value label
            row_spacing = 2;
            this.settings = settings;
        }

        construct {
            net_map = new Gee.HashMap<string, Gtk.Label> ();
            net = new Providers.Net ();

            var freq_label = create_name_label (_("Frequency:"));
            freq_value_label = create_value_label ();
            freq_label.margin_bottom = freq_value_label.margin_bottom = 6;
            freq_label.margin_top = freq_value_label.margin_top = 6;

            var ram_label = create_name_label (_("Ram:"));
            ram_value_label = create_value_label ();
            ram_label.margin_bottom = ram_value_label.margin_bottom = 6;

            var swap_label = create_name_label (_("Swap:"));
            swap_value_label = create_value_label ();
            swap_label.margin_bottom = swap_value_label.margin_bottom = 6;

            var uptime_label = create_name_label (_("Uptime:"));
            uptime_value_label = create_value_label ();
            uptime_label.margin_bottom = uptime_value_label.margin_bottom = 6;
            uptime_label.margin_top = uptime_value_label.margin_top = 6;

            var network_label = create_name_label (_("Network"));
            network_label.halign = Gtk.Align.CENTER;
            network_label.margin_bottom = 6;
            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;
            int top = 0;
            attach (freq_label,         1, top, 1, 1);
            attach (freq_value_label,   2, top, 1, 1);
            top += 1;
            attach (ram_label,          1, top, 1, 1);
            attach (ram_value_label,    2, top, 1, 1);
            top += 1;
            attach (swap_label,         1, top, 1, 1);
            attach (swap_value_label,   2, top, 1, 1);
            top += 1;
            attach (network_label,       1, top, 2, 1);
            foreach (var entry in net.devices_map.entries) {
                top += 1;
                var net_label = create_name_label (entry.key);
                var net_value_label = create_value_label ();
                net_value_label.set_width_chars (10);
                net_value_label.set_justify (Gtk.Justification.FILL);
                net_map[entry.key] = net_value_label;
                attach (net_label,       1, top, 1, 1);
                attach (net_value_label, 2, top, 1, 1);
            }
            top += 1;
            attach (uptime_label,       1, top, 1, 1);
            attach (uptime_value_label, 2, top, 1, 1);
        }
        private Gtk.Label create_name_label (string label_name) {
            var label = new Gtk.Label (label_name);
            label.halign = Gtk.Align.START;
            label.margin_start = 9;
            return label;
        }
        private Gtk.Label create_value_label (string label_name="") {
            var label = new Gtk.Label (label_name);
            label.halign = Gtk.Align.END;
            label.get_style_context ().add_class ("menuitem");
            label.margin_end = 9;
            return label;
        }
        public unowned bool update () {
            update_ram ();
            update_freq ();
            update_swap ();
            update_uptime ();
            update_net_speed ();
            return true;
        }
        public void update_freq () {
            double frequency = Providers.CPU.frequency;
            freq_value_label.set_label (Utils.format_frequency (frequency));
        }
        private void update_ram () {
            double[] ram = Providers.Memory.get_memory();
            ram_value_label.set_label ("%s / %s".printf (Utils.format_size(ram[0]), Utils.format_size(ram[1])));
        }
        private void update_swap () {
            double[] swap = Providers.Memory.get_swap();
            swap_value_label.set_label ("%s / %s".printf (Utils.format_size (swap[0]), Utils.format_size (swap[1])));
        }
        private void update_uptime () {
            string uptime = Providers.Uptime.get_uptime;
            uptime_value_label.set_label (uptime);
        }
        public void update_net_speed () {
            Gee.HashMap<string,string> net_val = net.get_bytes();
            foreach (var entry in net_val.entries) {
                string[] val_array = entry.value.split (":");
                var down = Utils.format_net_speed (int.parse(val_array[1]), false);
                var up = Utils.format_net_speed(int.parse(val_array[0]), false);
                net_map[entry.key].set_label ("D: " + down + " \nU: " + up);
            }
        }
    }
}
