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
        var componentLayer = new ComponentLayer({
            :width => dc.getWidth(),
            :height => dc.getHeight(),
        });

        var bg = new ImageComponent({
            :width => dc.getWidth(),
            :height => dc.getHeight(),
        });

        var hoursCom = new HoursComponent({
            :textSettings => {
                :font => Graphics.FONT_NUMBER_THAI_HOT,
                :justify => Graphics.TEXT_JUSTIFY_RIGHT,
                // :height => 90,
                // :background => Graphics.COLOR_GREEN,
            },
        });
        var minutesCom = new MinutesComponent({
            :textSettings => {
                :font => Graphics.FONT_NUMBER_THAI_HOT,
                :justify => (
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
                ) as Graphics.TextJustification,
                // :height => 90,
                // :background => Graphics.COLOR_RED,
            },
        });
        var secondsCom = new SecondsComponent({
            :textSettings => {
                :font => Graphics.FONT_MEDIUM,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                :width => 30,
                :foreground => Graphics.COLOR_BLUE,
                // :background => Graphics.COLOR_YELLOW,
            },
        });
        var secondsCom2 = new SecondsComponent({
            :textSettings => {
                :font => Graphics.FONT_MEDIUM,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                :width => 30,
                :foreground => Graphics.COLOR_BLUE,
                // :background => Graphics.COLOR_YELLOW,
            },
        });
        var secondsCom3 = new SecondsComponent({
            :textSettings => {
                :font => Graphics.FONT_MEDIUM,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                :width => 30,
                :foreground => Graphics.COLOR_BLUE,
                // :background => Graphics.COLOR_YELLOW,
            },
        });
        hoursCom.getBoundingBox().setPosCenterRightJustify(dcArea);
        minutesCom.getBoundingBox().setPosCenterLeftJustify(dcArea);
        secondsCom.getBoundingBox().setPosCenter(dcArea);
        secondsCom2.getBoundingBox().setPosCenter(dcArea.getLowerHalf());
        secondsCom3.getBoundingBox().setPosCenter(dcArea.getUpperHalf());
        // componentLayer.add(testCom);
        componentLayer.add(bg);
        componentLayer.add(hoursCom);
        componentLayer.add(minutesCom);
        componentLayer.add(secondsCom);
        // componentLayer.add(secondsCom2);
        // componentLayer.add(secondsCom3);
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

        var now = System.getTimer();
        var componentLayer = self._componentLayer;
        if (componentLayer != null) {
            componentLayer.update(now);
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
