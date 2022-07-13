import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class DebugComponent extends TextComponent {
    public function initialize() {
        var params = {
            :font => Graphics.FONT_XTINY,
            :justify => Graphics.TEXT_JUSTIFY_CENTER,
            :text => "00:00:00 00.00 00.00",
            // :width => 30,
            :height => 70,
            // :foreground => Graphics.COLOR_BLUE,
            // :background => Graphics.COLOR_YELLOW,
        };
        TextComponent.initialize(params);
    }

    public function update() as Void {
        var failed = GLOBAL_STATE.getPowerBudgetExceededInfo();
        var t = GLOBAL_STATE.getLastUpdateTime();
        var i = GLOBAL_STATE.getInitializeTime();
        var l = GLOBAL_STATE.getLayoutTime();
        var text =
            formatClocktime(t) +
            "\n" +
            formatClocktime(i) +
            "\n" +
            formatClocktime(l);
        if (failed != null) {
            text +=
                " " +
                failed.executionTimeAverage.format("%.2f") +
                " " +
                failed.executionTimeLimit.format("%.2f");
        }
        self.setText(text);
    }
}
