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
        var areas = new MyBoundingBox(0, 0, 0, 0);
        var bitmaps = [] as Array<BufferedBitmapReference>;
        var boxes = [] as Array<MyBoundingBox>;
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            var invalidArea = com.getLastDrawArea();
            var invalid = com.isInvalid();
            var box = com.getBoundingBox();
            var bitmap = com.render();
            var renderedArea = com.getLastDrawArea();
            if (invalid) {
                areas.unionToSelf(invalidArea);
                areas.unionToSelf(renderedArea);
            }
            bitmaps.add(bitmap);
            boxes.add(box);
        }

        bdc.setClip(areas.x, areas.y, areas.width, areas.height);
        for (var i = 0; i < bitmaps.size(); i++) {
            var bitmap = bitmaps[i];
            var box = boxes[i];
            bdc.drawBitmap(box.x, box.y, bitmap);
        }

        self._lastDrawArea = areas;

        // log("Draw " + areas);
    }
}
