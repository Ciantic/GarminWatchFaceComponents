import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time;

// VSCode's go to defintion/find references between files works with modules but
// not with classes, thus I chose module for the global state.

module GLOBAL_STATE {
    var _time as System.ClockTime = System.getClockTime();
    var _powerBudgetInfo as WatchFacePowerInfo? = null;
    var _activity as Toybox.Activity.Info? = null;

    function update() as Void {
        self._time = System.getClockTime();
        self._activity = Activity.getActivityInfo();
        // var monitor = ActivityMonitor.getInfo();
        ActivityMonitor.getHeartRateHistory(new Time.Duration(3600), true);
    }

    function updatePartial() as Void {
        self._time = System.getClockTime();
    }

    function getClockTime() as System.ClockTime {
        return self._time;
    }

    function getLastHeartRate() as Lang.Number {
        var activity = self._activity;
        if (activity != null) {
            var hr = activity.currentHeartRate;
            if (hr != null) {
                return hr;
            }
        }
        return 0;
    }

    function getPowerBudgetExceededInfo() as WatchFacePowerInfo? {
        return self._powerBudgetInfo;
    }

    function onPowerBudgetExceeded(powerInfo as WatchFacePowerInfo) as Void {
        self._powerBudgetInfo = powerInfo;
    }
}
