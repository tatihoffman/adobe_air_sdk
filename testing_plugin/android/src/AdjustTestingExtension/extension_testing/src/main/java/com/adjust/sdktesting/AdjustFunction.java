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

            CommandListener commandListener = new CommandListener(AdjustExtension.context);
            TestLibrary testLibrary = new TestLibrary(baseUrl, commandListener);
            testLibrary.initTestSession("adobe_air4.11.2@android4.11.4");
            Log.d(TAG, "InitTestSession: 3");
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        Log.d(TAG, "InitTestSession: end");
        return null;
    }
}
