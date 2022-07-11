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

class NumericComponent extends TextComponent {
    (:debug)
    public var name as Lang.String = "NumericComponent";
    private var _format as Lang.String = "%d";
    private var _value as Lang.Number = 0;

    public function initialize(params as NumericSettings) {
        var value = params.get(:value) as Lang.Number?;
        if (value == null) {
            value = 0;
        }
        self._value = value;

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
        TextComponent.initialize(textSettings);
    }

    public function setValue(newValue as Lang.Number) as Void {
        if (self._value != newValue) {
            self._value = newValue;
            self._invalid = true;
        }
    }

    protected function draw(dc as Dc) as Void {
        self._text = self._value.format(self._format);
        TextComponent.draw(dc);
    }
}
