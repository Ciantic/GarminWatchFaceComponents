import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class Watch extends WatchUi.WatchFace {
    private var _componentLayer as ComponentLayer?;

    public function initialize() {
        WatchUi.WatchFace.initialize();
    }

    public function onLayout(dc as Dc) as Void {
        var dcArea = MyBoundingBox.fromDc(dc);
        var componentLayer = new ComponentLayer(dcArea);
        var bottomLayer = new ComponentLayer(dcArea);

        var bg = new ImageComponent(dcArea);
        var hours = new HoursComponent({
            :textSettings => {
                :font => Graphics.FONT_NUMBER_THAI_HOT,
                :justify => Graphics.TEXT_JUSTIFY_RIGHT,
                // :height => 90,
                // :background => Graphics.COLOR_GREEN,
            },
        });
        var mins = new MinutesComponent({
            :textSettings => {
                :font => Graphics.FONT_NUMBER_THAI_HOT,
                :justify => (
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
                ) as Graphics.TextJustification,
                // :height => 90,
                // :background => Graphics.COLOR_RED,
            },
        });
        var secs = new SecondsComponent({
            :textSettings => {
                :font => Graphics.FONT_TINY,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                // :foreground => Graphics.COLOR_BLUE,
                // :background => Graphics.COLOR_YELLOW,
            },
        });
        var secDial = new DialSecondComponent(dcArea);
        hours.getBoundingBox().setPosCenterRightJustify(dcArea);
        mins.getBoundingBox().setPosCenterLeftJustify(dcArea);
        secs.getBoundingBox().setPosCenter(dcArea.getLowerHalf());

        // Rarely changing can be combined to one layer, this saves just tiny
        // bit in a bitmap combination
        bottomLayer.add(bg);
        bottomLayer.add(hours);
        bottomLayer.add(mins);

        componentLayer.add(bottomLayer);
        componentLayer.add(secDial);
        // componentLayer.add(secs);
        self._componentLayer = componentLayer;
    }

    public function onUpdate(dc as Dc) as Void {
        GLOBAL_STATE.update();
        draw(dc, false);
    }

    public function onPartialUpdate(dc as Dc) as Void {
        GLOBAL_STATE.updatePartial();
        draw(dc, true);
    }

    public function onShow() as Void {}

    public function onHide() as Void {}

    public function onExitSleep() as Void {}

    public function onEnterSleep() as Void {
        // WatchUi.requestUpdate();
    }

    private function draw(dc as Dc, partial as Boolean) as Void {
        var componentLayer = self._componentLayer;
        if (componentLayer != null) {
            componentLayer.update();
            componentLayer.renderToView(dc, partial);
        }
    }
}
