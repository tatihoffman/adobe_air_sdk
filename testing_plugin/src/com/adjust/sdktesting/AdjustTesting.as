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
            var app:NativeApplication = NativeApplication.nativeApplication;

            mTestingCommandCallbackDelegate = testingCommandCallbackDelegate;
            getExtensionContext().addEventListener(StatusEvent.STATUS, extensionResponseDelegate);

            getExtensionContext().call("initTestSession", baseUrl);
        }

        private static function extensionResponseDelegate(statusEvent:StatusEvent):void {
            if (statusEvent.code == "adjustesting_command") {
                mTestingCommandCallbackDelegate(statusEvent.level);
            }
        }
    }
}
