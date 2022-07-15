import Toybox.Lang;
import Toybox.Math;
import Toybox.Time;
import Toybox.ActivityMonitor;

(:debug)
class MockHeartRateSample {
    public var heartRate as Lang.Number?;
    public var when as Time.Moment?;

    function initialize(heartRate as Lang.Number?, when as Time.Moment?) {
        self.heartRate = heartRate;
        self.when = when;
    }
}

(:debug)
class MockActivityMonitorInfo {
    public var calories as Lang.Number = 1892;
    public var steps as Lang.Number = 1402;
    public var stepGoal as Lang.Number = 5120;

    function initialize(mockCount as Lang.Number) {
        // self.steps =
        // self.steps += mockCount;
        self.calories += mockCount * 20;
    }
}

(:debug)
class MockHeartRateIterator {
    private var _i as Lang.Number = 0;
    private var _period as Time.Duration;
    private var _start as Time.Moment;

    function initialize(period as Time.Duration) {
        self._period = period;
        self._start = Time.now();
    }

    public function getMax() as Lang.Number? {
        return null;
    }

    public function getMin() as Lang.Number? {
        return null;
    }

    public function next() as MockHeartRateSample {
        self._i++;
        var duration = (new Time.Duration(60)).multiply(self._i);
        var moment = self._start.subtract(duration) as Time.Moment;
        var hr = 50 + (Math.rand() % 10);
        if (self._i > 60 && self._i < 100) {
            hr = self._i + (Math.rand() % 10);
        }
        return new MockHeartRateSample(hr, moment);
    }
}

(:debug)
module MockActivityMonitor {
    var _infoCallCount as Lang.Number = 0;

    function getHeartRateHistory(
        period as Time.Duration /*or Lang.Number or Null,*/,
        newestFirst as Lang.Boolean
    ) as MockHeartRateIterator {
        return new MockHeartRateIterator(period);
    }

    function getInfo() as MockActivityMonitorInfo {
        self._infoCallCount += 1;
        return new MockActivityMonitorInfo(self._infoCallCount);
    }
}
