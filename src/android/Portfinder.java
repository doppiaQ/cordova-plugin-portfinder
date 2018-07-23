
package com.group4business.cordova.portfinder;

import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.util.TimeZone;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.provider.Settings;

public class Portfinder extends CordovaPlugin {
    public static final String TAG = "Portfinder";

    /**
     * Constructor.
     */
    public Portfinder() {
    }

    /**
     * Sets the context of the Command. This can then be used to do things like
     * get file paths associated with the Activity.
     *
     * @param cordova The context of the main Activity.
     * @param webView The CordovaWebView Cordova is running in.
     */
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action            The action to execute.
     * @param args              JSONArry of arguments for the plugin.
     * @param callbackContext   The callback id used when calling back into JavaScript.
     * @return                  True if the action was valid, false if not.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("getPort".equals(action)) {
            String defPort = args.getString(0);
            int port;
            if (defPort != null && !defPort.equals("undefined")) {
                port = this.getPortWithDefault(Integer.parseInt(defPort));
            }else{
                port = this.getPort();
            }
            this.cdvSendGetPortResult(callbackContext, port);
        }
        else if ("getPortWithHost".equals(action)) {
            String host = args.getString(0);
            String defPort = args.getString(1);
            int port;
            if (defPort != null && !defPort.equals("undefined")) {
                port = this.getPortWithHostAndDefault(host, Integer.parseInt(defPort));
            }else{
                port = this.getPortWithHost(host);
            }
            this.cdvSendGetPortResult(callbackContext, port);
        }
        else{
            return false;
        }
        return true;
    }

    public void cdvSendGetPortResult(CallbackContext callbackContext, int port) {
        if (port < 0) {
            callbackContext.error("Port not found...");
        } else {
            callbackContext.success(Integer.toString(port));
        }
    }

    //--------------------------------------------------------------------------
    // LOCAL METHODS
    //--------------------------------------------------------------------------

    public int getPort() {
        return this.getPortWithHostAndDefault(null, 0);
    }

    public int getPortWithDefault(int port) {
        return this.getPortWithHostAndDefault(null, port);
    }

    public int getPortWithHost(String host) {
        return this.getPortWithHostAndDefault(host, 0);
    }

    public int getPortWithHostAndDefault(String host, int defPort) {
        int port = -1;
        ServerSocket server;
        try {
            InetAddress inetAddr = (host != null)? InetAddress.getByName(host) : null;
            server = new ServerSocket(defPort, 0, inetAddr);
            port = server.getLocalPort();
        } catch (IOException ex1) {
            if (defPort != 0){
                port = this.getPortWithHostAndDefault(host, 0);
            }
        }
        return port;
    }

}
