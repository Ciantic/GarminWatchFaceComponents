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
    var _initialized as System.ClockTime = System.getClockTime();
    var _layoutTime as System.ClockTime = System.getClockTime();
    var _lastUpdateTime as System.ClockTime = System.getClockTime();
    var _time as System.ClockTime = System.getClockTime();
    var _powerBudgetInfo as WatchFacePowerInfo? = null;
    var _activity as Activity.Info? = null;
    var _activityMonitorInfo as ActivityMonitor.Info? = null;
    var _isSleeping as Boolean = false;
    var _isHidden as Boolean = false;
    var _fromLayout as Number = 0;
    var _isUpdate as Boolean = false;
    var _isPartialUpdate as Boolean = false;

    function update() as Void {
        self._isUpdate = true;
        self._isPartialUpdate = false;
        self._time = System.getClockTime();
        self._lastUpdateTime = self._time;
        self._fromLayout += 1;
        self._updateActivity();
        if (self.onceInUpdate()) {
            self._updateActivityMonitorInfo();
        }
    }

    function updatePartial() as Void {
        self._isUpdate = false;
        self._isPartialUpdate = true;
        self._time = System.getClockTime();
        // Update activity data every 5th second?
        // if (self._time.sec % 5 == 0) {
        //     self._updateActivity();<
        // }
    }

    // Getters
    function isPartialUpdate() as Boolean {
        return self._isPartialUpdate;
    }
    function getClockTime() as System.ClockTime {
        return self._time;
    }
    function getLastUpdateTime() as System.ClockTime {
        return self._lastUpdateTime;
    }
    function getInitializeTime() as System.ClockTime {
        return self._initialized;
    }
    function getLayoutTime() as System.ClockTime {
        return self._layoutTime;
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

    function getSteps() as Lang.Number {
        var activity = self._activityMonitorInfo;
        if (activity != null) {
            var steps = activity.steps;
            if (steps != null) {
                return steps;
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

    function afterLayoutInSecs(nth as Lang.Number) as Boolean {
        return self._isUpdate && self._fromLayout > nth;
    }

    // function isUpdate() as Boolean {
    //     return self._isUpdate;
    // }

    function onceInUpdate() as Boolean {
        return self._fromLayout == 1 || (self._isUpdate && self._time.sec == 0);
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

    (:release)
    function _updateActivityMonitorInfo() as Void {
        self._activityMonitorInfo = ActivityMonitor.getInfo();
    }

    (:debug)
    function _updateActivityMonitorInfo() as Void {
        self._activityMonitorInfo =
            MockActivityMonitor.getInfo() as ActivityMonitor.Info;
    }

    // External setters

    function onPowerBudgetExceeded(powerInfo as WatchFacePowerInfo) as Void {
        self._powerBudgetInfo = powerInfo;
        log(
            "Budget exceeded " +
                powerInfo.executionTimeAverage +
                " of " +
                powerInfo.executionTimeLimit
        );
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

    function onLayout() as Void {
        self._fromLayout = 0;
        self._layoutTime = System.getClockTime();
    }
}
