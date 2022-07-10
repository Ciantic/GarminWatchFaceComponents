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
