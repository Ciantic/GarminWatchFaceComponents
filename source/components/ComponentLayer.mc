import Toybox.Lang;
import Toybox.Graphics;

// This layer has nothing to do with WatchUi layers, it's component layer
class ComponentLayer extends Component {
    (:debug)
    public var name as Lang.String = "ComponentLayer";

    private var _components as Lang.Array<Component>;
    private var _lastDrawArea as MyBoundingBox;

    public function initialize(box as MyBoundingBox) {
        self._components = [] as Lang.Array<Component>;
        self._lastDrawArea = box.clone();
        Component.initialize(box);
    }

    public function add(com as Component) as Void {
        self._components.add(com);
    }

    public function update() as Void {
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            com.update();
        }
    }

    public function isInvalid() as Boolean {
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            if (com.isInvalid()) {
                return true;
            }
        }
        return false;
    }

    public function renderToView(dc as Dc, partial as Boolean) as Void {
        var bitmap = self.render();
        if (bitmap == null) {
            log("Unknown: renderToView Bitmap not found?");
            return;
        }

        if (partial) {
            var drawArea = self.getLastDrawArea();
            // log("Partial draw area " + drawArea);
            dc.setClip(drawArea.x, drawArea.y, drawArea.width, drawArea.height);
            dc.drawBitmap(0, 0, bitmap);
            dc.clearClip();
        } else {
            dc.drawBitmap(0, 0, bitmap);
        }
    }

    public function getLastDrawArea() as MyBoundingBox {
        return self._lastDrawArea;
    }

    protected function draw(bdc as Dc) as Void {
        var lastDrawArea = new MyBoundingBox(0, 0, 0, 0);

        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            // As soon as any of the components is invalid, the ones coming
            // after it needs to be also re-rendered.
            if (!com.isInvalid()) {
                // lastDrawArea is set, then render the component on foreground
                // of it too
                if (lastDrawArea.width != 0) {
                    var comBox = com.getBoundingBox();
                    if (!lastDrawArea.isIntersecting(comBox)) {
                        continue;
                    }
                    var comBitmap = com.getBitmap();
                    if (comBitmap == null) {
                        log("Unknown: Combitmap was not fetched");
                        continue;
                    }
                    bdc.setClip(
                        lastDrawArea.x,
                        lastDrawArea.y,
                        lastDrawArea.width,
                        lastDrawArea.height
                    );
                    bdc.drawBitmap(comBox.x, comBox.y, comBitmap);
                }
                continue;
            }

            var comInvalidArea = com.getLastDrawArea();
            var comBitmap = com.render();
            var comDrawnArea = com.getLastDrawArea();
            var comBox = com.getBoundingBox();

            if (comBitmap == null) {
                log("Unknown: Combitmap was not fetched");
                continue;
            }
            bdc.setClip(
                comInvalidArea.x,
                comInvalidArea.y,
                comInvalidArea.width,
                comInvalidArea.height
            );

            // For all layers before, check if their drawn part intersect
            // and draw the intersecting part
            for (var k = 0; k < i; k++) {
                var underneath = self._components[k];
                var uBox = underneath.getBoundingBox();
                var uBitmap = underneath.getBitmap();

                if (uBitmap == null) {
                    log("Unknown: no bitmap");
                    continue;
                }
                if (!uBox.isIntersecting(comInvalidArea)) {
                    continue;
                }
                bdc.drawBitmap(uBox.x, uBox.y, uBitmap);
                // log("Draw bg: " + underneath.name + " bit " + comInvalidArea);
            }

            bdc.setClip(
                comDrawnArea.x,
                comDrawnArea.y,
                comDrawnArea.width,
                comDrawnArea.height
            );
            bdc.drawBitmap(comBox.x, comBox.y, comBitmap);
            bdc.clearClip();
            lastDrawArea.unionToSelf(comInvalidArea);
            lastDrawArea.unionToSelf(comDrawnArea);
            lastDrawArea.intersectToSelf(self.getBoundingBox());
            // log(
            //     "Invalid " +
            //         com.name +
            //         " " +
            //         comInvalidArea +
            //         " new " +
            //         comDrawnArea +
            //         " comb " +
            //         self._lastDrawArea
            // );
        }
        if (lastDrawArea.width != 0) {
            self._lastDrawArea = lastDrawArea;
        }
    }
}
