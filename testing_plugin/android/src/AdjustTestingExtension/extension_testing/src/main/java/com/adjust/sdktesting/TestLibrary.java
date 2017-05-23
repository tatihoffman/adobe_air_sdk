package com.adjust.sdktesting;

import android.os.SystemClock;
import android.util.Log;

import com.google.gson.Gson;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.Future;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.TimeUnit;


/**
 * Created by nonelse on 09.03.17.
 */

public class TestLibrary {
    private static final String TAG = "TestLibrary";
    static String baseUrl;
    ScheduledThreadPoolExecutor executor;
    ICommandListener commandListener;
    ICommandJsonListener commandJsonListener;
    ICommandRawJsonListener commandRawJsonListener;
    ControlChannel controlChannel;
    String currentTest;
    Future<?> lastFuture;
    String currentBasePath;
    Gson gson = new Gson();
    BlockingQueue<String> waitControlQueue;

    public static void foo() {
        Log.d(TAG, "foo: ");
    }

    public TestLibrary(String baseUrl, ICommandRawJsonListener commandRawJsonListener) {
        Log.d(TAG, "TestLibrary: >>>>>>>>.");
        dummy(baseUrl);
//        this(baseUrl);
//        this.commandRawJsonListener = commandRawJsonListener;

    }

//    public TestLibrary(String baseUrl, ICommandJsonListener commandJsonListener) {
//        this(baseUrl);
//        this.commandJsonListener = commandJsonListener;
//    }
//
//    public TestLibrary(String baseUrl, ICommandListener commandListener) {
//        this(baseUrl);
//        this.commandListener = commandListener;
//    }

    private void dummy(String baseUrl) {
        Log.d(TAG, "TestLibrary: 1");
//        this.baseUrl = baseUrl;
//        Log.d(TAG, "TestLibrary: 2");
//        Utils.debug("base url: %s", baseUrl);
//        Log.d(TAG, "TestLibrary: 3");
//        resetTestLibrary();
//        Log.d(TAG, "TestLibrary: 4");
    }

//    private TestLibrary(String baseUrl) {
//        Log.d(TAG, "TestLibrary: 1");
//        this.baseUrl = baseUrl;
//        Log.d(TAG, "TestLibrary: 2");
//        Utils.debug("base url: %s", baseUrl);
//        Log.d(TAG, "TestLibrary: 3");
//        resetTestLibrary();
//        Log.d(TAG, "TestLibrary: 4");
//    }

//    private void resetTestLibrary() {
//        Log.d(TAG, "resetTestLibrary: ");
//        executor = new ScheduledThreadPoolExecutor(1);
//        Log.d(TAG, "resetTestLibrary: 2");
//        waitControlQueue = new SynchronousQueue<>();
//        Log.d(TAG, "resetTestLibrary: 3");
//        lastFuture = null;
//    }
//
//    public void initTestSession(final String clientSdk) {
//        Log.d(TAG, "initTestSession: ");
//        lastFuture = executor.submit(new Runnable() {
//            @Override
//            public void run() {
//                Log.d(TAG, "run: ");
//                sendTestSessionI(clientSdk);
//            }
//        });
//    }
//
//    public void readHeaders(final UtilsNetworking.HttpResponse httpResponse) {
//        lastFuture = executor.submit(new Runnable() {
//            @Override
//            public void run() {
//                readHeadersI(httpResponse);
//            }
//        });
//    }
//
//    public void flushExecution() {
//        Utils.debug("flushExecution");
//        if (lastFuture != null && !lastFuture.isDone()) {
//            Utils.debug("lastFuture.cancel");
//            lastFuture.cancel(true);
//        }
//        executor.shutdownNow();
//
//        resetTestLibrary();
//    }
//
//    private void sendTestSessionI(String clientSdk) {
//        Log.d(TAG, "sendTestSessionI: ");
//        UtilsNetworking.HttpResponse httpResponse = Utils.sendPostI("/init_session", clientSdk);
//        Log.d(TAG, "sendTestSessionI: After sendPostI()");
//        if (httpResponse == null) {
//            Log.d(TAG, "sendTestSessionI: returning after a empty response");
//            return;
//        }
//
//        Log.d(TAG, "sendTestSessionI: reading headers...");
//        readHeadersI(httpResponse);
//    }
//
//    public void readHeadersI(UtilsNetworking.HttpResponse httpResponse) {
//        if (httpResponse.headerFields.containsKey(Constants.TEST_SESSION_END_HEADER)) {
//            if (controlChannel != null) {
//                controlChannel.teardown();
//            }
//            controlChannel = null;
//            Utils.debug("TestSessionEnd received");
//            return;
//        }
//
//        if (httpResponse.headerFields.containsKey(Constants.BASE_PATH_HEADER)) {
//            currentBasePath = httpResponse.headerFields.get(Constants.BASE_PATH_HEADER).get(0);
//        }
//
//        if (httpResponse.headerFields.containsKey(Constants.TEST_SCRIPT_HEADER)) {
//            currentTest = httpResponse.headerFields.get(Constants.TEST_SCRIPT_HEADER).get(0);
//            if (controlChannel != null) {
//                controlChannel.teardown();
//            }
//            controlChannel = new ControlChannel(this);
//
//            List<TestCommand> testCommands = Arrays.asList(gson.fromJson(httpResponse.response, TestCommand[].class));
//            try {
//                execTestCommandsI(testCommands);
//            } catch (InterruptedException e) {
//                Utils.debug("InterruptedException thrown %s", e.getMessage());
//            }
//        }
//    }
//
//    private void execTestCommandsI(List<TestCommand> testCommands) throws InterruptedException {
//        Utils.debug("testCommands: %s", testCommands);
//
//        for (TestCommand testCommand : testCommands) {
//            if (Thread.interrupted()) {
//                Utils.debug("Thread interrupted");
//                return;
//            }
//            Utils.debug("ClassName: %s", testCommand.className);
//            Utils.debug("FunctionName: %s", testCommand.functionName);
//            Utils.debug("Params:");
//            if (testCommand.params != null && testCommand.params.size() > 0) {
//                for (Map.Entry<String, List<String>> entry : testCommand.params.entrySet()) {
//                    Utils.debug("\t%s: %s", entry.getKey(), entry.getValue());
//                }
//            }
//            long timeBefore = System.nanoTime();
//            Utils.debug("time before %s %s: %d", testCommand.className, testCommand.functionName, timeBefore);
//
//            if (Constants.TEST_LIBRARY_CLASSNAME.equals(testCommand.className)) {
//                executeTestLibraryCommandI(testCommand);
//                long timeAfter = System.nanoTime();
//                long timeElapsedMillis = TimeUnit.NANOSECONDS.toMillis(timeAfter - timeBefore);
//                Utils.debug("time after %s %s: %d", testCommand.className, testCommand.functionName, timeAfter);
//                Utils.debug("time elapsed %s %s in milli seconds: %d", testCommand.className, testCommand.functionName, timeElapsedMillis);
//
//                continue;
//            }
//            if (commandListener != null) {
//                commandListener.executeCommand(testCommand.className, testCommand.functionName, testCommand.params);
//            } else if (commandJsonListener != null) {
//                commandJsonListener.executeCommand(testCommand.className, testCommand.functionName, gson.toJson(testCommand.params));
//            } else if (commandRawJsonListener != null) {
//                commandRawJsonListener.executeCommand(gson.toJson(testCommand));
//            }
//            long timeAfter = System.nanoTime();
//            long timeElapsedMillis = TimeUnit.NANOSECONDS.toMillis(timeAfter - timeBefore);
//            Utils.debug("time after %s.%s: %d", testCommand.className, testCommand.functionName, timeAfter);
//            Utils.debug("time elapsed %s.%s in milli seconds: %d", testCommand.className, testCommand.functionName, timeElapsedMillis);
//        }
//    }
//
//    private void executeTestLibraryCommandI(TestCommand testCommand) throws InterruptedException {
//        switch (testCommand.functionName) {
//            case "end_test": endTestI(); break;
//            case "wait": waitI(testCommand.params); break;
//            case "exit": exit(); break;
//        }
//    }
//
//    private void endTestI() {
//        UtilsNetworking.HttpResponse httpResponse = Utils.sendPostI(Utils.appendBasePath(currentBasePath, "/end_test"));
//        this.currentTest = null;
//        if (httpResponse == null) {
//            return;
//        }
//
//        readHeadersI(httpResponse);
//        exit();
//    }
//
//    private void waitI(Map<String, List<String>> params) throws InterruptedException {
//        if (params.containsKey(Constants.WAIT_FOR_CONTROL)) {
//            String waitExpectedReason = params.get(Constants.WAIT_FOR_CONTROL).get(0);
//            Utils.debug("wait for %s", waitExpectedReason);
//            String endReason = waitControlQueue.take();
//            Utils.debug("wait ended due to %s", endReason);
//        }
//        if (params.containsKey(Constants.WAIT_FOR_SLEEP)) {
//            long millisToSleep = Long.parseLong(params.get(Constants.WAIT_FOR_SLEEP).get(0));
//            Utils.debug("sleep for %s", millisToSleep);
//
//            SystemClock.sleep(millisToSleep);
//            Utils.debug("sleep ended");
//        }
//    }
//
//    private void exit() {
//        System.exit(0);
//    }
}
