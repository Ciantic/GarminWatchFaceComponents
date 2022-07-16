import Toybox.Lang;
import Toybox.Graphics;

// This layer has nothing to do with WatchUi layers, it's component layer
class ComponentLayer extends Component {
    (:debug)
    public var name as Lang.String = "ComponentLayer";

    private var _components as Lang.Array<Component>;
    private var _componentsWithPartial as Lang.Array<Component>;
    private var _lastDrawArea as MyBoundingBox;

    public function initialize(box as MyBoundingBox) {
        self._components = [] as Lang.Array<Component>;
        self._componentsWithPartial = [] as Lang.Array<Component>;
        self._lastDrawArea = box.clone();
        Component.initialize(box);
    }

    public function add(com as Component) as Void {
        // If any of the child components is partial, then the layer is taking
        // part in partial updates
        if (com.partialUpdates) {
            self._componentsWithPartial.add(com);
            self.partialUpdates = true;
        }
        self._components.add(com);
    }

    public function update() as Void {
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            com.update();
            if (com.isInvalid()) {
                self._invalid = true;
            }
        }
    }

    public function updatePartial() as Void {
        for (var i = 0; i < self._componentsWithPartial.size(); i++) {
            var com = self._componentsWithPartial[i];
            com.updatePartial();
            if (com.isInvalid()) {
                self._invalid = true;
            }
        }
    }

    public function renderToView(dc as Dc, partial as Boolean) as Void {
        var bitmap = self.render();
        if (bitmap == null) {
            log("Unknown: renderToView Bitmap not found?");
            return;
        }

        if (partial) {
            var drawArea = self.getLastDrawArea();
            dc.setClip(drawArea.x, drawArea.y, drawArea.width, drawArea.height);
            dc.drawBitmap(0, 0, bitmap);
            dc.clearClip();
            // log("Partial draw area " + drawArea);
        } else {
            dc.drawBitmap(0, 0, bitmap);
        }
    }

    public function getLastDrawArea() as MyBoundingBox {
        return self._lastDrawArea;
    }

    protected function draw(bdc as Dc) as Void {
        var areas = new MyBoundingBox(0, 0, 0, 0);
        var bitmaps = [] as Array<BufferedBitmap or BufferedBitmapReference>;
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            var invalidArea = com.getLastDrawArea();
            var invalid = com.isInvalid();
            var bitmap = com.render();
            if (invalid) {
                var renderedArea = com.getLastDrawArea();
                areas.unionToSelf(invalidArea);
                areas.unionToSelf(renderedArea);
            }
            // log(
            //     "Render " +
            //         com.name +
            //         com.getId() +
            //         " mem: " +
            //         bitmapToStr(bitmap)
            // );
            bitmaps.add(bitmap);
        }

        // Restrict the area to the layer's bounding box
        areas.intersectToSelf(self.getBoundingBox());

        // Draw the components intersecting with the area
        bdc.setClip(areas.x, areas.y, areas.width, areas.height);
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            var bitmap = bitmaps[i];
            var box = com.getBoundingBox();

            // if (box.isIntersecting(areas)) {
            bdc.drawBitmap(box.x, box.y, bitmap);
            // log("Draw " + com.name + com.getId() + " on " + areas);
            // }
        }

        self._lastDrawArea = areas;

        Component.draw(bdc);

        // log("Draw " + areas);
    }
}
