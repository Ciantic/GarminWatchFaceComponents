import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;

class GlobalState {
    public var time as System.ClockTime;
    public var powerBudgetExceeded as Boolean = false;
    public var executionTimeAverage as Lang.Float?;
    public var executionTimeLimit as Lang.Float?;

    public function initialize() {
        self.time = System.getClockTime();
    }

    public function update() as Void {
        self.time = System.getClockTime();
    }

    public function updatePartial() as Void {
        self.time = System.getClockTime();
    }

    public function onPowerBudgetExceeded(
        powerInfo as WatchFacePowerInfo
    ) as Void {
        self.powerBudgetExceeded = true;
        self.executionTimeAverage = powerInfo.executionTimeAverage;
        self.executionTimeLimit = powerInfo.executionTimeLimit;
    }
}

var GLOBAL_STATE as GlobalState = new GlobalState();
