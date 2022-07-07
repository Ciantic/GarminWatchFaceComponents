import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Test;

(:debug)
class BenchRun {
    public var count as Lang.Number = 0;
    public var start as Lang.Number = -1;
    public var last as Lang.Number = -1;
    public var avg as Lang.Number = -1;
}

(:debug)
class Bench {
    private var running as Array<Lang.String> = [] as Array<Lang.String>;

    private var benches as Dictionary<String, BenchRun> =
        {} as Dictionary<String, BenchRun>;

    public function start(name as Lang.String) as Void {
        var benchRun = self.benches[name] as BenchRun;
        if (benchRun == null) {
            benchRun = new BenchRun();
            benches[name] = benchRun;
        }
        benchRun.start = System.getTimer();
    }

    public function end(name as Lang.String) as Void {
        var benchRun = self.benches[name] as BenchRun;
        if (benchRun == null) {
            return;
        }

        benchRun.last = System.getTimer() - benchRun.start;
        benchRun.count += 1;
        if (benchRun.count % 5 == 0) {
            System.println("Last time " + name + " " + benchRun.last);
        }
    }
}

(:debug)
var bench as Bench = new Bench();

(:debug)
function bench_start(name as Lang.String) as Void {
    bench.start(name);
}

(:debug)
function bench_end(name as Lang.String) as Void {
    bench.start(name);
}
