public class SysMonitorApplet.Providers.Net  : GLib.Object {
    public Gee.HashMap<string, string> devices_map;
    public Net () {
        devices_map = new Gee.HashMap<string, string> ();
        GTop.NetList netlist;
        var devices = GTop.get_netlist (out netlist);
        for (uint j = 0; j < netlist.number; ++j) {
            var device = devices[j];
            if (device != "lo" && device.substring (0, 3) != "tun") {
                devices_map[device] = "0:0";
            }
        }
    }
    public Gee.HashMap<string, string> get_bytes() {
        Gee.HashMap<string, string> net_speed = new Gee.HashMap<string, string> ();
        GTop.NetList netlist;
        GTop.NetLoad netload;
        var devices = GTop.get_netlist (out netlist);

        for (uint j = 0; j < netlist.number; ++j) {
            var device = devices[j];
            if (device != "lo" && device.substring (0, 3) != "tun") {
                GTop.get_netload (out netload, device);
                int new_bytes_out = (int) netload.bytes_out;
                int new_bytes_in = (int) netload.bytes_in;
                string[] old_values = devices_map[device].split(":");
                int bytes_out = (new_bytes_out - int.parse(old_values[0]));
                int bytes_in = (new_bytes_in - int.parse(old_values[1]));
                net_speed[device] = "%d".printf(bytes_out) + ":" + "%d".printf(bytes_in);
                devices_map[device] = "%d".printf(new_bytes_out) + ":" + "%d".printf(new_bytes_in);
            }
        }

        return net_speed;
    }
}
