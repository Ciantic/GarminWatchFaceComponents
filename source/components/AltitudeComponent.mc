import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class AltitudeComponent extends NumericComponent {
    (:debug)
    public var name as Lang.String = "AltitudeComponent";

    public function initialize(params as NumericSettings) {
        params[:value] = 0;
        params[:digits] = 4;
        params[:format] = "%d";
        NumericComponent.initialize(params);
    }

    public function update() as Void {
        self.setValue(GLOBAL_STATE.getAltitude());
    }
}
