import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

function drawDial(dc as Dc, seconds as Lang.Number) as MyBoundingBox {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.clear();
    var cx = dc.getWidth() / 2;
    var cy = dc.getHeight() / 2;
    var angleRads = ((Math.PI * 2) / 60) * seconds.toFloat() - Math.PI / 2;
    var radius = dc.getWidth() / 2 - 25;
    var nx = (cx + radius * Math.cos(angleRads)).toNumber();
    var ny = (cy + radius * Math.sin(angleRads)).toNumber();
    var box = MyBoundingBox.fromPoints(cx, cy, nx, ny);
    box.addMarginAll(4);

    // dc.drawRectangle(box.x, box.y, box.width, box.height);
    dc.setPenWidth(2);
    dc.drawLine(cx, cy, nx, ny);
    return box;
}

class DialSecondComponent extends Component {
    (:debug)
    public var name as Lang.String = "DialSecondComponent";
    private var _seconds as Lang.Number?;
    private var _lastSeconds as Lang.Number?;
    private var _secondBuffers as Lang.Array<BufferedBitmapReference>;
    private var _drawAreas as Lang.Array<MyBoundingBox>;

    public function initialize(box as MyBoundingBox) {
        Component.initialize(box);
        self._secondBuffers = [] as Lang.Array<BufferedBitmapReference>;
        self._drawAreas = [] as Lang.Array<MyBoundingBox>;
        // This approach works in SIM but not in a device, maybe too many bitmaps?
        for (var i = 0; i < 60; i++) {
            var buffer = Graphics.createBufferedBitmap({
                :width => box.width,
                :height => box.height,
            });
            var dc = (buffer.get() as BufferedBitmap).getDc();
            var drawArea = drawDial(dc, i);
            self._secondBuffers.add(buffer);
            self._drawAreas.add(drawArea);
        }
    }

    public function update() as Void {
        var newSeconds = GLOBAL_STATE.getClockTime().sec;
        if (self._seconds != newSeconds) {
            self._seconds = newSeconds;
            self._invalid = true;
        }
    }

    public function getLastDrawArea() as MyBoundingBox {
        if (self._lastSeconds != null) {
            return self._drawAreas[self._lastSeconds];
        }
        return self.getBoundingBox();
    }

    public function getBitmap() as BufferedBitmapReference? {
        if (self._seconds != null) {
            return self._secondBuffers[self._seconds as Lang.Number];
        }
        return null;
    }

    public function render() as BufferedBitmapReference {
        self._invalid = false;
        self._lastSeconds = self._seconds;
        return self._secondBuffers[self._seconds as Lang.Number];
    }
}
