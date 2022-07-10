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
                :font => Graphics.FONT_MEDIUM,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                :width => 30,
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

    public function onShow() as Void {}
    public function onHide() as Void {}

    public function onUpdate(dc as Dc) as Void {
        draw(dc, false);
    }

    public function onPartialUpdate(dc as Dc) as Void {
        draw(dc, true);
    }

    public function onExitSleep() as Void {}

    public function onEnterSleep() as Void {
        // WatchUi.requestUpdate();
    }

    public function onPowerBudgetExceeded(
        powerInfo as WatchFacePowerInfo
    ) as Void {
        System.println(
            "Average execution time: " + powerInfo.executionTimeAverage
        );
        System.println(
            "Allowed execution time: " + powerInfo.executionTimeLimit
        );
    }

    private function draw(dc as Dc, partial as Boolean) as Void {
        // Clear full background on full update
        if (!partial) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();
        }

        var componentLayer = self._componentLayer;
        if (componentLayer != null) {
            componentLayer.update();
            componentLayer.renderToView(dc, partial);
        }
    }
}

class WatchDelegate extends WatchUi.WatchFaceDelegate {
    private var _view as Watch;

    public function initialize(view as Watch) {
        WatchFaceDelegate.initialize();
        _view = view;
    }

    public function onPowerBudgetExceeded(
        powerInfo as WatchFacePowerInfo
    ) as Void {
        _view.onPowerBudgetExceeded(powerInfo);
    }
}
