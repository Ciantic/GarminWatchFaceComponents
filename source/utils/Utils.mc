import Toybox.Test;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

function max(a as Lang.Number, b as Lang.Number) as Lang.Number {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

function min(a as Lang.Number, b as Lang.Number) as Lang.Number {
    if (a < b) {
        return a;
    } else {
        return b;
    }
}

function getFontWidth(font as Graphics.FontType) as Lang.Number {
    // 0.7 is guestimate, because there is no native getFontWidth
    return (Graphics.getFontAscent(font) * 0.7).toNumber();
}

function formatClocktime(time as ClockTime) as String {
    return (
        "" +
        time.hour +
        ":" +
        time.min.format("%02d") +
        ":" +
        time.sec.format("%02d")
    );
}

function strCountOccurrences(str as String, occur as String) as Lang.Number {
    var count = 0;
    var occurIndex;
    while (true) {
        occurIndex = str.find(occur);
        if (occurIndex == null) {
            break;
        }
        count += 1;
        str = str.substring(occurIndex + 1, null);
    }
    return count;
}

(:test)
function test_StrCountOccurrences(logger as Logger) as Boolean {
    var str = "first line\nsecond line\nthird line";
    var count = strCountOccurrences(str, "\n");
    return count == 2;
}

(:test)
function test_StrCountOccurrences2(logger as Logger) as Boolean {
    var str = "I don't have any";
    var count = strCountOccurrences(str, "foo");
    return count == 0;
}
