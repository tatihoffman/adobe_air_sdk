package com.adjust.sdktesting;

import android.util.Log;

import com.adobe.fre.FREContext;

public class CommandListener implements ICommandRawJsonListener {
    private static final String TAG = "CommandListener";
    private FREContext mContext;

    public CommandListener(FREContext context) {
        Log.d(TAG, "CommandListener: hello woraaaaaaaaaaaaaaaaaaaald");
        mContext = context;
    }

    @Override
    public void executeCommand(String json) {
        Log.d(TAG, "executeCommand: Received command with json: " + json);
        mContext.dispatchStatusEventAsync("adjusttesting_command", json);
    }
}