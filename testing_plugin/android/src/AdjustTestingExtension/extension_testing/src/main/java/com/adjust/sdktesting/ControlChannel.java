package com.adjust.sdktesting;

import java.util.concurrent.Future;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import static com.adjust.sdktesting.Utils.sendPostI;

/**
 * Created by nonelse on 21.03.17.
 */

public class ControlChannel {
    private static final String CONTROL_START_PATH = "/control_start";
    private static final String CONTROL_CONTINUE_PATH = "/control_continue";

    ScheduledThreadPoolExecutor controlChannelExecutor = new ScheduledThreadPoolExecutor(1);
    Future<?> controlChannelFuture;
    TestLibrary testLibrary;

    public ControlChannel(TestLibrary testLibrary) {
        this.testLibrary = testLibrary;
        sendControlRequest(CONTROL_START_PATH);
    }

    public void teardown() {
        Utils.debug("ControlChannel teardown");
        if (controlChannelFuture != null && !controlChannelFuture.isDone()) {
            Utils.debug("ControlChannel lastFuture.cancel");
            controlChannelFuture.cancel(true);
        }
        controlChannelFuture = null;
        if (controlChannelExecutor != null) {
            controlChannelExecutor.shutdownNow();
        }
        controlChannelExecutor = null;
    }

    private void sendControlRequest(final String controlPath) {
        this.controlChannelFuture = controlChannelExecutor.submit(new Runnable() {
            @Override
            public void run() {
                long timeBefore = System.nanoTime();
                Utils.debug("time before wait: %d", timeBefore);

                UtilsNetworking.HttpResponse httpResponse = Utils.sendPostI(
                        Utils.appendBasePath(testLibrary.currentBasePath, controlPath));

                long timeAfter = System.nanoTime();
                long timeElapsedMillis = TimeUnit.NANOSECONDS.toMillis(timeAfter - timeBefore);
                Utils.debug("time after wait: %d", timeAfter);
                Utils.debug("time elapsed waiting in milli seconds: %d", timeElapsedMillis);

                readControlHeaders(httpResponse);
            }
        });
    }

    void readControlHeaders(UtilsNetworking.HttpResponse httpResponse) {
        if (httpResponse.headerFields.containsKey(Constants.TEST_CANCELTEST_HEADER)) {
            Utils.debug("Test canceled due to %s", httpResponse.headerFields.get(Constants.TEST_CANCELTEST_HEADER).get(0));
//            testLibrary.flushExecution();
//            testLibrary.readHeaders(httpResponse);
        }
        if (httpResponse.headerFields.containsKey(Constants.TEST_ENDWAIT_HEADER)) {
            String waitEndReason = httpResponse.headerFields.get(Constants.TEST_ENDWAIT_HEADER).get(0);
            sendControlRequest(CONTROL_CONTINUE_PATH);
            endWait(waitEndReason);
        }
    }

    void endWait(String waitEndReason) {
        try {
            Utils.debug("End wait from control channel due to %s", waitEndReason);
            testLibrary.waitControlQueue.put(waitEndReason);
            Utils.debug("Wait ended from control channel due to %s", waitEndReason);
        } catch (InterruptedException e) {
            Utils.debug("wait put error: %s", e.getMessage());
        }
    }
}
