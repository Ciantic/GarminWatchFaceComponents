import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class MetersClimbedComponent extends NumericComponent {
    (:debug)
    public var name as Lang.String = "MetersClimbedComponent";

    public function initialize(params as NumericSettings) {
        params[:value] = 0;
        params[:digits] = 4;
        params[:format] = "%d";
        params[:suffix] = "m";
        NumericComponent.initialize(params);
    }

    public function update() as Void {
        self.setValue(GLOBAL_STATE.getMetersClimbed());
    }
}
