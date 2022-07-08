import Toybox.Lang;
import Toybox.Graphics;

// This layer has nothing to do with WatchUi layers, it's component layer
class ComponentLayer extends Component {
    (:debug)
    public var name as Lang.String = "ComponentLayer";

    private var _components as Lang.Array<Component>;
    private var _drawnAreas as Lang.Array<MyBoundingBox>;

    public function initialize(
        params as
            {
                :width as Lang.Number,
                :height as Lang.Number,
            }
    ) {
        self._components = [] as Lang.Array<Component>;
        self._drawnAreas = [] as Lang.Array<MyBoundingBox>;
        Component.initialize(params);
    }

    public function add(com as Component) as Void {
        self._components.add(com);
        com.addToLayer(self);
    }

    public function update(time as Lang.Number) as Void {
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            com.update(time);
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
            System.println("Unknown: renderToView Bitmap not found?");
            return;
        }

        if (partial) {
            for (var i = 0; i < self._drawnAreas.size(); i++) {
                var bb = self._drawnAreas[i];
                dc.setClip(bb.x, bb.y, bb.width, bb.height);
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
                dc.clear();
                dc.drawBitmap(0, 0, bitmap);
                dc.clearClip();
            }
        } else {
            dc.drawBitmap(0, 0, bitmap);
        }
    }

    protected function draw(bdc as Dc) as Void {
        var drawnAreas = [] as Lang.Array<MyBoundingBox>;

        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            var changed = com.isInvalid();
            if (changed) {
                var combitmap = com.render() as BufferedBitmapReference;
                if (combitmap == null) {
                    System.println("Unknown: Combitmap was not fetched");
                    continue;
                }
                var invalidAreas = com.getInvalidAreas();
                for (var j = 0; j < invalidAreas.size(); j++) {
                    var box = invalidAreas[j];
                    bdc.setClip(box.x, box.y, box.width, box.height);
                    bdc.setColor(
                        Graphics.COLOR_WHITE,
                        Graphics.COLOR_TRANSPARENT
                    );
                    bdc.clear();

                    // For all layers before, check if they intersect and draw
                    // the intersecting part
                    for (var k = 0; k < i; k++) {
                        var underneath = self._components[k];
                        var uDrawnAreas = underneath.getDrawnAreas();
                        var uubox = underneath.getBoundingBox();
                        var ubit = underneath.getBitmap();
                        if (ubit == null) {
                            log("Unknown: " + underneath.name + " no bitmap");
                            continue;
                        }
                        for (var h = 0; h < uDrawnAreas.size(); h++) {
                            var ubox = uDrawnAreas[h];
                            if (!ubox.isIntersecting(box)) {
                                continue;
                            }
                            // log("Draw intersect of " + ubox + " and " + box);
                            bdc.drawBitmap(uubox.x, uubox.y, ubit);
                        }
                    }
                }

                var comDrawnAreas = com.getDrawnAreas();
                var combb = com.getBoundingBox();
                for (var j = 0; j < comDrawnAreas.size(); j++) {
                    var box = comDrawnAreas[j];
                    bdc.setClip(box.x, box.y, box.width, box.height);
                    bdc.drawBitmap(combb.x, combb.y, combitmap);
                    drawnAreas.add(box);
                    // log("Drawn " + com.name + " " + box.toString());
                }
                bdc.clearClip();

                // var bb = com.getBoundingBox();
                // bdc.setClip(bb.x, bb.y, bb.width, bb.height);
                // // TODO: This should actually find overlapping elements in the
                // // layer and clear them here
                // bdc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                // bdc.clear();
                // bdc.drawBitmap(bb.x, bb.y, combitmap);
                // bdc.clearClip();
            }
        }

        self._drawnAreas = drawnAreas;
    }
}
