package com.example.taskbarv2;

import android.app.Activity;
import android.content.Intent;
import android.graphics.RenderEffect;
import android.graphics.Shader;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        View blurContainer = findViewById(R.id.blur_container);
        // Apply frosted-glass blur on API 31+, translucent fallback otherwise
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            blurContainer.setRenderEffect(RenderEffect.createBlurEffect(20f, 20f, Shader.TileMode.CLAMP));
        } else {
            blurContainer.setBackgroundColor(0x88FFFFFF); // translucent white fallback
        }

        ImageButton btnMinimize = findViewById(R.id.btn_minimize);
        btnMinimize.setOnClickListener(v -> {
            // Move app to background instead of finishing
            moveTaskToBack(true);

            // Start keep-alive foreground service (default timeout 5 minutes)
            Intent svc = new Intent(this, KeepAliveService.class);
            svc.putExtra(KeepAliveService.EXTRA_TIMEOUT_MS, 5 * 60 * 1000L);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(svc);
            } else {
                startService(svc);
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Stop the keep-alive service when the app returns to foreground
        Intent svc = new Intent(this, KeepAliveService.class);
        stopService(svc);
    }
}
