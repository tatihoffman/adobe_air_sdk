package com.adjust.sdktesting;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by pfms on 31/07/14.
 */
public class AdjustContext extends FREContext {
    public static String InitTestSession = "initTestSession";

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

        functions.put(AdjustContext.InitTestSession, new AdjustFunction(AdjustContext.InitTestSession));

        return functions;
    }

    @Override
    public void dispose() {}
}
