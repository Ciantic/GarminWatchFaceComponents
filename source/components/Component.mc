import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

var componentId as Lang.Number = 0;

class Component {
    (:debug)
    public var name as Lang.String = "Unset";
    public var partialUpdates as Lang.Boolean = false;

    private var _id as Lang.Number;
    private var _bitmap as BufferedBitmap?;
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

    public function render() as BufferedBitmap {
        var bitmap = self.getBitmap();
        if (self.isInvalid()) {
            var bdc = bitmap.getDc();
            if (bdc == null) {
                log("Unknown: Dc was not fetched");
                return bitmap;
            }
            draw(bdc);
            // log("Redraw " + self.name);
            return bitmap;
        }
        return bitmap;
    }

    public function update() as Void {}

    public function updatePartial() as Void {
        // This is not called if `partialUpdates` is false
    }

    public function isInvalid() as Boolean {
        return self._invalid;
    }

    public function getInvalidArea() as MyBoundingBox {
        return self._boundingBox;
    }

    public function getLastDrawArea() as MyBoundingBox {
        // return null;
        return self._boundingBox;
    }

    public function getId() as Lang.Number {
        return self._id;
    }

    protected function getBitmap() as BufferedBitmap {
        var bitmap = self._bitmap;
        if (bitmap == null) {
            var bitmapRef = Graphics.createBufferedBitmap({
                :width => self._boundingBox.width,
                :height => self._boundingBox.height,
            });
            self._bitmap = bitmapRef.get() as BufferedBitmap;
        }
        return self._bitmap as BufferedBitmap;
    }

    protected function draw(dc as Dc) as Void {
        self._invalid = false;
    }
}
