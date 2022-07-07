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

function getDc(bitmap as BufferedBitmapReference?) as Dc? {
    // Poor mans optiona chaining bitmap?.get()?.getDc()
    var ref = (bitmap != null ? bitmap.get() : null) as BufferedBitmap?;
    return ref != null ? ref.getDc() : null;
}

function getOrCreateDc(
    bitmap as BufferedBitmapReference?,
    width as Lang.Number,
    height as Lang.Number
) as Dc? {
    var ref = (bitmap != null ? bitmap.get() : null) as BufferedBitmap?;
    var dc = ref != null ? ref.getDc() : null;
    if (dc != null) {
        return dc;
    }

    // TODO: This may throw error: not enough memory
    bitmap = Graphics.createBufferedBitmap({
        :width => width,
        :height => height,
    });
    ref = (bitmap != null ? bitmap.get() : null) as BufferedBitmap?;
    dc = ref != null ? ref.getDc() : null;
    return dc;
}
