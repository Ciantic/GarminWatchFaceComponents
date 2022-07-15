import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;

class DrawCacheItem {
    public var bitmap as BufferedBitmapReference;
    public var box as MyBoundingBox;

    function initialize(
        bitmap as BufferedBitmapReference,
        box as MyBoundingBox
    ) {
        self.bitmap = bitmap;
        self.box = box;
    }
}

typedef DrawCacheMethod as (Method
        (dc as Dc, cacheKey as Object) as MyBoundingBox
    );

class DrawCache {
    private var _entries as Dictionary<Lang.Object, DrawCacheItem> =
        {} as Dictionary<Lang.Object, DrawCacheItem>;
    private var _method as DrawCacheMethod;

    function initialize(method as DrawCacheMethod, box as MyBoundingBox) {
        self._method = method;
    }

    public function execute(
        dc as Dc,
        cacheKey as Lang.Object
    ) as MyBoundingBox {
        // var result =
        return self._method.invoke(dc, cacheKey) as MyBoundingBox;
    }
}

class DialSecondComponent extends Component {
    (:debug)
    public var name as Lang.String = "DialSecondComponent";
    private var _seconds as Lang.Number = -1;
    private var _lastDrawArea as MyBoundingBox;
    private var _drawCache as DrawCache;

    public function initialize(box as MyBoundingBox) {
        self._drawCache = new DrawCache(
            self.method(:_drawSeconds) as DrawCacheMethod,
            box
        );
        self._lastDrawArea = box;
        Component.initialize(box);
    }

    public function update() as Void {
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
        // self._lastDrawArea = self._drawCache.execute(dc, self._seconds);
        self._lastDrawArea = _drawSeconds(dc, self._seconds);
        Component.draw(dc);
    }

    public function _drawSeconds(
        dc as Dc,
        seconds as Lang.Number
    ) as MyBoundingBox {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
        var angleRads = ((Math.PI * 2) / 60) * seconds.toFloat() - Math.PI / 2;
        var radius = dc.getWidth() / 2 - 55;
        // var ax = (cx + (radius - 15) * Math.cos(angleRads)).toNumber();
        // var ay = (cy + (radius - 15) * Math.sin(angleRads)).toNumber();
        var nx = (cx + radius * Math.cos(angleRads)).toNumber();
        var ny = (cy + radius * Math.sin(angleRads)).toNumber();
        var box = MyBoundingBox.fromPoints(cx, cy, nx, ny);
        box.addMarginAll(3);

        // dc.drawRectangle(box.x, box.y, box.width, box.height);
        dc.setPenWidth(1);
        dc.drawLine(cx, cy, nx, ny);
        return box;
    }
}
