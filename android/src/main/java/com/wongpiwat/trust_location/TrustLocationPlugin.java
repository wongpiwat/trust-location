package com.wongpiwat.trust_location;

import android.content.Context;
import android.content.DialogInterface;
import android.location.Location;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TrustLocationPlugin
 */
public class TrustLocationPlugin extends FlutterActivity implements MethodCallHandler {
    LocationAssistantListener locationAssistantListener;
    private Context context;
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "trust_location");
        channel.setMethodCallHandler(new TrustLocationPlugin(registrar.context()));
    }

    private TrustLocationPlugin(Context context) {
        this.context = context;
        locationAssistantListener = new LocationAssistantListener(context);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        if (call.method.equals("isMockLocation")) {
            if (locationAssistantListener.isMockLocationsDetected()) {
                result.success(true);
            } else if (locationAssistantListener.getLatitude() != null && locationAssistantListener.getLongitude() != null) {
                result.success(false);
            } else {
                locationAssistantListener = new LocationAssistantListener(context);
                result.error("UNAVAILABLE", "Error", null);
            }
        } else if (call.method.equals("getLocation")) {
            if (locationAssistantListener.isMockLocationsDetected()) {
                result.success("Mock Location");
            } else if (locationAssistantListener.getLatitude() != null && locationAssistantListener.getLongitude() != null) {
                result.success("Latitude: " + locationAssistantListener.getLatitude() + ", Longitude: " + locationAssistantListener.getLongitude());
            } else {
                locationAssistantListener = new LocationAssistantListener(context);
                result.error("UNAVAILABLE", "Error", null);
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        locationAssistantListener.getAssistant().start();
    }

    @Override
    protected void onPause() {
        locationAssistantListener.getAssistant().stop();
        super.onPause();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (locationAssistantListener.getAssistant().onPermissionsUpdated(requestCode, grantResults)) {
            io.flutter.Log.i("i", "requestCode: " + requestCode);
        }
    }
}

class LocationAssistantListener implements LocationAssistant.Listener {
    private LocationAssistant assistant;

    private String latitude;
    private String longitude;


    private boolean isMockLocationsDetected = false;

    public LocationAssistantListener(Context context) {
        assistant = new LocationAssistant(context, this, LocationAssistant.Accuracy.HIGH, 5000, false);
        assistant.setVerbose(true);
        assistant.start();
    }

    @Override
    public void onNeedLocationPermission() {
        assistant.requestLocationPermission();
        assistant.requestAndPossiblyExplainLocationPermission();
    }

    @Override
    public void onExplainLocationPermission() {
        io.flutter.Log.i("i", "onExplainLocationPermission: ");
    }

    @Override
    public void onLocationPermissionPermanentlyDeclined(View.OnClickListener fromView, DialogInterface.OnClickListener fromDialog) {
        io.flutter.Log.i("i", "onLocationPermissionPermanentlyDeclined: ");
    }

    @Override
    public void onNeedLocationSettingsChange() {
        io.flutter.Log.i("i", "onNeedLocationSettingsChange: ");
    }

    @Override
    public void onFallBackToSystemSettings(View.OnClickListener fromView, DialogInterface.OnClickListener fromDialog) {
        io.flutter.Log.i("i", "onFallBackToSystemSettings: ");
    }

    @Override
    public void onNewLocationAvailable(Location location) {
        Log.i("LO", "location " + location);
        if (location == null) return;
        latitude = location.getLatitude() + "";
        longitude = location.getLongitude() + "";
        isMockLocationsDetected = false;
    }

    @Override
    public void onMockLocationsDetected(View.OnClickListener fromView, DialogInterface.OnClickListener fromDialog) {
        io.flutter.Log.i("i", "MockLocation");
        isMockLocationsDetected = true;
    }

    @Override
    public void onError(LocationAssistant.ErrorType type, String message) {
        io.flutter.Log.i("i", "Error: " + message);
    }

    public String getLatitude() {
        return latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public boolean isMockLocationsDetected() {
        return isMockLocationsDetected;
    }

    public LocationAssistant getAssistant() {
        return assistant;
    }
}