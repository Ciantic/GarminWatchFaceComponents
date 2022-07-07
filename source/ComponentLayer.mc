import Toybox.Lang;
import Toybox.Graphics;

// This layer has nothing to do with WatchUi layers, it's component layer
class ComponentLayer extends Component {
    (:debug)
    public var name as Lang.String = "ComponentLayer";

    private var components as Lang.Array<Component>;
    private var invalidated as Lang.Array<MyBoundingBox>;

    public function initialize(
        params as
            {
                :width as Lang.Number,
                :height as Lang.Number,
            }
    ) {
        self.components = [] as Lang.Array<Component>;
        self.invalidated = [] as Lang.Array<MyBoundingBox>;
        Component.initialize(params);
    }

    public function add(com as Component) as Void {
        components.add(com);
        com.addToLayer(self);
    }

    public function doUpdate(time as Lang.Number) as Boolean {
        for (var i = 0; i < self.components.size(); i++) {
            var com = self.components[i];
            if (com.doUpdate(time)) {
                return true;
            }
        }
        return false;
    }

    private function getInvalidated() as Lang.Array<MyBoundingBox> {
        return self.invalidated;
    }

    public function renderToView(
        dc as Dc,
        now as Lang.Number,
        partial as Boolean
    ) as Void {
        self.render(now);
        var bitmap = self.getBitmap();
        if (bitmap == null) {
            System.println("Unknown: renderToView Bitmap not found?");
            return;
        }

        if (partial) {
            // System.println("Got bitmap? " + bitmap);
            var invalidated = self.getInvalidated();
            for (var i = 0; i < invalidated.size(); i++) {
                var bb = invalidated[i];
                // System.println(
                //     "Invalidated " +
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
            var fullbitmap = self.getBitmap();
            if (fullbitmap != null) {
                dc.drawBitmap(0, 0, fullbitmap);
            }
        }
    }

    protected function draw(bdc as Dc) as Void {
        var now = System.getTimer();
        var invalidated = [] as Lang.Array<MyBoundingBox>;

        for (var i = 0; i < self.components.size(); i++) {
            var com = self.components[i];
            var changed = com.render(now);
            if (changed) {
                var combitmap = com.getBitmap() as BufferedBitmapReference;
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
                var bb = new MyBoundingBox(
                    com.getOffsetX(),
                    com.getOffsetY(),
                    com.getWidth(),
                    com.getHeight()
                );
                System.println(
                    "Drawn x " +
                        bb.x +
                        " y " +
                        bb.y +
                        " " +
                        bb.width +
                        "*" +
                        bb.height
                );
                invalidated.add(bb);
            }
        }

        self.invalidated = invalidated;

        // if (partial) {
        //     for (var i = 0; i < invalidated.size(); i++) {
        //         var bb = invalidated[i];
        //         dc.setClip(bb.x, bb.y, bb.width, bb.height);
        //         dc.drawBitmap(bb.x, bb.y, fullbitmap);
        //         dc.clearClip();
        //     }
        // } else {
        //     dc.drawBitmap(0, 0, fullbitmap);
        // }

        // return new RenderResult(
        //     self.bitmap as BufferedBitmapReference,
        //     invalidated
        // );
    }
}
