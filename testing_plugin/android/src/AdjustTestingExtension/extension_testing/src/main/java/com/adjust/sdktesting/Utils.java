package com.adjust.sdktesting;

import android.util.Log;

import java.io.IOException;
import java.util.Arrays;
import java.util.Locale;

import javax.net.ssl.HttpsURLConnection;

/**
 * Created by nonelse on 11.03.17.
 */

public class Utils {
    private static final String TAG = "Utils";


    public static UtilsNetworking.HttpResponse sendPostI(String path) {
        return sendPostI(path, null);
    }
    public static UtilsNetworking.HttpResponse sendPostI(String path, String clientSdk) {
        Log.d(TAG, "sendPostI() called with: path = [" + path + "], clientSdk = [" + clientSdk + "]");
        String targetURL = TestLibrary.baseUrl + path;

        try {
            if (clientSdk != null) {
                UtilsNetworking.connectionOptions.clientSdk = clientSdk;
            }
            HttpsURLConnection connection = UtilsNetworking.createPOSTHttpsURLConnection(
                    targetURL, null, UtilsNetworking.connectionOptions);
            Log.d(TAG, "sendPostI: Awaiting response... [" + targetURL + "]");
            UtilsNetworking.HttpResponse httpResponse = UtilsNetworking.readHttpResponse(connection);
            debug("Response: %s", httpResponse.response);

            httpResponse.headerFields= connection.getHeaderFields();
            debug("Headers: %s", httpResponse.headerFields);

            return httpResponse;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void debug(String message, Object... parameters) {
        try {
            Log.d(Constants.LOGTAG, String.format(Locale.US, message, parameters));
        } catch (Exception e) {
            Log.e(Constants.LOGTAG, String.format(Locale.US, "Error formating log message: %s, with params: %s"
                    , message, Arrays.toString(parameters)));
        }
    }

    public static void error(String message, Object... parameters) {
        try {
            Log.d(Constants.LOGTAG, String.format(Locale.US, message, parameters));
        } catch (Exception e) {
            Log.e(Constants.LOGTAG, String.format(Locale.US, "Error formating log message: %s, with params: %s"
                    , message, Arrays.toString(parameters)));
        }
    }

    public static String appendBasePath(String basePath, String path) {
        if (basePath == null) {
            return path;
        }
        return basePath + path;
    }
}
