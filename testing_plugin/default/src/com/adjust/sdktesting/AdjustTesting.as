package com.adjust.sdktesting {
    import flash.events.*;

    public class AdjustTesting extends EventDispatcher {
        public static function initTestSession(baseUrl:String, testingCommandCallbackDelegate:Function):void {
            trace("adjust_testing: initTestSession called");
        }
    }
}
