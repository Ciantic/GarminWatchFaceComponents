import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class Watch extends WatchUi.WatchFace {
    private var _componentLayer as ComponentLayer?;

    public function initialize() {
        WatchFace.initialize();
    }

    public function onLayout(dc as Dc) as Void {
        var dcArea = MyBoundingBox.fromDc(dc);
        var bottomLayer = new ComponentLayer(dcArea);
        var componentLayer = new ComponentLayer(dcArea);

        var bg = new ImageComponent(dcArea);
        var hours = new HoursComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
                :justify => Graphics.TEXT_JUSTIFY_RIGHT,
                // :height => 90,
                // :background => Graphics.COLOR_GREEN,
            },
        });
        var mins = new MinutesComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
                :justify => Graphics.TEXT_JUSTIFY_LEFT,
                // :height => 90,
                // :background => Graphics.COLOR_RED,
            },
        });
        var secs = new SecondsComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                // :foreground => Graphics.COLOR_BLUE,
                // :background => Graphics.COLOR_RED,
            },
        });
        var debug = new DebugComponent();

        var hr = new HeartRateComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                // :foreground => Graphics.COLOR_BLUE,
                // :background => Graphics.COLOR_YELLOW,
            },
        });
        var steps = new StepsComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                // :foreground => Graphics.COLOR_BLUE,
                // :background => Graphics.COLOR_YELLOW,
            },
        });
        var hrgraph = new HeartRateGraphComponent(
            // For round watches, the right most part is not useful for heart
            // rate graphs, split it away (90% mark of screen area)
            dcArea.getLowerHalf().getSlicePerOfWidth(90)
        );
        var secDial = new DialSecondComponent(dcArea);
        hours.getBoundingBox().setPosCenterRightJustify(dcArea);
        mins.getBoundingBox().setPosCenterLeftJustify(dcArea);
        secs.getBoundingBox().setPosCenter(dcArea.getLowerHalf());
        hr.getBoundingBox().setPosCenter(
            dcArea.getLowerHalf().getLowerHalf().getLowerHalf()
        );
        steps.getBoundingBox().setPos(80, 80);
        hrgraph.getBoundingBox().setPosBottomLeft(dcArea);
        debug.getBoundingBox().setPosTopCenter(dcArea);
        debug.getBoundingBox().setMoveXY(0, 10);

        // Rarely changing can be combined to one layer, this saves just tiny
        // bit in a bitmap combination
        bottomLayer.add(bg);
        bottomLayer.add(hrgraph);
        bottomLayer.add(hours);
        bottomLayer.add(mins);
        bottomLayer.add(debug);
        bottomLayer.add(steps);

        componentLayer.add(bottomLayer);
        // componentLayer.add(hr);
        // componentLayer.add(secs);
        componentLayer.add(secDial);
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

    public function onShow() as Void {
        GLOBAL_STATE.onShow();
    }

    public function onHide() as Void {
        GLOBAL_STATE.onHide();
    }

    public function onExitSleep() as Void {
        GLOBAL_STATE.onExitSleep();
    }

    public function onEnterSleep() as Void {
        GLOBAL_STATE.onEnterSleep();
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
