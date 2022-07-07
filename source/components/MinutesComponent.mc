import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class MinutesComponent extends NumericComponent {
    (:debug)
    public var name as Lang.String = "MinutesComponent";

    public function initialize(params as NumericSettings) {
        params[:value] = 0;
        params[:format] = "%02d";
        NumericComponent.initialize(params);
    }

    public function update(time as Lang.Number) as Void {
        self.setValue(System.getClockTime().min);
    }
}
