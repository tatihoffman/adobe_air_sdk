package com.adjust.sdktesting;

public class CommandListener implements ICommandRawJsonListener {
    @Override
    public void executeCommand(String json) {
        AdjustExtension.context.dispatchStatusEventAsync("adjusttesting_command", json);
    }
}