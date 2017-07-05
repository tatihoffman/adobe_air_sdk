package com.adjust.sdktesting {
    import flash.desktop.NativeApplication;
    import flash.events.*;
    import flash.external.ExtensionContext;

    public class AdjustTesting extends EventDispatcher {
        private static var mExtensionContext:ExtensionContext = null;
        private static var mTestingCommandCallbackDelegate:Function;

        private static function getExtensionContext():ExtensionContext {
            if (mExtensionContext != null) {
                return mExtensionContext;
            }

            return mExtensionContext = ExtensionContext.createExtensionContext("com.adjust.sdktesting", null);
        }

        public static function initTestSession(baseUrl:String, testingCommandCallbackDelegate:Function):void {
            mTestingCommandCallbackDelegate = testingCommandCallbackDelegate;
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            getExtensionContext().call("initTestSession", baseUrl);
        }

        public static function addInfoToSend(key:String, value:String):void {
            getExtensionContext().call("addInfoToSend", key, value);
        }

        public static function sendInfoToServer():void {
            getExtensionContext().call("sendInfoToServer");
        }

        public static function setTests(selectedTests:String):void {
            getExtensionContext().call("setTests", selectedTests);
        }

        private static function extensionResponseDelegate(statusEvent:StatusEvent):void {
            if (statusEvent.code == "adjusttesting_command") {
                mTestingCommandCallbackDelegate(statusEvent.level);
            }
        }
    }
}
