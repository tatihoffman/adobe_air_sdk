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
    private static TestLibrary testLibrary;

    public AdjustFunction(String functionName) {
        this.functionName = functionName;
    }

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        AdjustExtension.context = (AdjustContext) freContext;

        if (functionName == AdjustContext.InitTestSession) {
            return InitTestSession(freContext, freObjects);
        }

        if (functionName == AdjustContext.AddInfoToSend) {
            return AddInfoToSend(freContext, freObjects);
        }

        if (functionName == AdjustContext.SendInfoToServer) {
            return SendInfoToServer(freContext, freObjects);
        }

        return null;
    }

    private FREObject InitTestSession(FREContext freContext, FREObject[] freObjects) {
        try {
            String baseUrl = null;

            if (freObjects[0] != null) {
                baseUrl = freObjects[0].getAsString();
            }

            testLibrary = new TestLibrary(baseUrl, new CommandListener());
            testLibrary.initTestSession("adobe_air4.11.2@android4.11.4");
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject AddInfoToSend(FREContext freContext, FREObject[] freObjects) {
        try {
            String key = freObjects[0].getAsString();
            String value = freObjects[1].getAsString();

            if (null != testLibrary) {
                testLibrary.addInfoToSend(key, value);
            }
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

    private FREObject SendInfoToServer(FREContext freContext, FREObject[] freObjects) {
        try {
            if (null != testLibrary) {
                testLibrary.sendInfoToServer();
            }
        } catch (Exception e) {
            Log.e(AdjustExtension.LogTag, e.getMessage());
        }

        return null;
    }

}
