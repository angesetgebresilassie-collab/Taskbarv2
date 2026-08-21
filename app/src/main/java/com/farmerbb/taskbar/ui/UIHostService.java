package com.farmerbb.taskbar.ui;

import android.app.Service;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;

/**
 * Minimal UIHostService helpers used by the Stage 4 UI integration.
 * These methods are intentionally lightweight placeholders — the upstream
 * service implementation should provide robust, platform-specific behavior.
 */
public abstract class UIHostService extends Service implements UIHost {
    @Override
    public IBinder onBind(Intent intent) { return null; }

    /**
     * Best-effort request that the host minimize the currently foregrounded app or
     * otherwise perform a minimize-like animation. Returns null in this placeholder.
     */
    public Bundle startMinimizeForegroundApp(Bundle opts) { return null; }

    /**
     * Convenience helper used as a fallback when minimize cannot be performed.
     */
    public void hideTaskbar() {}
}
