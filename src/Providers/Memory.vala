namespace SysMonitorApplet.Providers {
    public class Memory {
        public static int memory_percent {
            get {
                GTop.Memory memory;
                GTop.get_mem (out memory);
                return (int) Math.round (((double)memory.user / (double)memory.total) * 100);
            }
        }
        public static double[] get_memory () {
                GTop.Memory memory;
                GTop.get_mem (out memory);
                double[] result;
                result = {(double)memory.user, (double)memory.total};
                return result;
        }
        public static double[] get_swap () {
                GTop.Swap swap;
                GTop.get_swap (out swap);
                double[] result;
                result = {(double)swap.used, (double)swap.total};
                return result;
        }
    }
}
