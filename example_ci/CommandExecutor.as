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
                case "sendReferrer"                   : sendReferrer(params); break;
                case "testBegin"                      : testBegin(params); break;
                case "testEnd"                        : testEnd(params); break;
            }
        }

        private function factory(params:Object):void {
            if (params['basePath'] != null) {
                this.basePath = getFirstParameterValue(params, 'basePath');
            }

            if (params['timerInterval'] != null) {
                Adjust.setTimerInterval(parseFloat(getFirstParameterValue(params, 'timerInterval')));
            }

            if (params['timerStart'] != null) {
                Adjust.setTimerStart(parseFloat(getFirstParameterValue(params, 'timerStart')));
            }

            if (params['sessionInterval'] != null) {
                Adjust.setSessionInterval(parseFloat(getFirstParameterValue(params, 'sessionInterval')));
            }

            if (params['subsessionInterval'] != null) {
                Adjust.setSubsessionInterval(parseFloat(getFirstParameterValue(params, 'subsessionInterval')));
            }
        }

        private function teardown(params:Object):void {
            if(params['deleteState'] != null) {
                var deleteState:Boolean = params.deleteState[0];
                Adjust.teardown(deleteState);
            }
        }

        private function config(params:Object):AdjustConfig {
            var environment:String = getFirstParameterValue(params, 'environment');
            var appToken:String = getFirstParameterValue(params, 'appToken');

            var adjustConfig:AdjustConfig = new AdjustConfig(appToken, environment);

            if (params['logLevel'] != null) {
                var logLevel:String = getFirstParameterValue(params, 'logLevel');
                adjustConfig.setLogLevel(logLevel);
            }

            if (params['defaultTracker'] != null) {
                var defaultTracker:String = getFirstParameterValue(params, 'defaultTracker');
                adjustConfig.setDefaultTracker(defaultTracker);
            }

            if (params['delayStart'] != null) {
                var delayStartS:String = getFirstParameterValue(params, 'delayStart');
                var delayStart:Number = Number(delayStartS);
                adjustConfig.setDelayStart(delayStart);
            }

            if (params['eventBufferingEnabled'] != null) {
                var eventBufferingEnabledS:String = getFirstParameterValue(params, 'eventBufferingEnabled');
                var eventBufferingEnabled:Boolean = (eventBufferingEnabledS == 'true');
                adjustConfig.setEventBufferingEnabled(eventBufferingEnabled);
            }

            if (params['sendInBackground'] != null) {
                var sendInBackgroundS:String = getFirstParameterValue(params, 'sendInBackground');
                var sendInBackground:Boolean = (sendInBackgroundS == 'true');
                adjustConfig.setSendInBackground(sendInBackground);
            }

            if (params['userAgent'] != null) {
                var userAgent:String = getFirstParameterValue(params, 'userAgent');
                adjustConfig.setUserAgent(userAgent);
            }

            if (params['attributionCallbackSendAll'] != null) {
                adjustConfig.setAttributionCallbackDelegate(attributionCallbackDelegate);
            }

            if (params['sessionCallbackSendSuccess'] != null) {
                adjustConfig.setSessionTrackingSucceededDelegate(sessionTrackingSucceededDelegate);
            }

            if (params['sessionCallbackSendFailure'] != null) {
                adjustConfig.setSessionTrackingFailedDelegate(sessionTrackingFailedDelegate);
            }

            if (params['eventCallbackSendSuccess'] != null) {
                adjustConfig.setEventTrackingSucceededDelegate(eventTrackingSucceededDelegate);
            }

            if (params['eventCallbackSendFailure'] != null) {
                adjustConfig.setEventTrackingFailedDelegate(eventTrackingFailedDelegate);
            }

            return adjustConfig;
        }

        private function start(params:Object):void {
            var adjustConfig:AdjustConfig = this.config(params);

            adjustConfig.setBasePath(this.basePath);

            Adjust.start(adjustConfig);
        }

        private function eventFunc(params:Object):AdjustEvent {
            var eventToken:String = getFirstParameterValue(params, 'eventToken');
            var adjustEvent:AdjustEvent = new AdjustEvent(eventToken);

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
                    key = partnerParams[i];
                    value = partnerParams[i + 1];

                    adjustEvent.addPartnerParameter(key, value);
                }
            }

            if (params['orderId'] != null) {
                var orderId:String = getFirstParameterValue(params, 'orderId');
                adjustEvent.setTransactionId(orderId);
            }

            return adjustEvent;
        }

        private function trackEvent(params:Object):void {
            var adjustEvent:AdjustEvent = this.eventFunc(params);
            Adjust.trackEvent(adjustEvent);
        }

        private function setReferrer(params:Object):void {
            var referrer:String = getFirstParameterValue(params, 'referrer');
            Adjust.setReferrer(referrer);
        }

        private function pause(params:Object):void {
            Adjust.onPause(null);
        }

        private function resume(params:Object):void {
            Adjust.onResume(null);
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
            var deeplink:String = getFirstParameterValue(params, "deeplink");
            Adjust.appWillOpenUrl(deeplink);
        }

        private function sendReferrer(params:Object):void {
            var referrer:String = getFirstParameterValue(params, 'referrer');
            Adjust.setReferrer(referrer);
        }

        private function testBegin(params:Object):void {
            if (params['basePath'] != null) {
                this.basePath = getFirstParameterValue(params, "basePath");
            }

            Adjust.teardown(true);
            Adjust.setTimerInterval(-1);
            Adjust.setTimerStart(-1);
            Adjust.setSessionInterval(-1);
            Adjust.setSubsessionInterval(-1);
        }

        private function testEnd(params:Object):void {
            Adjust.teardown(true);
        }

        private function attributionCallbackDelegate(attribution:AdjustAttribution):void {
            AdjustTesting.addInfoToSend("trackerToken", attribution.getTrackerToken());
            AdjustTesting.addInfoToSend("trackerName", attribution.getTrackerName());
            AdjustTesting.addInfoToSend("network", attribution.getNetwork());
            AdjustTesting.addInfoToSend("campaign", attribution.getCampaign());
            AdjustTesting.addInfoToSend("adgroup", attribution.getAdGroup());
            AdjustTesting.addInfoToSend("creative", attribution.getCreative());
            AdjustTesting.addInfoToSend("clickLabel", attribution.getClickLabel());
            AdjustTesting.addInfoToSend("adid", attribution.getAdid());

            AdjustTesting.sendInfoToServer();
        }

        private function eventTrackingSucceededDelegate(eventSuccess:AdjustEventSuccess):void {
            AdjustTesting.addInfoToSend("message", eventSuccess.getMessage());
            AdjustTesting.addInfoToSend("timestamp", eventSuccess.getTimeStamp());
            AdjustTesting.addInfoToSend("adid", eventSuccess.getAdid());
            AdjustTesting.addInfoToSend("eventToken", eventSuccess.getEventToken());
            AdjustTesting.addInfoToSend("jsonResponse", eventSuccess.getJsonResponse());

            AdjustTesting.sendInfoToServer();
        }

        private function eventTrackingFailedDelegate(eventFail:AdjustEventFailure):void {
            AdjustTesting.addInfoToSend("message", eventFail.getMessage());
            AdjustTesting.addInfoToSend("timestamp", eventFail.getTimeStamp());
            AdjustTesting.addInfoToSend("adid", eventFail.getAdid());
            AdjustTesting.addInfoToSend("eventToken", eventFail.getEventToken());
            AdjustTesting.addInfoToSend("willRetry", eventFail.getWillRetry().toString());
            AdjustTesting.addInfoToSend("jsonResponse", eventFail.getJsonResponse());

            AdjustTesting.sendInfoToServer();
        }

        private function sessionTrackingSucceededDelegate(sessionSuccess:AdjustSessionSuccess):void {
            AdjustTesting.addInfoToSend("message", sessionSuccess.getMessage());
            AdjustTesting.addInfoToSend("timestamp", sessionSuccess.getTimeStamp());
            AdjustTesting.addInfoToSend("adid", sessionSuccess.getAdid());
            AdjustTesting.addInfoToSend("jsonResponse", sessionSuccess.getJsonResponse());

            AdjustTesting.sendInfoToServer();
        }

        private function sessionTrackingFailedDelegate(sessionFail:AdjustSessionFailure):void {
            AdjustTesting.addInfoToSend("message", sessionFail.getMessage());
            AdjustTesting.addInfoToSend("timestamp", sessionFail.getTimeStamp());
            AdjustTesting.addInfoToSend("adid", sessionFail.getAdid());
            AdjustTesting.addInfoToSend("willRetry", sessionFail.getWillRetry().toString());
            AdjustTesting.addInfoToSend("jsonResponse", sessionFail.getJsonResponse());

            AdjustTesting.sendInfoToServer();
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
