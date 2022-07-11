import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class WatchFaceDelegate extends WatchUi.WatchFaceDelegate {
    public function initialize() {
        WatchUi.WatchFaceDelegate.initialize();
    }

    public function onPowerBudgetExceeded(
        powerInfo as WatchFacePowerInfo
    ) as Void {
        GLOBAL_STATE.onPowerBudgetExceeded(powerInfo);
    }
}
