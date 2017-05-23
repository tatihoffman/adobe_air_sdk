package com.adjust.sdktesting;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
 * Created by pfms on 31/07/14.
 */
public class AdjustFunction implements FREFunction {
    private static final String TAG = "AdjustFunction";
    private String functionName;

    public AdjustFunction(String functionName) {
        this.functionName = functionName;
    }

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        AdjustExtension.context = (AdjustContext) freContext;

        if (functionName == AdjustContext.InitTestSession) {
            return InitTestSession(freContext, freObjects);
        }

        return null;
    }

    private FREObject InitTestSession(FREContext freContext, FREObject[] freObjects) {
        try {
            String baseUrl = null;

            if (freObjects[0] != null) {
                baseUrl = freObjects[0].getAsString();
            }
            Log.d(TAG, "initTestSession() with baseUrl[" + baseUrl + "]");

//            if (freObjects[1] != null) {
//                Boolean isCallbackSet = freObjects[1].getAsBool();
//
////                if (isCallbackSet) {
////                    adjustConfig.setOnAttributionChangedListener(this);
////                }
//            }


            Log.d(TAG, "InitTestSession: 1");
            CommandListener commandListener = new CommandListener(AdjustExtension.context);
            Log.d(TAG, "InitTestSession: 1.5");
            TestLibrary.foo();
            TestLibrary testLibrary = new TestLibrary(baseUrl, commandListener);
            Log.d(TAG, "InitTestSession: 2");
//            testLibrary.initTestSession("adobe_air4.11.2@android4.11.4");
            Log.d(TAG, "InitTestSession: 3");
        } catch (Exception e) {
            Log.d(TAG, "InitTestSession: 4");
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        Log.d(TAG, "InitTestSession: end");
        return null;
    }

//    @Override
//    public void onFinishedSessionTrackingFailed(AdjustSessionFailure event) {
//        if (event == null) {
//            return;
//        }
//
//        StringBuilder response = new StringBuilder();
//        response.append("message==" + event.message + "__"
//                + "timeStamp==" + event.timestamp + "__"
//                + "adid==" + event.adid + "__"
//                + "willRetry==" + event.willRetry + "__");
//
//        if (event.jsonResponse != null) {
//            response.append("jsonResponse==" + event.jsonResponse.toString());
//        }
//
//        AdjustExtension.context.dispatchStatusEventAsync("adjust_sessionTrackingFailed", response.toString());
//    }
//
//    @Override
//    public boolean launchReceivedDeeplink(Uri deeplink) {
//        String response = deeplink.toString();
//
//        AdjustExtension.context.dispatchStatusEventAsync("adjust_deferredDeeplink", response);
//
//        return shouldLaunchDeeplink;
//    }
}
