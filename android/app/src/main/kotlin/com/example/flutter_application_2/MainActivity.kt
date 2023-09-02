package com.example.flutter_application_2

import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory;

class MainActivity: FlutterActivity() {   
    @Override
    public void onCreate() {
        MapKitFactory.setApiKey("1d464ce6-e63e-414c-b06d-a4d9a739ae14");    
        super.onCreate();
    }
}

