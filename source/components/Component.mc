import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

var componentId as Lang.Number = 0;

class Component {
    (:debug)
    public var name as Lang.String = "Unset";

    private var _id as Lang.Number;
    private var _bitmap as BufferedBitmapReference?;
    private var _boundingBox as MyBoundingBox;
    private var _invalidAndDrawArea as Lang.Array<MyBoundingBox>?;
    protected var _invalid as Boolean?;
    // private var _invalid = true;

    public function initialize(boundingBox as MyBoundingBox) {
        componentId += 1;
        self._id = componentId;
        self._boundingBox = boundingBox;
        self._bitmap = null;
    }

    public function getBoundingBox() as MyBoundingBox {
        return self._boundingBox;
    }

    public function render() as BufferedBitmapReference {
        var bitmap = self._bitmap as BufferedBitmapReference;
        if (bitmap == null) {
            bitmap = Graphics.createBufferedBitmap({
                :width => self._boundingBox.width,
                :height => self._boundingBox.height,
            });
            self._bitmap = bitmap;
        }

        if (self.isInvalid()) {
            var ref = (bitmap != null ? bitmap.get() : null) as BufferedBitmap?;
            var bdc = ref != null ? ref.getDc() : null;
            if (bdc == null) {
                System.println("Unknown: Dc was not fetched");
                return bitmap;
            }
            draw(bdc);
            return bitmap;
        }
        return bitmap;
    }

    public function getBitmap() as BufferedBitmapReference? {
        return self._bitmap;
    }

    public function update(time as Lang.Number) as Void {}

    public function isInvalid() as Boolean {
        return self._invalid != null ? self._invalid : true;
    }

    public function getInvalidAreas() as Lang.Array<MyBoundingBox> {
        // This only needs to be overridden on special components, with
        // non-rectangular or movement action, e.g. analog dials

        if (self._invalidAndDrawArea == null) {
            self._invalidAndDrawArea =
                [self._boundingBox] as Lang.Array<MyBoundingBox>;
        }
        return self._invalidAndDrawArea as Lang.Array<MyBoundingBox>;
    }

    public function getDrawnAreas() as Lang.Array<MyBoundingBox> {
        // This only needs to be overridden on special components, with
        // non-rectangular or movement action, e.g. analog dials

        if (self._invalidAndDrawArea == null) {
            self._invalidAndDrawArea =
                [self._boundingBox] as Lang.Array<MyBoundingBox>;
        }
        return self._invalidAndDrawArea as Lang.Array<MyBoundingBox>;
    }

    protected function draw(dc as Dc) as Void {
        self._invalid = false;
    }
}
