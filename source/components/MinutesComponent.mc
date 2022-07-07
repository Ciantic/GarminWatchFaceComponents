import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class MinutesView extends TextComponent {
    (:debug)
    public var name as Lang.String = "MinutesView";

    public function initialize(params as TextSettings) {
        params[:text] = "  ";
        TextComponent.initialize(params);
    }

    public function update(time as Lang.Number) as Void {
        self.setText(System.getClockTime().min.format("%02d"));
    }
}
