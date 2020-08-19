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

public class SysMonitorApplet.Providers.Net  : GLib.Object {
    public Gee.HashMap<string, string> devices_map;

    public Net () {
        devices_map = new Gee.HashMap<string, string> ();
        GTop.NetList netlist;
        var devices = GTop.get_netlist (out netlist);

        for (uint j = 0; j < netlist.number; ++j) {
            var device = devices[j];

            if (device != "lo" && !device.has_prefix ("tun") && !device.has_prefix ("br") && !device.has_prefix ("veth") && !device.has_prefix ("vir")) {
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

            if (device != "lo" && !device.has_prefix ("tun") && !device.has_prefix ("br") && !device.has_prefix ("veth") && !device.has_prefix ("vir")) {
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
