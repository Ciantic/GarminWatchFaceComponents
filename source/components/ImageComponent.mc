import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class ImageComponent extends Component {
    (:debug)
    public var name as Lang.String = "ImageComponent";

    public function initialize(box as MyBoundingBox) {
        Component.initialize(box);
    }

    protected function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.clear();
        // // dc.setFill(Graphics.COLOR_RED);
        // dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        // dc.drawCircle(50, 50, 50);
        // // dc.setFill(Graphics.COLOR_BLUE);
        // dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        // dc.drawCircle(90, 90, 50);
        Component.draw(dc);
    }
}
