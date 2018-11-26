public class SysMonitorApplet.Providers.Uptime {
    private static string _uptime;
    public static string get_uptime {
        get {
            GTop.Uptime uptime;
            GTop.get_uptime (out uptime);
            DateTime unix_uptime = new DateTime.from_unix_utc((int)uptime.uptime);
            _uptime = unix_uptime.format("%H:%M:%S");
            return _uptime;
        }
    }
}
