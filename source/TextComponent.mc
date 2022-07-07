import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

typedef TextSettings as {
        :text as Lang.String,
        :font as Graphics.FontType,
        :justify as Lang.Number?,
    };

class TextComponent extends Component {
    (:debug)
    public var name as Lang.String = "TextComponent";
    private var _text as Lang.String;
    private var _font as Graphics.FontType;
    private var _justify as Lang.Number;
    private var _invalid as Boolean = true;

    public function initialize(params as TextSettings) {
        var font = params.get(:font) as Graphics.FontType?;
        if (font == null) {
            throw new InvalidValueException("Font must be given");
        }

        var justify = params.get(:justify) as Lang.Number?;
        if (justify == null) {
            justify = Graphics.TEXT_JUSTIFY_LEFT;
        }

        var text = params.get(:text) as Lang.String?;
        if (text == null) {
            text = "";
        }
        self._justify = justify;
        self._text = text;
        self._font = font;
        var height = Graphics.getFontHeight(font);
        System.println("Make " + height * text.length());
        Component.initialize({
            :width => height * text.length(),
            :height => height,
        });
    }

    public function setText(newText as Lang.String) as Void {
        if (self._text != newText) {
            self._invalid = true;
            self._text = newText;
        }
    }

    public function doUpdate(time as Lang.Number) as Boolean {
        return _invalid;
    }

    protected function draw(bdc as Dc) as Void {
        System.println("Draw hour " + self._text);
        bdc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        bdc.clear();
        bdc.drawText(0, 0, self._font, self._text, self._justify);
        _invalid = false;
    }
}
