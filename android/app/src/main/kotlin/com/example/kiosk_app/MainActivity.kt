package com.example.kiosk_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity

import android.app.PendingIntent
import android.content.Intent
import android.hardware.usb.UsbManager
import android.os.Build
import android.util.Log


class MainActivity: FlutterActivity() {



    override fun onResume() {
        super.onResume()
        
        val usbManager = getSystemService(UsbManager::class.java) ?: return
        val permissionIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getBroadcast(this, 0, Intent("com.flutter_pos_printer.USB_PERMISSION"), PendingIntent.FLAG_MUTABLE)
        } else {
            PendingIntent.getBroadcast(this, 0, Intent("com.flutter_pos_printer.USB_PERMISSION"), 0)
        }

        for (device in usbManager.deviceList.values) {
               Log.d("MainActivity", "Requesting permission for: ${device}")
               val vendorId = device.vendorId
            //if (!usbManager.hasPermission(device)) {
                if(vendorId == 1305){
                    usbManager.requestPermission(device, permissionIntent)
                }
           // }
        }
    }

    
}