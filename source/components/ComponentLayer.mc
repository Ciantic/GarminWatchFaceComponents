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
        self._lastDrawArea = new MyBoundingBox(0, 0, 0, 0);

        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            var changed = com.isInvalid();
            if (changed) {
                var invalidArea = com.getLastDrawArea();
                var combitmap = com.render();
                var comDrawnArea = com.getLastDrawArea();
                var combb = com.getBoundingBox();

                if (combitmap == null) {
                    log("Unknown: Combitmap was not fetched");
                    continue;
                }
                bdc.setClip(
                    invalidArea.x,
                    invalidArea.y,
                    invalidArea.width,
                    invalidArea.height
                );

                // For all layers before, check if their drawn part intersect
                // and draw the intersecting part
                for (var k = 0; k < i; k++) {
                    var underneath = self._components[k];
                    var uDrawnArea = underneath.getLastDrawArea();
                    var uubox = underneath.getBoundingBox();
                    var ubit = underneath.getBitmap();

                    if (ubit == null) {
                        log("Unknown: " + underneath.name + " no bitmap");
                        continue;
                    }
                    if (!uDrawnArea.isIntersecting(invalidArea)) {
                        continue;
                    }
                    bdc.drawBitmap(uubox.x, uubox.y, ubit);
                    // log("Draw bg: " + " " + underneath.name + " " + uDrawnArea);
                }

                bdc.setClip(
                    comDrawnArea.x,
                    comDrawnArea.y,
                    comDrawnArea.width,
                    comDrawnArea.height
                );
                bdc.drawBitmap(combb.x, combb.y, combitmap);
                bdc.clearClip();
                self._lastDrawArea.unionToSelf(invalidArea);
                self._lastDrawArea.unionToSelf(comDrawnArea);
                // log(
                //     "Invalid " +
                //         com.name +
                //         " " +
                //         invalidArea +
                //         " new " +
                //         comDrawnArea +
                //         " comb " +
                //         self._lastDrawArea
                // );
            }
        }
    }
}
