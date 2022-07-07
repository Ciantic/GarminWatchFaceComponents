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
    }

    public function getBoundingBox() as MyBoundingBox {
        return self.boundingBox;
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
        boundingBox as MyBoundingBox
    ) as Void {
        var width = boundingBox.width - boundingBox.x;
        var height = boundingBox.height - boundingBox.y;
        self.setPos(
            boundingBox.x + width / 2 - self.getWidth(),
            boundingBox.y + height / 2 - self.getHeight() / 2
        );
    }

    public function setPosCenterLeftJustify(
        boundingBox as MyBoundingBox
    ) as Void {
        var width = boundingBox.width - boundingBox.x;
        var height = boundingBox.height - boundingBox.y;
        self.setPos(
            boundingBox.x + width / 2,
            boundingBox.y + height / 2 - self.getHeight() / 2
        );
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

    public function render() as BufferedBitmapReference {
        var bitmap = self.bitmap as BufferedBitmapReference;
        if (bitmap == null) {
            bitmap = Graphics.createBufferedBitmap({
                :width => self.boundingBox.width,
                :height => self.boundingBox.height,
            });
            self.bitmap = bitmap;
        }

        if (self.shouldRedraw()) {
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

    public function update(time as Lang.Number) as Void {
        System.println("Update must be implemented on extending class");
    }

    protected function shouldRedraw() as Boolean {
        System.println("Is invalid must be implemented on extending class");
        return false;
    }

    protected function draw(dc as Dc) as Void {
        System.println("Draw must be implemented on extending class");
    }

    // Intended for interop with ComponentLayer, at the moment I can't figure out other good uses from outside
    public function __shouldRedraw() as Boolean {
        return self.shouldRedraw();
    }
}
