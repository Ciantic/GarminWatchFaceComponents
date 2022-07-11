import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class HoursComponent extends NumericComponent {
    (:debug)
    public var name as Lang.String = "HoursComponent";

    public function initialize(params as NumericSettings) {
        params[:value] = 0;
        NumericComponent.initialize(params);
    }

    public function update() as Void {
        self.setValue(GLOBAL_STATE.time.hour);
    }
}
