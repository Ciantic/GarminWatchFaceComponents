import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class ImageComponent extends Component {
    (:debug)
    public var name as Lang.String = "ImageComponent";
    private var _invalid as Boolean = true;

    public function initialize(
        params as
            {
                :width as Lang.Number,
                :height as Lang.Number,
                // :x as Lang.Number,
                // :y as Lang.Number,
            }
    ) {
        Component.initialize(params);
    }

    protected function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_DK_BLUE);
        dc.clear();
        // dc.setFill(Graphics.COLOR_RED);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        dc.drawCircle(1, 1, 50);
        // dc.setFill(Graphics.COLOR_BLUE);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        dc.drawCircle(60, 1, 50);
        Component.draw(dc);
    }
}
