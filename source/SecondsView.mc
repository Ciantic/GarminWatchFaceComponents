import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

typedef FontSettings as {
        :font as Graphics.FontType,
        :justify as Lang.Number?,
    };

class SecondsView extends Component {
    (:debug)
    public var name as Lang.String = "SecondsView";

    private var drawnSeconds as Lang.Number;
    private var newSeconds as Lang.Number;
    private var settings as FontSettings;

    public function initialize(params as FontSettings) {
        if (params[:justify] == null) {
            params[:justify] = Graphics.TEXT_JUSTIFY_LEFT;
        }
        var font = params.get(:font) as Graphics.FontType?;
        if (font == null) {
            throw new InvalidValueException("Font must be given");
        }
        self.newSeconds = -1;
        self.drawnSeconds = -1;
        self.settings = params;
        var height = Graphics.getFontHeight(font);
        Component.initialize({
            :width => height,
            :height => height,
        });
    }

    public function doUpdate(time as Lang.Number) as Boolean {
        // If minutes is different from drawn minutes, then update
        newSeconds = System.getClockTime().sec;
        if (newSeconds != drawnSeconds) {
            return true;
        }
        return false;
    }

    protected function draw(bdc as Dc) as Void {
        // System.println("Draw secs " + newSeconds);
        bdc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        bdc.clear();
        bdc.drawText(
            0,
            0,
            self.settings.get(:font) as Graphics.FontType,
            Lang.format("$1$", [newSeconds.format("%02d")]),
            self.settings[:justify] as Lang.Number
        );
        drawnSeconds = newSeconds;
    }
}
