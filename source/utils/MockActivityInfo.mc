import Toybox.Lang;
import Toybox.Math;

(:debug)
class MockActivityInfo {
    public var currentHeartRate as Lang.Number = 50;
    public var altitude as Lang.Number = 1500;

    function update() as Void {
        // self.currentHeartRate = 50 + (Math.rand() % 60);
        // self.altitude = 500 + (Math.rand() % 1000);
    }
}
