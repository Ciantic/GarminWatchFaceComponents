import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class HeartRateComponent extends NumericComponent {
    (:debug)
    public var name as Lang.String = "MinutesComponent";

    public function initialize(params as NumericSettings) {
        params[:value] = 0;
        params[:digits] = 3;
        params[:format] = "%d";
        NumericComponent.initialize(params);
    }

    public function update() as Void {
        self.setValue(GLOBAL_STATE.getLastHeartRate());
    }
}
