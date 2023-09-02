package com.example.flutter_application_2

import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory;

class MainActivity: FlutterActivity() {
}

@Override
public void onCreate() {
    super.onCreate();
    MapKitFactory.setApiKey("");
}