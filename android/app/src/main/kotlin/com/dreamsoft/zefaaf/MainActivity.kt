package com.dreamsoft.zefaaf

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Bundle


class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val soundUri: Uri = Uri.parse(
                    "android.resource://" +
                            applicationContext.packageName +
                            "/" +
                            R.raw.sound)

            val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .build()

            val channel = NotificationChannel("noti_push_app_1",
                    "noti_push_app",
                    NotificationManager.IMPORTANCE_HIGH)
            channel.setSound(soundUri, audioAttributes)

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)

        }

        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}