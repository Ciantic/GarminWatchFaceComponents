import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

function _dialSecondCalculate(
    box as MyBoundingBox,
    seconds as Lang.Number
) as Lang.Array<Lang.Number> {
    var cx = box.width / 2;
    var cy = box.height / 2;
    var angleRads = ((Math.PI * 2) / 60) * seconds.toFloat() - Math.PI / 2;
    var radius = box.width / 2 - 1;
    // var ax = (cx + (radius - 15) * Math.cos(angleRads)).toNumber();
    // var ay = (cy + (radius - 15) * Math.sin(angleRads)).toNumber();
    var nx = (cx + radius * Math.cos(angleRads)).toNumber();
    var ny = (cy + radius * Math.sin(angleRads)).toNumber();
    return [cx, cy, nx, ny] as Lang.Array<Lang.Number>;
}

function _dialSecondCalculateAll(
    box as MyBoundingBox
) as Lang.Array<Lang.Number> {
    var points = [] as Lang.Array<Lang.Number>;
    for (var i = 0; i < 60; i++) {
        points.addAll(_dialSecondCalculate(box, i));
    }
    return points;
}

class DialSecondComponent extends Component {
    (:debug)
    public var name as Lang.String = "DialSecondComponent";
    public var partialUpdates as Lang.Boolean = true;
    private var _seconds as Lang.Number = -1;
    private var _lastDrawArea as MyBoundingBox;
    private var _drawPoints as Lang.Array<Lang.Number>;

    public function initialize(box as MyBoundingBox) {
        self._lastDrawArea = box;
        self._drawPoints = _dialSecondCalculateAll(box);
        Component.initialize(box);
    }

    public function update() as Void {
        self.updatePartial();
    }

    public function updatePartial() as Void {
        var newSeconds = GLOBAL_STATE.getClockTime().sec;
        if (self._seconds != newSeconds) {
            self._seconds = newSeconds;
            self._invalid = true;
        }
    }

    public function getLastDrawArea() as MyBoundingBox {
        return self._lastDrawArea;
    }

    protected function draw(dc as Dc) as Void {
        var cx = self._drawPoints[self._seconds * 4 + 0];
        var cy = self._drawPoints[self._seconds * 4 + 1];
        var nx = self._drawPoints[self._seconds * 4 + 2];
        var ny = self._drawPoints[self._seconds * 4 + 3];
        self._lastDrawArea = MyBoundingBox.fromPoints(cx, cy, nx, ny);
        self._lastDrawArea.addMarginAll(1);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setPenWidth(1);
        dc.drawLine(cx, cy, nx, ny);
        Component.draw(dc);
    }
}
