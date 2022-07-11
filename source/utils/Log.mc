import Toybox.System;
import Toybox.Lang;

(:inline,:debug)
function log(message as Lang.String) as Void {
    System.println(message);
}

(:inline,:release)
function log(message as Lang.String) as Void {}
