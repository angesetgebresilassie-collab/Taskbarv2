package com.example.taskbarv2;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

public class KeepAliveService extends Service {
    public static final String EXTRA_TIMEOUT_MS = "extra_timeout_ms";
    private static final String CHANNEL_ID = "keepalive_channel";
    private static final int NOTIF_ID = 1001;

    private Handler handler;
    private final Runnable stopSelfRunnable = this::stopSelf;

    @Override
    public void onCreate() {
        super.onCreate();
        handler = new Handler();
        createNotificationChannel();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel chan = new NotificationChannel(CHANNEL_ID, "KeepAlive", NotificationManager.IMPORTANCE_LOW);
            NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            if (nm != null) nm.createNotificationChannel(chan);
        }
    }

    private Notification buildNotification() {
        return new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Taskbarv2 — running in background")
                .setContentText("Keeping the app alive while minimized")
                .setSmallIcon(android.R.drawable.ic_menu_recent_history)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setOngoing(true)
                .build();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        long timeout = 5 * 60 * 1000L; // default 5 minutes
        if (intent != null && intent.hasExtra(EXTRA_TIMEOUT_MS)) {
            timeout = intent.getLongExtra(EXTRA_TIMEOUT_MS, timeout);
        }

        startForeground(NOTIF_ID, buildNotification());

        // Schedule self-stop after timeout to avoid indefinite background run
        handler.removeCallbacks(stopSelfRunnable);
        handler.postDelayed(stopSelfRunnable, timeout);

        // If the system kills the service, do not recreate (we'll restart explicitly)
        return START_NOT_STICKY;
    }

    @Override
    public void onDestroy() {
        if (handler != null) handler.removeCallbacks(stopSelfRunnable);
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
