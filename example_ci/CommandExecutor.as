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
                case "teardown"                       : teardown(params); break;
                case "openDeeplink"                   : openDeeplink(params); break;
                case "testBegin"                      : testBegin(params); break;
                case "testEnd"                        : testEnd(params); break;
            }
        }

        private function teardown(params:Object):void {
            if(params.deleteState != null) {
                var deleteState:Boolean = params.deleteState[0];
                Adjust.teardown(deleteState);
            }
        }

        private function factory(params:Object):void {
            if (params['basePath'] != null) {
                this.basePath = getFirstParameterValue(params, 'basePath');
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
                var environment:String = getFirstParameterValue(params, 'environment');
                var appToken:String = getFirstParameterValue(params, 'appToken');

                adjustConfig = new AdjustConfig(appToken, environment);
                this.savedInstances[configName] = adjustConfig;
            }

            if (params['logLevel'] != null) {
                var logLevel:String = getFirstParameterValue(params, 'logLevel');
                adjustConfig.setLogLevel(logLevel);
            }

            if (params['defaultTracker']) {
                var defaultTracker:String = getFirstParameterValue(params, 'defaultTracker');
                adjustConfig.setDefaultTracker(defaultTracker);
            }

            if (params['delayStart']) {
                var delayStartS:String = getFirstParameterValue(params, 'delayStart');
                var delayStart:Number = Number(delayStartS);
                adjustConfig.setDelayStart(delayStart);
            }

            if (params['eventBufferingEnabled']) {
                var eventBufferingEnabledS:String = getFirstParameterValue(params, 'eventBufferingEnabled');
                var eventBufferingEnabled:Boolean = (eventBufferingEnabledS == 'true');
                adjustConfig.setEventBufferingEnabled(eventBufferingEnabled);
            }

            if (params['sendInBackground']) {
                var sendInBackgroundS:String = getFirstParameterValue(params, 'sendInBackground');
                var sendInBackground:Boolean = (sendInBackgroundS == 'true');
                adjustConfig.setSendInBackground(sendInBackground);
            }

            if (params['userAgent']) {
                var userAgent:String = getFirstParameterValue(params, 'userAgent');
                adjustConfig.setUserAgent(userAgent);
            }

            //resave the modified adjustConfig
            this.savedInstances[configName] = adjustConfig;
        }

        private function start(params:Object):void {
            trace("[*] start >>>>>>>");
            this.config(params);
            var configName:String = null;
            if (params['configName'] != null) {
                configName = getFirstParameterValue(params, 'configName');
            } else {
                configName = this.DefaultConfigName;
            }

            trace("[*] start 1 >>>>>>>");
            var adjustConfig:AdjustConfig = AdjustConfig(this.savedInstances[configName]);

            adjustConfig.setBasePath(this.basePath);
            trace("[*] start 2 >>>>>>>");
            //resave the modified adjustConfig
            this.savedInstances[configName] = adjustConfig;
            trace("[*] start 3 >>>>>>>");
            Adjust.start(adjustConfig);
            trace("[*] start <<<<<<<");
        }

        private function eventFunc(params:Object):void {
            var eventName:String = null;
            if (params['eventName'] != null) {
                eventName = getFirstParameterValue(params, 'eventName');
            } else {
                eventName = this.DefaultEventName;
            }

            var adjustEvent:AdjustEvent;
            if (this.savedInstances[eventName] != null) {
                adjustEvent = AdjustEvent(this.savedInstances[eventName]);
            } else {
                var eventToken:String = getFirstParameterValue(params, 'eventToken');

                adjustEvent = new AdjustEvent(eventToken);
                this.savedInstances[eventName] = adjustEvent;
            }

            if (params['revenue'] != null) {
                var revenueParams:Array = getValueFromKey(params, 'revenue');
                var currency:String = revenueParams[0];
                var revenue:Number = Number(revenueParams[1]);
                adjustEvent.setRevenue(revenue, currency);
            }

            if (params['callbackParams'] != null) {
                var callbackParams:Array = getValueFromKey(params, "callbackParams");
                for (var i:Number = 0; i < callbackParams.length; i = i + 2) {
                    var key:String = callbackParams[i];
                    var value:String = callbackParams[i + 1];
                    adjustEvent.addCallbackParameter(key, value);
                }
            }

            if (params['partnerParams'] != null) {
                var partnerParams:Array = getValueFromKey(params, "partnerParams");
                for (i = 0; i < partnerParams.length; i = i + 2) {
                    key= partnerParams[i];
                    value= partnerParams[i + 1];
                    adjustEvent.addPartnerParameter(key, value);
                }
            }

            if (params['orderId'] != null) {
                var orderId:String = getFirstParameterValue(params, 'orderId');
                adjustEvent.setTransactionId(orderId);
            }

            //resave the modified adjustEvent
            this.savedInstances[eventName] = adjustEvent;

            Adjust.trackEvent(adjustEvent);
        }

        private function trackEvent(params:Object):void {
            trace("[*] trackEvent >>>>>>>");
            this.eventFunc(params);
            var eventName:String = null;
            if (params['eventName'] != null) {
                eventName = getFirstParameterValue(params, 'eventName');
            } else {
                eventName = this.DefaultEventName;
            }
            var adjustEvent:AdjustEvent = AdjustEvent(this.savedInstances[eventName]);
            Adjust.trackEvent(adjustEvent);
            trace("[*] trackEvent <<<<<<<");
        }

        private function setReferrer(params:Object):void {
            var referrer:String = getFirstParameterValue(params, 'referrer');
            Adjust.setReferrer(referrer);
        }

        private function pause(params:Object):void {
            Adjust.onPause();
        }

        private function resume(params:Object):void {
            Adjust.onResume();
        }

        private function setEnabled(params:Object):void {
            var enabled:Boolean = getFirstParameterValue(params, "enabled") == 'true';
            Adjust.setEnabled(enabled);
        }

        private function setOfflineMode(params:Object):void {
            var enabled:Boolean = getFirstParameterValue(params, "enabled") == 'true';
            Adjust.setOfflineMode(enabled);
        }

        private function sendFirstPackages(params:Object):void {
            Adjust.sendFirstPackages();
        }

        private function addSessionCallbackParameter(params:Object):void {
            for (var arr:Array in params['KeyValue']) {
                var key:String = arr[0];
                var value:String = arr[1];
                Adjust.addSessionCallbackParameter(key, value);
            }
        }

        private function addSessionPartnerParameter(params:Object):void {
            for (var arr:Array in params['KeyValue']) {
                var key:String = arr[0];
                var value:String = arr[1];
                Adjust.addSessionPartnerParameter(key, value);
            }
        }

        private function removeSessionCallbackParameter(params:Object):void {
            var key:String = getFirstParameterValue(params, 'key');
            Adjust.removeSessionCallbackParameter(key);
        }

        private function removeSessionPartnerParameter(params:Object):void {
            var key:String = getFirstParameterValue(params, 'key');
            Adjust.removeSessionPartnerParameter(key);
        }

        private function resetSessionCallbackParameters(params:Object):void {
            Adjust.resetSessionCallbackParameters();
        }

        private function resetSessionPartnerParameters(params:Object):void {
            Adjust.resetSessionPartnerParameters();
        }

        private function setPushToken(params:Object):void {
            var token:String = getFirstParameterValue(params, 'pushToken');
            Adjust.setDeviceToken(token);
        }

        private function openDeeplink(params:Object):void {
            trace("[*] openDeeplink");
            var deeplink:String = getFirstParameterValue(params, "deeplink");
            Adjust.appWillOpenUrl(deeplink);
        }

        private function testBegin(params:Object):void {
            trace("[*] testBegin >>>>>");
            if (params['basePath'] != null) {
                this.basePath = getFirstParameterValue(params, "basePath");
            }

            Adjust.teardown(true);
            Adjust.setTimerInterval(-1);
            Adjust.setTimerStart(-1);
            Adjust.setSessionInterval(-1);
            Adjust.setSubsessionInterval(-1);
            this.savedInstances = new Object();
            trace("[*] testBegin <<<<<<<");
        }

        private function testEnd(params:Object):void {
            trace("[*] testEnd >>>>>>>");
            Adjust.teardown(true);
            trace("[*] testEnd <<<<<<<");
        }

        private function getValueFromKey(params:Object, key:String):Array {
            if (params[key] != null) {
                return params[key];
            }

            return null;
        }

        private function getFirstParameterValue(params:Object, key:String):String {
            if (params[key] != null) {
                var param:Array = params[key];
                if(param.length >= 1) {
                    return param[0];
                }
            }

            return null;
        }
    }
}
