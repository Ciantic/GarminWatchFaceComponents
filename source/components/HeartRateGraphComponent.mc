import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.ActivityMonitor;

enum HRGDrawState {
    InitialLayout,
    InitialLayoutDone,
    DrawGraph,
    DrawMissingSamples,
}
class HeartRateGraphComponent extends Component {
    (:debug)
    public var name as Lang.String = "HeartRateGraphComponent";
    private var _drawState as HRGDrawState = InitialLayout;
    private var _bitmap2 as BufferedBitmapReference?;
    private var _lastWhen as Time.Moment?;

    public function initialize(box as MyBoundingBox) {
        // var width = params.get(:width) as Lang.Number?;
        // if (width == null) {
        //     width = 100;
        // }

        // var height = params.get(:height) as Lang.Number?;
        // if (height == null) {
        //     height = 100;
        // }
        Component.initialize(box);
    }

    public function update() as Void {
        if (
            self._drawState == DrawMissingSamples &&
            GLOBAL_STATE.onceInUpdate()
        ) {
            self._invalid = true;
        } else if (self._drawState == InitialLayout) {
            self._invalid = true;
        } else if (
            self._drawState == DrawGraph &&
            GLOBAL_STATE.afterLayoutInSecs(2)
        ) {
            self._invalid = true;
        }
    }

    (:release)
    private function getHistory(
        dur as Time.Duration
    ) as ActivityMonitor.HeartRateIterator {
        return ActivityMonitor.getHeartRateHistory(dur, true);
    }

    (:debug)
    private function getHistory(
        dur as Time.Duration
    ) as ActivityMonitor.HeartRateIterator {
        return (
            MockActivityMonitor.getHeartRateHistory(dur, true) as
            ActivityMonitor.HeartRateIterator
        );
    }

    public function render() as BufferedBitmapReference {
        var bitmap = self.getBitmap();
        if (self.isInvalid()) {
            var ref = bitmap.get() as BufferedBitmap?;
            var bdc = ref != null ? ref.getDc() : null;
            if (bdc == null) {
                log("Unknown: Dc was not fetched");
                return bitmap;
            }
            draw(bdc);
            return bitmap;
        }
        return bitmap;
    }

    public function getBitmap2() as BufferedBitmapReference {
        var bitmap = self._bitmap2 as BufferedBitmapReference;
        var box = self.getBoundingBox();
        if (bitmap == null) {
            bitmap = Graphics.createBufferedBitmap({
                :width => box.width,
                :height => box.height,
            });
            self._bitmap2 = bitmap;
        }
        return bitmap;
    }

    protected function draw(dc as Dc) as Void {
        switch (self._drawState) {
            case DrawMissingSamples:
                self.drawMissingSamples(dc);
                break;
            case InitialLayout:
                self.drawInitialLayout(dc);
                self._drawState = DrawGraph;
                break;
            case DrawGraph:
                self.drawGraph(dc);
                self._drawState = DrawMissingSamples;
                break;
        }

        Component.draw(dc);
    }

    private function moveDrawingToLeft(dc as Dc, x as Lang.Number) as Void {
        var bit1 = self.getBitmap();
        // FR955 seems to be able to do this with just drawing itself over
        // itself without blend mode
        if (dc has :setBlendMode) {
            var box = self.getBoundingBox();
            dc.setBlendMode(Graphics.BLEND_MODE_NO_BLEND);
            dc.drawBitmap(-x, 0, bit1);
            dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
            dc.setClip(box.width - x, 0, x, box.height);
            dc.clear();
            dc.clearClip();
            dc.setBlendMode(Graphics.BLEND_MODE_DEFAULT);
            return;
        }

        var bit2 = self.getBitmap2();
        var bit2b = bit2.get() as BufferedBitmap;
        if (bit2b == null) {
            log("Unknown: Bitmap2 missing");
            return;
        }
        var dc2 = bit2b.getDc();
        if (dc2 == null) {
            log("Unknown: Bitmap2 missing");
            return;
        }
        dc2.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        dc2.clear();
        dc2.drawBitmap(-x, 0, bit1);
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.drawBitmap(0, 0, bit2);
    }

    private function drawInitialLayout(dc as Dc) as Void {
        var box = self.getBoundingBox();
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_DK_RED);
        dc.setClip(0, box.height - 50, box.width, 50);
        dc.clear();
        dc.clearClip();
    }

    private function drawMissingSamples(dc as Dc) as Void {
        var lastWhen = self._lastWhen;
        if (lastWhen == null) {
            return;
        }

        var elapsed = GLOBAL_STATE.getNow().subtract(lastWhen) as Time.Duration;
        var hrIterator = self.getHistory(elapsed);
        if (hrIterator == null) {
            self._invalid = false;
            return;
        }

        var box = self.getBoundingBox();
        var newLastWhen = null as Time.Moment?;
        var samples = [] as Lang.Array<Lang.Number>;
        for (var i = 0; i < box.width; i++) {
            var hrs = hrIterator.next();
            if (hrs == null) {
                break;
            }
            var hr = hrs.heartRate;
            if (hr == null) {
                hr = 0;
            }
            if (hr == ActivityMonitor.INVALID_HR_SAMPLE) {
                hr = 0;
            }
            var when = hrs.when;
            if (when == null) {
                continue;
            }
            if (when.lessThan(lastWhen)) {
                break;
            }
            if (newLastWhen == null) {
                newLastWhen = when;
            }
            samples.add(hr);
        }

        if (newLastWhen != null) {
            self._lastWhen = newLastWhen;
        }
        self.moveDrawingToLeft(dc, samples.size());
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < samples.size(); i++) {
            var hr = samples[i];
            dc.drawLine(
                box.width - i - 1,
                box.height,
                box.width - i - 1,
                max(box.height - hr, 0)
            );
        }
    }

    private function drawGraph(dc as Dc) as Void {
        var box = self.getBoundingBox();
        var hrIterator = self.getHistory(new Time.Duration(box.width * 60));
        if (hrIterator == null) {
            self._invalid = false;
            return;
        }
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        for (var i = 0; i < box.width; i++) {
            var hrs = hrIterator.next();
            if (hrs == null) {
                break;
            }
            var hr = hrs.heartRate;
            if (hr == null) {
                hr = 0;
            }
            if (hr == ActivityMonitor.INVALID_HR_SAMPLE) {
                hr = 0;
            }
            var when = hrs.when;
            if (when == null) {
                continue;
            }
            if (self._lastWhen == null) {
                self._lastWhen = when;
            }
            dc.drawLine(
                box.width - i - 1,
                box.height,
                box.width - i - 1,
                max(box.height - hr, 0)
            );
        }
    }
}
