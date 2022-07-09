import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class DialSecondComponent extends Component {
    (:debug)
    public var name as Lang.String = "DialSecondComponent";
    private var _seconds as Lang.Number = -1;
    private var _oldSeconds as Lang.Number?;
    private var _invalidatedArea as MyBoundingBox?;
    private var _lastDrawArea as MyBoundingBox?;
    private var _drawArea as MyBoundingBox?;

    public function initialize(box as MyBoundingBox) {
        Component.initialize(box);
    }

    public function update(time as Lang.Number) as Void {
        var newSeconds = System.getClockTime().sec;
        if (self._seconds != newSeconds) {
            self._oldSeconds = self._seconds;
            self._seconds = newSeconds;
            self._invalid = true;
        }
    }

    public function getInvalidAreas() as Lang.Array<MyBoundingBox> {
        if (self._invalidatedArea != null) {
            return [self._invalidatedArea] as Lang.Array<MyBoundingBox>;
        }
        return [] as Lang.Array<MyBoundingBox>;
    }

    public function getDrawnAreas() as Lang.Array<MyBoundingBox> {
        if (self._drawArea != null) {
            return [self._drawArea] as Lang.Array<MyBoundingBox>;
        }
        return [] as Lang.Array<MyBoundingBox>;
    }
    protected function draw(dc as Dc) as Void {
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
        var angleRads =
            ((Math.PI * 2) / 60) * self._seconds.toFloat() - Math.PI / 2;
        var radius = dc.getWidth() / 2;
        var nx = (cx + radius * Math.cos(angleRads)).toNumber();
        var ny = (cy + radius * Math.sin(angleRads)).toNumber();

        var lastDrawArea = self._lastDrawArea;
        if (lastDrawArea != null) {
            lastDrawArea.setAsClip(dc);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.clear();
            dc.clearClip();
        }
        var drawArea = MyBoundingBox.fromPoints(cx, cy, nx, ny);
        drawArea.addMargin(10);
        drawArea.setAsClip(dc);
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_RED);
        // dc.clear();
        // self._drawArea.addMargin(10);
        dc.setPenWidth(2);
        dc.drawLine(cx, cy, nx, ny);
        // System.println(
        //     "Angle " + self._seconds + " " + angleRads + " radius " + radius
        // );
        self._drawArea = drawArea;
        self._invalidatedArea = lastDrawArea;
        self._lastDrawArea = drawArea;
        Component.draw(dc);
    }
}
