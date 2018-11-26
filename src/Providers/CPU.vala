public class SysMonitorApplet.Providers.CPU  : GLib.Object {
    private static float last_total;
    private static float last_used;
    private static int _percentage_used;
    public static int percentage_used {
        get {
            GTop.Cpu cpu;
            GTop.get_cpu (out cpu);
            var used = cpu.user + cpu.nice + cpu.sys;                               // get cpu used
            var difference_used = (float)used - last_used;                          // calculate the difference used
            var difference_total = (float)cpu.total - last_total;                   // calculate the difference total
            var pre_percentage = difference_used.abs () / difference_total.abs ();  // calculate the pre percentage
            _percentage_used = (int)Math.round (pre_percentage * 100);
            last_used = (float)used;
            last_total = (float)cpu.total;
            return _percentage_used;
        }
    }
    public static double frequency {
        get {
            double maxcur = 0;
            for (uint i = 0, isize = (int)get_num_processors (); i < isize; ++i) {
                var cur = 1000.0 * read (i, "scaling_cur_freq");
                if (i == 0) {
                    maxcur = cur;
                } else {
                    maxcur = double.max (cur, maxcur);
                }
            }
            return (double) maxcur;
        }
    }
    private static double read (uint cpu, string what) {
        string value;
        try {
            FileUtils.get_contents (@"/sys/devices/system/cpu/cpu$cpu/cpufreq/$what", out value);
        } catch (Error e) {
            value = "0";
        }
        return double.parse (value);
    }
}
