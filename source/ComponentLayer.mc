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

    protected function shouldRedraw() as Boolean {
        for (var i = 0; i < self._components.size(); i++) {
            var com = self._components[i];
            if (com.__shouldRedraw()) {
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
                // System.println(
                //     "drawnAreas " +
                //         bb.x +
                //         " " +
                //         bb.y +
                //         " " +
                //         bb.width +
                //         " " +
                //         bb.height
                // );
                // dc.setClip(0, 0, 1, 1);
                dc.setClip(bb.x, bb.y, bb.width, bb.height);
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
                dc.clear();
                dc.drawBitmap(0, 0, bitmap);
                // dc.drawOffsetBitmap(
                //     bb.x,
                //     bb.y,
                //     bb.x,
                //     bb.y,
                //     bb.width,
                //     bb.height,
                //     bitmap
                // );
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
            var changed = com.__shouldRedraw();
            if (changed) {
                var combitmap = com.render() as BufferedBitmapReference;
                if (combitmap == null) {
                    System.println("Unknown: Combitmap was not fetched");
                    continue;
                }
                bdc.setClip(
                    com.getOffsetX(),
                    com.getOffsetY(),
                    com.getWidth(),
                    com.getHeight()
                );
                // TODO: This should actually find overlapping elements in the
                // layer and clear them here
                bdc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                bdc.clear();
                bdc.drawBitmap(com.getOffsetX(), com.getOffsetY(), combitmap);
                bdc.clearClip();
                var bb = com.getBoundingBox();
                System.println("Drawn x " + bb.toString());
                drawnAreas.add(bb);
            }
        }

        self._drawnAreas = drawnAreas;
    }
}
