import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

var componentId as Lang.Number = 0;

class Component {
    (:debug)
    public var name as Lang.String = "Unset";

    private var id as Lang.Number;
    private var bitmap as BufferedBitmapReference?;
    private var boundingBox as MyBoundingBox;
    private var layer as WeakReference?;

    public function initialize(
        params as
            {
                :width as Lang.Number,
                :height as Lang.Number,
                // :x as Lang.Number,
                // :y as Lang.Number,
            }
    ) {
        componentId += 1;
        self.id = componentId;

        var w = params.get(:width);
        var h = params.get(:height);
        self.boundingBox = new MyBoundingBox(
            0,
            0,
            w != null ? w : 0,
            h != null ? h : 0
        );
        self.bitmap = null;
        System.println("Initialize Component?");
    }

    private function getDc() as Dc? {
        // If buffer is not created or it was purged (ReferenceResource::get may
        // return null in that case)
        var ref = (bitmap != null ? bitmap.get() : null) as BufferedBitmap?;
        var dc = ref != null ? ref.getDc() : null;
        if (dc != null) {
            return dc;
        }

        // TODO: This may throw error: not enough memory
        bitmap = Graphics.createBufferedBitmap({
            :width => self.boundingBox.width,
            :height => self.boundingBox.height,
        });
        ref = (bitmap != null ? bitmap.get() : null) as BufferedBitmap?;
        dc = ref != null ? ref.getDc() : null;
        return dc;
    }

    public function getBitmap() as BufferedBitmapReference? {
        return self.bitmap;
    }

    public function getWidth() as Lang.Number {
        return self.boundingBox.width;
    }

    public function getHeight() as Lang.Number {
        return self.boundingBox.height;
    }

    public function getOffsetX() as Lang.Number {
        return self.boundingBox.x;
    }

    public function getOffsetY() as Lang.Number {
        return self.boundingBox.y;
    }

    public function setPos(x as Lang.Number, y as Lang.Number) as Void {
        self.boundingBox.x = x;
        self.boundingBox.y = y;
    }

    public function setPosCenterRightJustify(
        x as Lang.Number,
        y as Lang.Number,
        width as Lang.Number,
        height as Lang.Number
    ) as Void {
        width -= x;
        height -= y;
        self.setPos(
            x + width / 2 - self.getWidth(),
            y + height / 2 - self.getHeight() / 2
        );
    }

    public function setPosCenterLeftJustify(
        x as Lang.Number,
        y as Lang.Number,
        width as Lang.Number,
        height as Lang.Number
    ) as Void {
        width -= x;
        height -= y;
        self.setPos(x + width / 2, y + height / 2 - self.getHeight() / 2);
    }

    public function setPosCenter(
        x as Lang.Number,
        y as Lang.Number,
        width as Lang.Number,
        height as Lang.Number
    ) as Void {
        width -= x;
        height -= y;
        self.setPos(
            x + width / 2 - self.getWidth() / 2,
            y + height / 2 - self.getHeight() / 2
        );
    }

    public function addToLayer(layer as ComponentLayer) as Void {
        self.layer = layer.weak();
    }

    public function render(time as Lang.Number) as Boolean {
        if (self.doUpdate(time)) {
            var bdc = getDc();
            if (bdc == null) {
                System.println("Unknown: Dc was not fetched");
                return false;
            }
            draw(bdc);
            return true;
        }
        return false;
    }

    public function doUpdate(time as Lang.Number) as Boolean {
        System.println("Do update must be implemented on extending class");
        return false;
    }

    protected function draw(dc as Dc) as Void {
        System.println("Draw must be implemented on extending class");
    }
}
