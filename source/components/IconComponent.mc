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
