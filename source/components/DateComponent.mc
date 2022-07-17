import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

typedef DateComponentSettings as {
        :format as Lang.String?,
        :textSettings as TextSettings,
    };

class DateComponent extends TextComponent {
    (:debug)
    public var name as Lang.String = "DateComponent";
    private var _today as Lang.Number;

    public function initialize(params as DateComponentSettings) {
        self._today = Time.today().value();

        var textSettings = params.get(:textSettings) as TextSettings;
        textSettings[:strlen] = 10;
        TextComponent.initialize(textSettings);
    }

    public function update() as Void {
        var newToday = Time.today().value();
        if (newToday != self._today) {
            self._today = newToday;
            self._invalid = true;
        }
    }

    protected function draw(dc as Dc) as Void {
        var dm = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dow = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM).day_of_week;
        self._text = "" + dm.day + "." + dm.month + "." + " " + dow;
        TextComponent.draw(dc);
    }
}
