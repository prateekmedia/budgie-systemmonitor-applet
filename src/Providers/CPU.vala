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

public class SysMonitorApplet.Providers.CPU  : GLib.Object {
    private static float last_total;
    private static float last_used;

    public static int percentage_used {
        get {
            GTop.Cpu cpu;
            GTop.get_cpu (out cpu);
            var used = cpu.user + cpu.nice + cpu.sys;                               // get cpu used
            var difference_used = (float)used - last_used;                          // calculate the difference used
            var difference_total = (float)cpu.total - last_total;                   // calculate the difference total
            var pre_percentage = difference_used.abs () / difference_total.abs ();  // calculate the pre percentage
            last_used = (float)used;
            last_total = (float)cpu.total;
            return (int)Math.round (pre_percentage * 100);
        }
    }

    public static double frequency () {
        double max_freq = 0;

        for (uint i = 0; i < (int)get_num_processors (); ++i) {
            string cur_value;
            try {
                GLib.FileUtils.get_contents (@"/sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq", out cur_value);
            } catch (Error e) {
                cur_value = "0";
            }

            var cur = double.parse (cur_value);


            max_freq = i == 0 ? cur : double.max (cur, max_freq);
        }

        return max_freq;
    }
}
