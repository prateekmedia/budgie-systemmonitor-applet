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
