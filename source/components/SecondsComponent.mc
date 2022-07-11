import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class SecondsComponent extends NumericComponent {
    (:debug)
    public var name as Lang.String = "SecondsComponent";

    public function initialize(params as NumericSettings) {
        params[:value] = 0;
        params[:format] = "%02d";
        NumericComponent.initialize(params);
    }

    public function update() as Void {
        self.setValue(GLOBAL_STATE.time.sec);
    }
}
