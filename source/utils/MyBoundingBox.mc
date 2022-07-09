import Toybox.Lang;
import Toybox.Graphics;

class MyBoundingBox {
    public var x as Lang.Number;
    public var y as Lang.Number;
    public var width as Lang.Number;
    public var height as Lang.Number;
    public var regions as Array<MyBoundingBox>?;

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

    public function setPos(x as Lang.Number, y as Lang.Number) as Void {
        self.x = x;
        self.y = y;
    }

    public function setPosCenterRightJustify(
        boundingBox as MyBoundingBox
    ) as Void {
        var width = boundingBox.width - boundingBox.x;
        var height = boundingBox.height - boundingBox.y;
        self.setPos(
            boundingBox.x + width / 2 - self.width,
            boundingBox.y + height / 2 - self.height / 2
        );
    }

    public function setPosCenterLeftJustify(
        boundingBox as MyBoundingBox
    ) as Void {
        var width = boundingBox.width - boundingBox.x;
        var height = boundingBox.height - boundingBox.y;
        self.setPos(
            boundingBox.x + width / 2,
            boundingBox.y + height / 2 - self.height / 2
        );
    }

    public function setPosCenter(boundingBox as MyBoundingBox) as Void {
        self.setPos(
            boundingBox.x + boundingBox.width / 2 - self.width / 2,
            boundingBox.y + boundingBox.height / 2 - self.height / 2
        );
    }

    public function isIntersecting(other as MyBoundingBox) as Boolean {
        // prettier-ignore
        return (
            (self.x + self.width) > other.x &&
            (other.x + other.width) > self.x &&
            (self.y + self.height) > other.y &&
            (other.y + other.height) > self.y
        );
    }

    public function getLowerHalf() as MyBoundingBox {
        return new MyBoundingBox(
            self.x,
            self.y + self.height / 2,
            self.width,
            self.height / 2
        );
    }
    public function getUpperHalf() as MyBoundingBox {
        return new MyBoundingBox(self.x, self.y, self.width, self.height / 2);
    }
}
