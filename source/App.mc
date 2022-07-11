import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class App extends Application.AppBase {
    public function initialize() {
        AppBase.initialize();
    }

    public function onStart(state as Dictionary?) as Void {}

    public function onStop(state as Dictionary?) as Void {}

    public function getInitialView() as Array<Views or InputDelegates>? {
        var view = new $.Watch();
        var delegate = new $.WatchFaceDelegate();
        return [view, delegate] as Array<Views or InputDelegates>;
    }
}
