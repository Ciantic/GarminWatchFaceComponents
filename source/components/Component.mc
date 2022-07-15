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
    protected var _invalid as Boolean = true;

    public function initialize(boundingBox as MyBoundingBox) {
        componentId += 1;
        self._id = componentId;
        self._boundingBox = boundingBox;
    }

    public function getBoundingBox() as MyBoundingBox {
        return self._boundingBox;
    }

    public function render() as BufferedBitmapReference {
        var bitmap = self.getBitmap();
        if (self.isInvalid()) {
            var ref = bitmap.get() as BufferedBitmap?;
            var bdc = ref != null ? ref.getDc() : null;
            if (bdc == null) {
                log("Unknown: Dc was not fetched");
                return bitmap;
            }
            draw(bdc);
            return bitmap;
        }
        return bitmap;
    }

    public function update() as Void {}

    public function isInvalid() as Boolean {
        return self._invalid;
    }

    public function getLastDrawArea() as MyBoundingBox {
        return self._boundingBox;
    }

    public function getId() as Lang.Number {
        return self._id;
    }

    protected function getBitmap() as BufferedBitmapReference {
        var bitmap = self._bitmap as BufferedBitmapReference;
        if (bitmap == null) {
            bitmap = Graphics.createBufferedBitmap({
                :width => self._boundingBox.width,
                :height => self._boundingBox.height,
            });
            self._bitmap = bitmap;
        }
        return bitmap;
    }

    protected function draw(dc as Dc) as Void {
        self._invalid = false;
    }
}
