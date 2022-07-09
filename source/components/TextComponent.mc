import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

typedef TextSettings as {
        :text as Lang.String,
        :font as Graphics.FontType,
        :justify as Graphics.TextJustification?,
        :strlen as Lang.Number?,
        :width as Lang.Number?,
        :height as Lang.Number?,
        :foreground as Graphics.ColorType?,
        :background as Graphics.ColorType?,
    };

class TextComponent extends Component {
    (:debug)
    public var name as Lang.String = "TextComponent";
    private var _text as Lang.String;
    private var _font as Graphics.FontType;
    private var _justify as Lang.Number;
    private var _invalid as Boolean = true;
    private var _foreground as Graphics.ColorType = Graphics.COLOR_WHITE;
    private var _background as Graphics.ColorType = Graphics.COLOR_TRANSPARENT;

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

        var strlen = params.get(:strlen) as Lang.Number?;
        if (strlen == null) {
            strlen = text.length();
        }

        var fg = params.get(:foreground) as Lang.Number?;
        if (fg != null) {
            self._foreground = fg;
        }

        var bg = params.get(:background) as Lang.Number?;
        if (bg != null) {
            self._background = bg;
        }

        // If height or width is not given, try to guestimate from font size and strlen
        var fontHeight = Graphics.getFontHeight(font);
        var width = params.get(:width) as Lang.Number?;
        if (width == null) {
            // 0.7 is estimation
            width = fontHeight * strlen;
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

    public function isInvalid() as Boolean {
        return self._invalid;
    }

    protected function draw(bdc as Dc) as Void {
        bdc.setColor(self._foreground, self._background);
        bdc.clear();
        var bb = self.getBoundingBox();
        var x = 0;
        var y = 0;
        if ((self._justify & Graphics.TEXT_JUSTIFY_LEFT) != 0) {
            x = 0;
        } else if ((self._justify & Graphics.TEXT_JUSTIFY_CENTER) != 0) {
            x = bb.width / 2;
        } else {
            // TEXT_JUSTIFY_RIGHT
            x = bb.width;
        }

        if ((self._justify & Graphics.TEXT_JUSTIFY_VCENTER) != 0) {
            y = bb.height / 2;
        }
        bdc.drawText(x, y, self._font, self._text, self._justify);
        self._invalid = false;
    }
}
