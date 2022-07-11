import Toybox.Lang;
import Toybox.Math;

(:debug)
class MockActivityInfo {
    public var currentHeartRate as Lang.Number = 0;
    public var altitude as Lang.Number = 0;

    function update() as Void {
        self.currentHeartRate = Math.rand() % 130;
        self.altitude = 1000 + (Math.rand() % 1000);
    }
}
