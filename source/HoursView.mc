import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class HoursView extends TextComponent {
    (:debug)
    public var name as Lang.String = "HoursView";
    private var _oldHour as Lang.Number = -1;
    private var _newHour as Lang.Number = -1;

    // private var drawnHour as Lang.Number;
    // private var newHour as Lang.Number;
    // private var font as Graphics.FontType;

    public function initialize(params as { :font as Graphics.FontType }) {
        TextComponent.initialize({
            :font => params.get(:font) as Graphics.FontType,
            :text => "10",
            :justify => Graphics.TEXT_JUSTIFY_RIGHT,
        });
    }

    public function doUpdate(time as Lang.Number) as Boolean {
        // If hour is different from drawn hour, then update
        self._newHour = System.getClockTime().hour;
        if (self._newHour != self._oldHour) {
            return true;
        }
        return false;
    }

    protected function draw(bdc as Dc) as Void {
        self.setText("" + self._newHour);
        TextComponent.draw(bdc);
        self._oldHour = self._newHour;
    }
}
