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
                // :foreground => Graphics.COLOR_DK_GRAY,
                :foreground => 0xaaaaaa,
                // :background => Graphics.COLOR_RED,
            },
        });
        var debug = new DebugComponent();

        var dateIcon = iconCalendar(Graphics.COLOR_BLUE);
        var date = new DateComponent({
            :textSettings => {
                :font => Graphics.FONT_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_LEFT,
                // :width => 30,
                // :height => 30,
                :foreground => 0xaaaaaa,
                // :background => Graphics.COLOR_YELLOW,
            },
        });
        var stepsIcon = iconSteps(Graphics.COLOR_BLUE);
        var steps = new StepsComponent({
            :textSettings => {
                :font => Graphics.FONT_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_LEFT,
                // :width => 30,
                // :height => 30,
                :foreground => 0xaaaaaa,
                // :background => Graphics.COLOR_YELLOW,
            },
        });

        var altitudeIcon = iconMountain(Graphics.COLOR_BLUE);
        var altitude = new AltitudeComponent({
            :textSettings => {
                :font => Graphics.FONT_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_LEFT,
                // :width => 30,
                // :height => 30,
                :foreground => 0xaaaaaa,
                // :background => Graphics.COLOR_YELLOW,
            },
        });

        var metersClimbedIcon = iconStairsUp(Graphics.COLOR_BLUE);
        var metersClimbed = new MetersClimbedComponent({
            :textSettings => {
                :font => Graphics.FONT_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_LEFT,
                // :width => 30,
                // :height => 30,
                :foreground => 0xaaaaaa,
                // :background => Graphics.COLOR_YELLOW,
            },
        });

        var sunSetIcon = iconSunset(Graphics.COLOR_BLUE);
        var sun = new SunComponent({
            :textSettings => {
                :font => Graphics.FONT_XTINY,
                :justify => Graphics.TEXT_JUSTIFY_LEFT,
                // :width => 30,
                // :height => 30,
                :foreground => 0xaaaaaa,
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
                // :foreground => Graphics.COLOR_RED,
                :foreground => Graphics.COLOR_LT_GRAY,
                // :background => Graphics.COLOR_BLACK,
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
        secs.getBoundingBox().setPos(227, 120);
        hrIcon.getBoundingBox().setPosBottomCenter(dcArea);
        hr.getBoundingBox().setPosCenter(hrIcon.getBoundingBox());

        // FIRST ROW:
        var rowHeight = 24;
        var y = 5;

        steps.getBoundingBox().setPosTopCenter(dcArea);
        steps.getBoundingBox().setMoveXY(10, y);
        stepsIcon.getBoundingBox().setPosCenterLeft(steps.getBoundingBox());
        stepsIcon.getBoundingBox().setMoveXY(-3, 5);

        // SECOND ROW
        y += rowHeight;

        metersClimbed.getBoundingBox().setPosTopCenter(dcArea);
        metersClimbed.getBoundingBox().setMoveXY(50, y);
        metersClimbedIcon
            .getBoundingBox()
            .setPosCenterLeft(metersClimbed.getBoundingBox());
        metersClimbedIcon.getBoundingBox().setMoveXY(-3, 5);

        altitude.getBoundingBox().setPosTopCenter(dcArea);
        altitude.getBoundingBox().setMoveXY(-13, y);
        altitudeIcon
            .getBoundingBox()
            .setPosCenterLeft(altitude.getBoundingBox());
        altitudeIcon.getBoundingBox().setMoveXY(-3, 5);

        // THIRD ROW
        y += rowHeight;

        sun.getBoundingBox().setPosTopCenter(dcArea);
        sun.getBoundingBox().setMoveXY(-35, y);
        sunSetIcon.getBoundingBox().setPosCenterLeft(sun.getBoundingBox());
        sunSetIcon.getBoundingBox().setMoveXY(-3, 5);

        date.getBoundingBox().setPosTopCenter(dcArea);
        date.getBoundingBox().setMoveXY(60, y);
        dateIcon.getBoundingBox().setPosCenterLeft(date.getBoundingBox());
        dateIcon.getBoundingBox().setMoveXY(-3, 5);

        // Other stuff

        hrgraph.getBoundingBox().setPosBottomLeft(dcArea);
        debug.getBoundingBox().setPosCenter(dcArea);

        // Rarely changing can be combined to one layer, this saves just tiny
        // bit in a bitmap combination
        bottomLayer.add(bg);
        bottomLayer.add(hrgraph);
        bottomLayer.add(hrIcon);

        bottomLayer.add(hours);
        bottomLayer.add(mins);
        bottomLayer.add(debug);

        bottomLayer.add(stepsIcon);
        bottomLayer.add(steps);

        bottomLayer.add(altitudeIcon);
        bottomLayer.add(altitude);

        bottomLayer.add(metersClimbedIcon);
        bottomLayer.add(metersClimbed);

        bottomLayer.add(sunSetIcon);
        bottomLayer.add(sun);

        bottomLayer.add(dateIcon);
        bottomLayer.add(date);

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
