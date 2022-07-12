import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.Math;

// VSCode's go to defintion/find references between files works with modules but
// not with classes, thus I chose module for the global state.

module GLOBAL_STATE {
    var _lastUpdateTime as System.ClockTime = System.getClockTime();
    var _time as System.ClockTime = System.getClockTime();
    var _powerBudgetInfo as WatchFacePowerInfo? = null;
    var _activity as Activity.Info? = null;
    var _isSleeping as Boolean = false;
    var _isHidden as Boolean = false;

    function update() as Void {
        self._time = System.getClockTime();
        self._lastUpdateTime = self._time;
        self._updateActivity();
    }

    function updatePartial() as Void {
        self._time = System.getClockTime();
        // Update activity data every 5th second?
        if (self._time.sec % 5 == 0) {
            self._updateActivity();
        }
    }

    // Getters

    function getClockTime() as System.ClockTime {
        return self._time;
    }
    function getLastUpdateTime() as System.ClockTime {
        return self._lastUpdateTime;
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

    function isSleeping() as Boolean {
        return self._isSleeping;
    }

    function isHidden() as Boolean {
        return self._isHidden;
    }

    // Internal setters
    (:release)
    function _updateActivity() as Void {
        self._activity = Activity.getActivityInfo();
    }

    (:debug)
    function _updateActivity() as Void {
        if (self._activity == null) {
            self._activity = new MockActivityInfo() as Activity.Info;
        } else {
            (self._activity as MockActivityInfo).update();
        }
    }

    // External setters

    function onPowerBudgetExceeded(powerInfo as WatchFacePowerInfo) as Void {
        self._powerBudgetInfo = powerInfo;
    }

    function onEnterSleep() as Void {
        self._isSleeping = true;
    }

    function onExitSleep() as Void {
        self._isSleeping = false;
    }

    function onShow() as Void {
        self._isHidden = false;
    }

    function onHide() as Void {
        self._isHidden = true;
    }
}
