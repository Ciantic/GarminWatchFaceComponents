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

    public function clone() as MyBoundingBox {
        return new MyBoundingBox(self.x, self.y, self.width, self.height);
    }

    public function hashCode() as Lang.Number {
        var a = 280000000000l;
        // Unique for values up to 0-500
        return x + y * 1000 + width * 1000000 + (height * 1000000 + 5000000);
    }

    public function set(
        x as Lang.Number,
        y as Lang.Number,
        width as Lang.Number,
        height as Lang.Number
    ) as Void {
        self.x = x;
        self.y = y;
        self.width = width;
        self.height = height;
    }

    public function addMarginAll(n as Lang.Number) as Void {
        self.set(
            self.x - n,
            self.y - n,
            self.width + n * 2,
            self.height + n * 2
        );
    }

    public function addMargin(
        top as Lang.Number,
        right as Lang.Number,
        bottom as Lang.Number,
        left as Lang.Number
    ) as Void {
        self.set(
            self.x - left,
            self.y - top,
            self.width + right + left,
            self.height + bottom + top
        );
    }

    public function setPos(x as Lang.Number, y as Lang.Number) as Void {
        self.set(x, y, self.width, self.height);
    }

    public function setSize(
        width as Lang.Number,
        height as Lang.Number
    ) as Void {
        self.set(self.x, self.y, width, height);
    }

    public function setMoveXY(dx as Lang.Number, dy as Lang.Number) as Void {
        self.setPos(self.x + dx, self.y + dy);
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

    public function setPosTopCenter(boundingBox as MyBoundingBox) as Void {
        self.setPos(
            boundingBox.x + boundingBox.width / 2 - self.width / 2,
            boundingBox.y
        );
    }

    public function setPosBottomCenter(boundingBox as MyBoundingBox) as Void {
        self.setPos(
            boundingBox.x + boundingBox.width / 2 - self.width / 2,
            boundingBox.height - self.height
        );
    }

    public function setPosBottomLeft(boundingBox as MyBoundingBox) as Void {
        self.setPos(boundingBox.x, boundingBox.height - self.height);
    }

    public function setPosCenter(boundingBox as MyBoundingBox) as Void {
        self.setPos(
            boundingBox.x + boundingBox.width / 2 - self.width / 2,
            boundingBox.y + boundingBox.height / 2 - self.height / 2
        );
    }

    public function setPosCenterLeft(boundingBox as MyBoundingBox) as Void {
        self.setPos(
            boundingBox.x - self.width,
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

    public function unionToSelf(other as MyBoundingBox) as Void {
        if (other.width == 0 || other.height == 0) {
            return;
        }
        if (self.width == 0 || self.height == 0) {
            self.set(other.x, other.y, other.width, other.height);
            return;
        }
        var x = min(self.x, other.x);
        var y = min(self.y, other.y);
        var x2 = max(self.x + self.width, other.x + other.width);
        var y2 = max(self.y + self.height, other.y + other.height);
        self.set(x, y, (x2 - x).abs(), (y2 - y).abs());
    }

    public function intersectToSelf(other as MyBoundingBox) as Void {
        var leftX = max(self.x, other.x);
        var rightX = min(self.x + self.width, other.x + other.width);
        var topY = max(self.y, other.y);
        var bottomY = min(self.y + self.height, other.y + other.height);
        if (leftX < rightX && topY < bottomY) {
            self.set(leftX, topY, rightX - leftX, bottomY - topY);
        }
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

    public function getSlicePerOfWidth(
        percentage as Lang.Number
    ) as MyBoundingBox {
        return new MyBoundingBox(
            self.x,
            self.y,
            (self.width * (percentage / 100.0)).toNumber(),
            self.height
        );
    }

    public static function fromDc(dc as Dc) as MyBoundingBox {
        return new MyBoundingBox(0, 0, dc.getWidth(), dc.getHeight());
    }

    public static function fromPoints(
        x1 as Lang.Number,
        y1 as Lang.Number,
        x2 as Lang.Number,
        y2 as Lang.Number
    ) as MyBoundingBox {
        var x = min(x1, x2);
        var y = min(y1, y2);
        var width = (x2 - x1).abs();
        var height = (y2 - y1).abs();
        return new MyBoundingBox(x, y, width, height);
    }
}
