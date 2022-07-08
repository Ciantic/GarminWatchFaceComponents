import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

typedef NumericSettings as {
        :value as Lang.Number?,
        :digits as Lang.Number?,
        :format as Lang.String?,
        :textSettings as TextSettings,
    };

class NumericComponent extends Component {
    (:debug)
    public var name as Lang.String = "NumericComponent";
    private var _textComponent as TextComponent;
    private var _format as Lang.String = "%d";
    private var _value as Lang.Number = 0;
    private var _invalid as Boolean = true;

    public function initialize(params as NumericSettings) {
        var value = params.get(:value) as Lang.Number?;
        if (value == null) {
            value = 0;
        }
        var format = params.get(:format) as Lang.String?;
        if (format != null) {
            self._format = format;
        }

        var digits = params.get(:digits) as Lang.Number?;
        if (digits == null) {
            digits = 2;
        }
        var textSettings = params.get(:textSettings) as TextSettings;
        textSettings[:text] = value.format(self._format);
        textSettings[:strlen] = digits;
        self._textComponent = new TextComponent(textSettings);
        Component.initialize({
            :width => self._textComponent.getBoundingBox().width,
            :height => self._textComponent.getBoundingBox().height,
        });
    }

    public function setValue(value as Lang.Number) as Void {
        if (self._value != value) {
            self._value = value;
            self._textComponent.setText(value.format(self._format));
            self._invalid = true;
        }
    }

    public function getBitmap() as BufferedBitmapReference? {
        return self._textComponent.getBitmap();
    }

    public function render() as BufferedBitmapReference {
        self._invalid = false;
        return self._textComponent.render();
    }

    public function isInvalid() as Boolean {
        return self._invalid;
    }
}
