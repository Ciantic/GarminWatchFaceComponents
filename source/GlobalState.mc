import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;

class GlobalState {
    private var _time as System.ClockTime;
    private var _powerBudgetInfo as WatchFacePowerInfo?;
    private var _activity as Toybox.Activity.Info?;

    public function initialize() {
        self._time = System.getClockTime();
    }

    public function update() as Void {
        self._time = System.getClockTime();
        self._activity = Activity.getActivityInfo();
        // var monitor = ActivityMonitor.getInfo();
        ActivityMonitor.getHeartRateHistory(new Time.Duration(3600), true);
    }

    public function updatePartial() as Void {
        self._time = System.getClockTime();
    }

    public function getClockTime() as System.ClockTime {
        return self._time;
    }

    public function getLastHeartRate() as Lang.Number {
        var activity = self._activity;
        if (activity != null) {
            var hr = activity.currentHeartRate;
            if (hr != null) {
                return hr;
            }
        }
        return 0;
    }

    public function getPowerBudgetExceededInfo() as WatchFacePowerInfo? {
        return self._powerBudgetInfo;
    }

    public function onPowerBudgetExceeded(
        powerInfo as WatchFacePowerInfo
    ) as Void {
        self._powerBudgetInfo = powerInfo;
    }
}

const GLOBAL_STATE as GlobalState = new GlobalState() as GlobalState;
