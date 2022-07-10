/*
import Toybox.Lang;

class MyBoundingBoxSet {
    private var _set as Dictionary<MyBoundingBox, Boolean>;
    function initialize() {
        self._set = {} as Dictionary<MyBoundingBox, Boolean>;
    }

    public function add(box as MyBoundingBox) as Void {
        var values = self._set.keys();
        for (var i = 0; i < values.size(); i++) {
            var found = values[i];
            if (values[i].isIntersecting(box)) {
                var union = found.union(box);
                self._set.remove(found);
                self._set[union] = true;
                return;
            }
        }
        self._set[box] = true;
    }

    public function values() as Lang.Array<MyBoundingBox> {
        return self._set.keys();
    }
}
*/
