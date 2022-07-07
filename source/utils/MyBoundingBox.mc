import Toybox.Lang;
import Toybox.Graphics;

class MyBoundingBox {
    public var x as Lang.Number;
    public var y as Lang.Number;
    public var width as Lang.Number;
    public var height as Lang.Number;

    public function initialize(
        x as Lang.Number,
        y as Lang.Number,
        width as Lang.Number,
        height as Lang.Number
    ) {
        self.x = x;
        self.y = y;
        self.width = width;
        self.height = height;
    }

    public function toString() {
        return "x:" + x + " y:" + y + " " + width + "*" + height;
    }

    public static function fromDc(dc as Dc) as MyBoundingBox {
        return new MyBoundingBox(0, 0, dc.getWidth(), dc.getHeight());
    }

    // static public function intersects()

    // public function intersect(other as MyBoundingBox) as MyBoundingBox? {
    //     self.x;
    // }
}
