import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Test;
import Toybox.Math;

typedef SunComponentSettings as {
        :format as Lang.String?,
        :textSettings as TextSettings,
    };

class SunComponent extends TextComponent {
    (:debug)
    public var name as Lang.String = "SunComponent";
    private var _nextSunEvent as Time.Moment?;

    public function initialize(params as SunComponentSettings) {
        var textSettings = params.get(:textSettings) as TextSettings;
        textSettings[:text] = "0000";
        TextComponent.initialize(textSettings);
    }

    public function update() as Void {
        // Check if the next sun event has elapsed, then refetch
        var now = GLOBAL_STATE.now();
        var nextSunEvent = self._nextSunEvent;
        if (nextSunEvent != null) {
            if (now.greaterThan(nextSunEvent)) {
                self._nextSunEvent = null;
                self._invalid = true;
            }
        }

        // Try to get the next sun event
        if (self._nextSunEvent == null) {
            var loc = GLOBAL_STATE.getLocation();
            if (loc != null) {
                var latlon = loc.toDegrees();
                var sun = SunCalc.nextSunEvent(now, latlon[0], latlon[1]);
                if (sun != null) {
                    log("Next sun event: " + formatMoment(sun));
                    self._nextSunEvent = sun;
                }
                self._invalid = true;
            }
        }
    }

    protected function draw(dc as Dc) as Void {
        var sunEvent = self._nextSunEvent;
        if (sunEvent != null) {
            var info = Gregorian.info(sunEvent, Time.FORMAT_SHORT);
            self._text = info.hour + ":" + info.min.format("%02d");
        } else {
            self._text = "--:--";
        }
        TextComponent.draw(dc);
    }
}

module SunCalc {
    function getJulianDate(moment as Time.Moment) as Lang.Double {
        var info = Gregorian.utcInfo(moment, Time.FORMAT_SHORT);

        // US navy's instructions, valid between years 1801 - 2099
        // https://aa.usno.navy.mil/faq/JD_formula.html
        var I = info.day;
        var M = info.month as Lang.Number;
        var K = info.year;
        var UT1 = info.hour + info.min / 60.0d + info.sec / 3600.0d;
        return (
            367 * K -
            (7 * (K + (M + 9) / 12)) / 4 +
            (275 * M) / 9 +
            I +
            1721013.5d +
            UT1 / 24.0d -
            0.5d * sign(100 * K + M - 190002.5d) +
            0.5d
        );
    }

    (:test)
    function test_getJulianDate(logger as Logger) as Boolean {
        var jdn = getJulianDate(
            Gregorian.moment({
                :year => 1978,
                :month => 1,
                :day => 1,
                :hour => 0,
                :minute => 0,
            })
        );
        // logger.debug(jdn);
        return 2443509.5d == jdn;
    }

    function getGregorianDate(julianDate as Lang.Double) as Time.Moment {
        // https://en.wikipedia.org/wiki/Julian_day#Julian_or_Gregorian_calendar_from_Julian_day_number
        var J = julianDate.toNumber();
        var y = 4716;
        var v = 3;
        var j = 1401;
        var u = 5;
        var m = 2;
        var s = 153;
        var n = 12;
        var w = 2;
        var r = 4;
        var B = 274277;
        var p = 1461;
        var C = -38;

        var f = J + j + (((4 * J + B) / 146097) * 3) / 4 + C;
        var e = r * f + v;
        var g = (e % p) / r;
        var h = u * g + w;
        var D = (h % s) / u + 1;
        var M = ((h / s + m) % n) + 1;
        var Y = e / p - y + (n + m - M) / n;
        var fraction = julianDate - julianDate.toNumber();
        var seconds = Math.round(86400.0d * fraction).toNumber();
        var day = Gregorian.moment({
            :year => Y,
            :month => M,
            :day => D,
            :hour => 12,
            :minute => 0,
            :second => 0,
        }).add(new Time.Duration(seconds));
        return day;
    }

    (:test)
    function test_getGregorianDate(logger as Logger) as Boolean {
        var jdn = getGregorianDate(2443509.5d);
        var info = Gregorian.utcInfo(jdn, Time.FORMAT_SHORT);
        // logger.debug(
        //     info.year +
        //         " " +
        //         info.month +
        //         " " +
        //         info.day +
        //         " " +
        //         info.hour +
        //         ":" +
        //         info.min +
        //         ":" +
        //         info.sec
        // );
        return (
            info.year == 1978 &&
            info.day == 1 &&
            info.month == 1 &&
            info.hour == 0 &&
            info.min == 0 &&
            info.sec == 0
        );
    }

    (:test)
    function test_getGregorianDate2(logger as Logger) as Boolean {
        var jdn = getGregorianDate(2456293.520833d);
        var info = Gregorian.utcInfo(jdn, Time.FORMAT_SHORT);
        // logger.debug(info.year + " " + info.month + " " + info.day);
        return (
            info.year == 2013 &&
            info.day == 1 &&
            info.month == 1 &&
            info.hour == 0 &&
            info.min == 30 &&
            info.sec == 0
        );
    }

    (:test)
    function test_getGregorianDat3(logger as Logger) as Boolean {
        var jdn = getGregorianDate(2456293d);
        var info = Gregorian.utcInfo(jdn, Time.FORMAT_SHORT);
        // logger.debug(info.year + " " + info.month + " " + info.day);
        return (
            info.year == 2012 &&
            info.day == 31 &&
            info.month == 12 &&
            info.hour == 12 &&
            info.min == 0 &&
            info.sec == 0
        );
    }

    class SunTimes {
        public var sunset as Time.Moment;
        public var sunrise as Time.Moment;
        public var noon as Time.Moment;
        function initialize(
            sunrise as Time.Moment,
            sunset as Time.Moment,
            noon as Time.Moment
        ) {
            self.sunrise = sunrise;
            self.sunset = sunset;
            self.noon = noon;
        }

        (:debug)
        function toString() as String {
            return (
                "noon: " +
                formatMoment(self.noon) +
                " " +
                "sunrise: " +
                formatMoment(self.sunrise) +
                " sunset: " +
                formatMoment(self.sunset)
            );
        }
    }

    function nextSunEvent(
        moment as Time.Moment,
        latitude as Lang.Double,
        longitude as Lang.Double
    ) as Time.Moment? {
        // Start iterating from a day before
        var day = new Time.Duration(86400);
        var sunmoment = moment.subtract(day) as Time.Moment;
        for (var i = 0; i <= 10; i++) {
            var sun = sunriseEquation(sunmoment, latitude, longitude);
            if (sun.sunrise.greaterThan(moment)) {
                return sun.sunrise;
            } else if (sun.sunset.greaterThan(moment)) {
                return sun.sunset;
            }
            sunmoment = sunmoment.add(day);
        }
        return null;
    }

    function sunriseEquation(
        moment as Time.Moment,
        latitude as Lang.Double,
        longitude as Lang.Double
    ) as SunTimes {
        // https://en.wikipedia.org/wiki/Sunrise_equation#Complete_calculation_on_Earth

        // var n = Math.ceil(getJulianDate(moment) - 2451545.0d + 0.0008d);
        var n = Math.ceil(getJulianDate(moment) - 2451545.0d); // Removed + 0.0008d??
        var Jstar = n - longitude / 360.0d;
        var M = mod(357.5291d + 0.98560028d * Jstar, 360);
        var C = 1.9148d * sin(M) + 0.02d * sin(2d * M) + 0.0003d * sin(3d * M);
        var lambda = mod(M + C + 180d + 102.9372d, 360);
        var Jtransit =
            2451545.0d + Jstar + 0.0053d * sin(M) - 0.0069d * sin(2d * lambda);
        var declination = asin(sin(lambda) * sin(23.44d));
        var hourAngle = acos(
            (sin(-0.83d) - sin(latitude) * sin(declination)) /
                (cos(latitude) * cos(declination))
        );
        // System.println("Jstar " + Jstar);
        // System.println("What " + (357.5291d + 0.98560028d * Jstar));
        // System.println("M " + M);
        // System.println("C " + C);
        // System.println("Declination " + declination);
        // System.println("Jtransit " + Jtransit);
        // System.println("Hour angle " + hourAngle);
        var sunrise = getGregorianDate(Jtransit - hourAngle / 360d);
        var sunset = getGregorianDate(Jtransit + hourAngle / 360d);
        var noon = getGregorianDate(Jtransit);
        return new SunTimes(sunrise, sunset, noon);
    }

    (:test)
    function test_sunriseEquation(logger as Logger) as Boolean {
        var val = sunriseEquation(
            Gregorian.moment({
                :year => 2022,
                :month => 7,
                :day => 22,
                :hour => 12,
                :minute => 0,
            }),
            62.27d,
            25.83d
        );
        var sunrise = Gregorian.utcInfo(val.sunrise, Time.FORMAT_SHORT);
        var sunset = Gregorian.utcInfo(val.sunset, Time.FORMAT_SHORT);
        var noon = Gregorian.utcInfo(val.noon, Time.FORMAT_SHORT);
        // logger.debug(formatMoment(val.sunrise));
        // logger.debug(formatMoment(val.sunset));
        logger.debug(formatMoment(val.noon));
        return (
            // Sunrise is 4:12 in Jyväskylä time (UTC+3)
            sunrise.hour == 1 &&
            sunrise.min == 12 &&
            // Sunset is 22:32 in Jyväskylä time (UTC+3)
            sunset.hour == 19 &&
            sunset.min == 32 &&
            // Noon is 13:22 in Jyväskylä time (UTC+3)
            noon.hour == 10 &&
            noon.min == 22
        );
    }

    // Mathematical helpers
    function sign(v as Lang.Double) as Lang.Double {
        if (v >= 0) {
            return 1.0d;
        } else {
            return -1.0d;
        }
    }
    function sin(angleDegrees as Lang.Double) as Lang.Double {
        return Math.sin(Math.toRadians(angleDegrees)).toDouble();
    }
    function cos(angleDegrees as Lang.Double) as Lang.Double {
        return Math.cos(Math.toRadians(angleDegrees)).toDouble();
    }
    function asin(value as Lang.Double) as Lang.Double {
        return Math.toDegrees(Math.asin(value)).toDouble();
    }
    function acos(value as Lang.Double) as Lang.Double {
        return Math.toDegrees(Math.acos(value)).toDouble();
    }
    function mod(value as Lang.Double, modulo as Lang.Number) as Lang.Double {
        // Modulus with doubles, not valid for negative values

        if (value < modulo) {
            return value;
        }
        var numOfDivisions = (value / modulo).toNumber();
        return value - numOfDivisions * modulo.toDouble();
    }
}
