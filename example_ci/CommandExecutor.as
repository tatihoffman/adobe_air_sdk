package {
    import com.adjust.sdk.Adjust;
    import com.adjust.sdk.AdjustConfig;
    import com.adjust.sdk.AdjustEvent;
    import com.adjust.sdk.AdjustEventSuccess;
    import com.adjust.sdk.AdjustEventFailure;
    import com.adjust.sdk.AdjustSessionSuccess;
    import com.adjust.sdk.AdjustSessionFailure;
    import com.adjust.sdk.AdjustAttribution;
    import com.adjust.sdk.Environment;
    import com.adjust.sdk.LogLevel;
    import com.adjust.sdktesting.AdjustTesting;

    public class CommandExecutor {
        private var basePath:String;
        private var DefaultConfigName:String = "defaultConfig";
        private var DefaultEventName:String = "defaultEvent";
        private var savedInstances:Object = new Object();

        public function executeCommand(methodName:String, params:Object):void {
            switch (methodName) {
                case "factory"                        : factory(params); break;
                case "teardown"                       : teardown(params); break;
                case "config"                         : config(params); break;
                case "start"                          : start(params); break;
                case "event"                          : eventFunc(params); break;
                case "trackEvent"                     : trackEvent(params); break;
                case "resume"                         : resume(params); break;
                case "pause"                          : pause(params); break;
                case "setEnabled"                     : setEnabled(params); break;
                case "setReferrer"                    : setReferrer(params); break;
                case "setOfflineMode"                 : setOfflineMode(params); break;
                case "sendFirstPackages"              : sendFirstPackages(params); break;
                case "addSessionCallbackParameter"    : addSessionCallbackParameter(params); break;
                case "addSessionPartnerParameter"     : addSessionPartnerParameter(params); break;
                case "removeSessionCallbackParameter" : removeSessionCallbackParameter(params); break;
                case "removeSessionPartnerParameter"  : removeSessionPartnerParameter(params); break;
                case "resetSessionCallbackParameters" : resetSessionCallbackParameters(params); break;
                case "resetSessionPartnerParameters"  : resetSessionPartnerParameters(params); break;
                case "setPushToken"                   : setPushToken(params); break;
            }
        }

        private function teardown(params:Object):void {
            if(params.deleteState != null) {
                var deleteState:Boolean = params.deleteState[0];
                Adjust.teardown(deleteState);
            }
        }

        private function factory(params:Object):void {
            if (params['basePath']) {
                this.basePath = params['basePath'][0];
            }
        }

        private function config(params:Object):void {
            var configName:String = "";
            if (params.configName != null) {
                configName = params.configName[0];
            } else {
                configName = this.DefaultConfigName;
            }

            var adjustConfig:AdjustConfig;
            if (this.savedInstances[configName] != null) {
                adjustConfig = AdjustConfig(this.savedInstances[configName]);
            } else {
                var environment:String = params['environment'][0];
                var appToken:String = params['appToken'][0];

                adjustConfig = new AdjustConfig(appToken, environment);
                this.savedInstances[configName] = adjustConfig;
            }

            if (params['logLevel'] != null) {
                var logLevel:String = params['logLevel'][0];
                adjustConfig.setLogLevel(logLevel);
            }

            if (params['defaultTracker']) {
                var defaultTracker:String = params['defaultTracker'][0];
                adjustConfig.setDefaultTracker(defaultTracker);
            }

            if (params['delayStart']) {
                var delayStartS:String = params['delayStart'][0];
                var delayStart:Number = Number(delayStartS);
                adjustConfig.setDelayStart(delayStart);
            }

            if (params['eventBufferingEnabled']) {
                var eventBufferingEnabledS:String = params['eventBufferingEnabled'][0];
                var eventBufferingEnabled:Boolean = (eventBufferingEnabledS == 'true');
                adjustConfig.setEventBufferingEnabled(eventBufferingEnabled);
            }

            if (params['sendInBackground']) {
                var sendInBackgroundS:String = params['sendInBackground'][0];
                var sendInBackground:Boolean = (sendInBackgroundS == 'true');
                adjustConfig.setSendInBackground(sendInBackground);
            }

            if (params['userAgent']) {
                var userAgent:String = params['userAgent'][0];
                adjustConfig.setUserAgent(userAgent);
            }

            //resave the modified adjustConfig
            this.savedInstances[configName] = adjustConfig;
        }

        private function start(params:Object):void {
            this.config(params);
            var configName:String = null;
            if (params['configName'] != null) {
                configName = params['configName'][0];
            } else {
                configName = this.DefaultConfigName;
            }

            var adjustConfig:AdjustConfig = AdjustConfig(this.savedInstances[configName]);

            adjustConfig.setBasePath(this.basePath);
            //resave the modified adjustConfig
            this.savedInstances[configName] = adjustConfig;
            Adjust.start(adjustConfig);
        }

        private function eventFunc(params:Object):void {
            var eventName:String = null;
            if (params['eventName'] != null) {
                eventName = params['eventName'][0];
            } else {
                eventName = this.DefaultEventName;
            }

            var adjustEvent:AdjustEvent;
            if (this.savedInstances[eventName] != null) {
                adjustEvent = AdjustEvent(this.savedInstances[eventName]);
            } else {
                var eventToken:String = params['eventToken'][0];

                adjustEvent = new AdjustEvent(eventToken);
                this.savedInstances[eventName] = adjustEvent;
            }

            if (params['revenue'] != null) {
                var revenueParams:Array = params['revenue'];
                var currency:String = revenueParams[0];
                var revenue:Number = Number(revenueParams[1]);
                adjustEvent.setRevenue(revenue, currency);
            }

            if (params['callbackParams'] != null) {
                var callbackParams:Array = params["callbackParams"];
                for (var i:Number = 0; i < callbackParams.length; i = i + 2) {
                    var key:String = callbackParams[i];
                    var value:String = callbackParams[i + 1];
                    adjustEvent.addCallbackParameter(key, value);
                }
            }

            if (params['partnerParams'] != null) {
                var partnerParams:Array = params["partnerParams"];
                for (i = 0; i < partnerParams.length; i = i + 2) {
                    key= partnerParams[i];
                    value= partnerParams[i + 1];
                    adjustEvent.addPartnerParameter(key, value);
                }
            }
            //TODO: Add JS wrapper for order Id
            //if (params['orderId'] != null) {
            //var orderId:String = params['orderId'][0];
            //adjustEvent.setOrderId(orderId);
            //}

            //resave the modified adjustEvent
            this.savedInstances[eventName] = adjustEvent;

            Adjust.trackEvent(adjustEvent);
        }

        private function trackEvent(params:Object):void {
            this.eventFunc(params);
            var eventName:String = null;
            if (params['eventName'] != null) {
                eventName = params['eventName'][0];
            } else {
                eventName = this.DefaultEventName;
            }
            var adjustEvent:AdjustEvent = AdjustEvent(this.savedInstances[eventName]);
            Adjust.trackEvent(adjustEvent);
        }

        private function setReferrer(params:Object):void {
            var referrer:String = params['referrer'][0];
            Adjust.setReferrer(referrer);
        }

        private function pause(params:Object):void {
            Adjust.onPause();
        }

        private function resume(params:Object):void {
            Adjust.onResume();
        }

        private function setEnabled(params:Object):void {
            var enabled:Boolean = params["enabled"][0] == 'true';
            Adjust.setEnabled(enabled);
        }

        private function setOfflineMode(params:Object):void {
            var enabled:Boolean = params["enabled"][0] == 'true';
            Adjust.setOfflineMode(enabled);
        }

        private function sendFirstPackages(params:Object):void {
            Adjust.sendFirstPackages();
        }

        private function addSessionCallbackParameter(params:Object):void {
            for (var param:String in params) {
                var arr:Array = params[param] as Array;
                var key:String = arr[0];
                var value:String = arr[1];
                Adjust.addSessionCallbackParameter(key, value);
            }
        }

        private function addSessionPartnerParameter(params:Object):void {
            for (var param:String in params) {
                var arr:Array = params[param] as Array;
                var key:String = arr[0];
                var value:String = arr[1];
                Adjust.addSessionPartnerParameter(key, value);
            }
        }

        private function removeSessionCallbackParameter(params:Object):void {
            var key:String = params['key'][0];
            Adjust.removeSessionCallbackParameter(key);
        }

        private function removeSessionPartnerParameter(params:Object):void {
            var key:String = params['key'][0];
            Adjust.removeSessionPartnerParameter(key);
        }

        private function resetSessionCallbackParameters(params:Object):void {
            Adjust.resetSessionCallbackParameters();
        }

        private function resetSessionPartnerParameters(params:Object):void {
            Adjust.resetSessionPartnerParameters();
        }

        private function setPushToken(params:Object):void {
            var token:String = params['pushToken'][0];
            Adjust.setDeviceToken(token);
        }
    }
}
