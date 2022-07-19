import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

// const FONT_ROBOTO_BOLD =
//     WatchUi.loadResource($.Rez.Fonts.roboto_bold) as FontResource;

const FONT_JETBRAINS_MONO =
    WatchUi.loadResource($.Rez.Fonts.jetbrains_mono) as FontResource;
const FONT_JETBRAINS_MONO_24x14 =
    WatchUi.loadResource($.Rez.Fonts.jetbrains_mono_24x14) as FontResource;

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
                :font => FONT_JETBRAINS_MONO,
                :justify => Graphics.TEXT_JUSTIFY_RIGHT,
                // :height => 90,
                // :background => Graphics.COLOR_GREEN,
            },
        });
        var mins = new MinutesComponent({
            :textSettings => {
                :font => FONT_JETBRAINS_MONO,
                :justify => Graphics.TEXT_JUSTIFY_LEFT,
                // :height => 90,
                // :background => Graphics.COLOR_RED,
            },
        });
        var secs = new SecondsComponent({
            :textSettings => {
                :font => FONT_JETBRAINS_MONO_24x14,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                :foreground => Graphics.COLOR_DK_GRAY,
                // :background => Graphics.COLOR_RED,
            },
        });
        var debug = new DebugComponent();
        var date = new DateComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                :foreground => MoreColors.COLOR_BROWN,
                // :background => Graphics.COLOR_YELLOW,
            },
        });

        var hrIcon = iconHeart3Outline(
            Graphics.COLOR_BLACK,
            Graphics.COLOR_RED
        );

        var hr = new HeartRateComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_XTINY,
                // :font => Graphics.FONT_SYSTEM_TINY,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                :foreground => Graphics.COLOR_RED,
                // :background => Graphics.COLOR_BLACK,
            },
        });
        var steps = new StepsComponent({
            :textSettings => {
                :font => Graphics.FONT_SYSTEM_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_CENTER,
                // :width => 30,
                // :height => 30,
                :foreground => MoreColors.COLOR_BROWN,
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
        // hours.getBoundingBox().setMoveXY(-3, 0);
        mins.getBoundingBox().setPosCenterLeftJustify(dcArea);
        // mins.getBoundingBox().setMoveXY(3, 0);
        secs.getBoundingBox().setPos(226, 142);
        hrIcon.getBoundingBox().setPosBottomCenter(dcArea);
        hr.getBoundingBox().setPosCenter(hrIcon.getBoundingBox());
        // hrIcon.getBoundingBox().setPosCenter(hr.getBoundingBox());
        // hr.getBoundingBox().setMoveXY(0, -2);

        date.getBoundingBox().setPosCenter(
            dcArea.getUpperHalf().getUpperHalf().getUpperHalf()
        );
        date.getBoundingBox().setMoveXY(0, 15);
        steps
            .getBoundingBox()
            .setPosCenter(dcArea.getUpperHalf().getUpperHalf().getUpperHalf());
        hrgraph.getBoundingBox().setPosBottomLeft(dcArea);
        debug.getBoundingBox().setPosCenter(dcArea);

        // Rarely changing can be combined to one layer, this saves just tiny
        // bit in a bitmap combination
        bottomLayer.add(bg);
        bottomLayer.add(hrgraph);
        bottomLayer.add(hours);
        bottomLayer.add(mins);
        bottomLayer.add(debug);
        bottomLayer.add(steps);
        bottomLayer.add(date);
        bottomLayer.add(hrIcon);

        componentLayer.add(bottomLayer);
        componentLayer.add(hr);
        componentLayer.add(secs);
        // componentLayer.add(secDial);
        self._componentLayer = componentLayer;
    }

    public function onUpdate(dc as Dc) as Void {
        GLOBAL_STATE.update();
        var componentLayer = self._componentLayer;
        if (componentLayer != null) {
            componentLayer.update();
            componentLayer.renderToView(dc, false);
        }
    }

    public function onPartialUpdate(dc as Dc) as Void {
        GLOBAL_STATE.updatePartial();
        var componentLayer = self._componentLayer;
        if (componentLayer != null) {
            componentLayer.updatePartial();
            componentLayer.renderToView(dc, true);
        }
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
        WatchUi.requestUpdate();
    }
}
