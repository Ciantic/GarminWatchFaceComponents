import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

const ICON_FONT = WatchUi.loadResource($.Rez.Fonts.icons) as FontResource;

class IconComponent extends TextComponent {
    (:debug)
    public var name as Lang.String = "IconComponent";

    public function initialize(params as TextSettings) {
        params[:justify] =
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        TextComponent.initialize(params);
    }
}

function iconHeart1(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 26,
        :height => 24,
        :text => "0",
        :foreground => color,
    });
}

function iconHeart2(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 18,
        :text => "1",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconHeart3(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 38,
        :height => 35,
        :text => "2",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconHeart4(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 38,
        :height => 35,
        :text => "3",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconPaw(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => "4",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconSteps(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => "5",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconSunrise(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => "6",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}
function iconSunset(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => "7",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconMountain(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => "8",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconStairsUp(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => "9",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}

function iconStairsDown(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => ":",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}
function iconCalendar(color as Graphics.ColorType) as TextComponent {
    return new IconComponent({
        :font => ICON_FONT,
        :width => 20,
        :height => 38,
        :text => ";",
        :foreground => color,
        // :background => Graphics.COLOR_BLUE,
    });
}
function iconHeart3Outline(
    color as Graphics.ColorType,
    oColor as Graphics.ColorType
) as ComponentLayer {
    var layer = new ComponentLayer(new MyBoundingBox(0, 0, 38, 35));
    var heart = iconHeart3(color);
    var outline = iconHeart4(oColor);
    layer.add(heart);
    layer.add(outline);
    return layer;
}
