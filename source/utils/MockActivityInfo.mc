import Toybox.Lang;
import Toybox.Math;
import Toybox.Position;

(:debug)
class MockActivityInfo {
    public var currentHeartRate as Lang.Number = 50;
    public var altitude as Lang.Number = 1500;
    public var currentLocation as Position.Location?;

    function update() as Void {
        // self.currentHeartRate = 50 + (Math.rand() % 60);
        // self.altitude = 500 + (Math.rand() % 1000);
        self.currentLocation = new Position.Location({
            :latitude => 62.27d,
            :longitude => 25.83d,
            :format => :degrees,
        });
    }
}
