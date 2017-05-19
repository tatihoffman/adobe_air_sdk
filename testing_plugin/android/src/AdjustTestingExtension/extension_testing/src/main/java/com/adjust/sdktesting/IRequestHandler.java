package com.adjust.sdktesting;

public interface IRequestHandler {
    void init(IPackageHandler packageHandler);

    void sendPackage(ActivityPackage activityPackage, int queueSize);

    void teardown();
}
