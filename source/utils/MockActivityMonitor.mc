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
class MockHeartRateIterator {
    private var _i as Lang.Number = 0;
    private var _period as Time.Duration;

    function initialize(period as Time.Duration) {
        self._period = period;
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
        var moment = Time.now().subtract(duration) as Time.Moment;
        return new MockHeartRateSample(Math.rand() % 150, moment);
    }
}

(:debug)
module MockActivityMonitor {
    function getHeartRateHistory(
        period as Time.Duration /*or Lang.Number or Null,*/,
        newestFirst as Lang.Boolean
    ) as HeartRateIterator {
        return new MockHeartRateIterator(period) as HeartRateIterator;
    }
}
