import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

typedef TextSettings as {
        :text as Lang.String,
        :font as Graphics.FontType,
        :justify as Lang.Number?,
        :width as Lang.Number?,
        :height as Lang.Number?,
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

        // If height or width is not given, try to guestimate from font size
        var fontHeight = Graphics.getFontHeight(font);
        var width = params.get(:width) as Lang.Number?;
        if (width == null) {
            width = fontHeight * text.length();
        }

        var height = params.get(:height) as Lang.Number?;
        if (height == null) {
            height = fontHeight;
        }

        self._justify = justify;
        self._text = text;
        self._font = font;
        Component.initialize({
            :width => width,
            :height => height,
        });
    }

    public function setText(newText as Lang.String) as Void {
        if (!self._text.equals(newText)) {
            self._invalid = true;
            self._text = newText;
        }
    }

    public function update(time as Lang.Number) as Void {}

    protected function shouldRedraw() as Boolean {
        return self._invalid;
    }

    protected function draw(bdc as Dc) as Void {
        bdc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        bdc.clear();
        var x = 0;
        var y = 0;
        if (self._justify == Graphics.TEXT_JUSTIFY_RIGHT) {
            x = self.getWidth();
        } else if (self._justify == Graphics.TEXT_JUSTIFY_CENTER) {
            x = self.getWidth() / 2;
        } else if (self._justify == Graphics.TEXT_JUSTIFY_VCENTER) {
            x = self.getWidth() / 2;
            y = self.getHeight() / 2;
        }
        bdc.drawText(x, y, self._font, self._text, self._justify);
        self._invalid = false;
    }
}