import Toybox.Lang;
import Toybox.Math;

(:debug)
class MockActivityInfo {
    public var currentHeartRate as Lang.Number = 0;
    public var altitude as Lang.Number = 0;

    function update() as Void {
        self.currentHeartRate = 50 + (Math.rand() % 60);
        self.altitude = 1000 + (Math.rand() % 1000);
    }
}
