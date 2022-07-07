import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class Watch extends WatchUi.WatchFace {
    // private var minutesView as MinutesView;
    // private var secondsView as SecondsView;
    private var componentLayer as ComponentLayer?;

    public function initialize() {
        WatchFace.initialize();
    }

    public function onLayout(dc as Dc) as Void {
        var componentLayer = new ComponentLayer({
            :width => dc.getWidth(),
            :height => dc.getHeight(),
        });

        var hoursView = new HoursView({
            :font => Graphics.FONT_NUMBER_THAI_HOT,
        });
        var minutesView = new MinutesView({
            :font => Graphics.FONT_NUMBER_THAI_HOT,
        });
        var secondsView = new SecondsView({
            :font => Graphics.FONT_MEDIUM,
        });
        hoursView.setPosCenterRightJustify(0, 0, dc.getWidth(), dc.getHeight());
        minutesView.setPosCenterLeftJustify(
            0,
            0,
            dc.getWidth(),
            dc.getHeight()
        );
        secondsView.setPosCenter(
            0,
            dc.getHeight() / 2,
            dc.getWidth(),
            dc.getHeight()
        );

        componentLayer.add(hoursView);
        componentLayer.add(minutesView);
        componentLayer.add(secondsView);
        self.componentLayer = componentLayer;
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
        System.println("Request update");
        WatchUi.requestUpdate();
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
        var componentLayer = self.componentLayer;
        if (componentLayer != null) {
            componentLayer.renderToView(dc, now, partial);
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
