import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class MinutesView extends Component {
    (:debug)
    public var name as Lang.String = "MinutesView";

    private var drawnMinutes as Lang.Number;
    private var newMinutes as Lang.Number;
    private var font as Graphics.FontType;

    public function initialize(params as { :font as Graphics.FontType }) {
        var font = params.get(:font) as Graphics.FontType?;
        if (font == null) {
            throw new InvalidValueException("Font must be given");
        }
        self.font = font;
        var height = Graphics.getFontHeight(font);
        Component.initialize({
            :width => height,
            :height => height,
        });
        self.drawnMinutes = -1;
        self.newMinutes = -1;
    }

    public function doUpdate(time as Lang.Number) as Boolean {
        // If minutes is different from drawn minutes, then update
        self.newMinutes = System.getClockTime().min;
        if (self.newMinutes != self.drawnMinutes) {
            System.println("Update minutes");
            return true;
        }
        return false;
    }

    protected function draw(bdc as Dc) as Void {
        bdc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        bdc.clear();
        bdc.drawText(
            0,
            0,
            font,
            Lang.format("$1$", [self.newMinutes.format("%02d")]),
            Graphics.TEXT_JUSTIFY_LEFT
        );
        self.drawnMinutes = self.newMinutes;

        System.println("Draw minutes");
    }
}
