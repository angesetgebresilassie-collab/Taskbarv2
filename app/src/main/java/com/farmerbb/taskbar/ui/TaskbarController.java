/* Copyright 2016 Braden Farmer
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.farmerbb.taskbar.ui;

import android.app.ActivityOptions;
import android.content.Context;
import android.graphics.RenderEffect;
import android.graphics.Shader;
import android.os.Build;
import android.view.View;
import android.widget.ImageButton;

import com.farmerbb.taskbar.R;

/**
 * Lightweight TaskbarController augmentation for macOS-style frosted blur and a minimize affordance.
 * This file intentionally keeps changes small and defensive so it can be adapted into the imported
 * upstream TaskbarController implementation during code review.
 */
public class TaskbarController extends UIController {
    private View rootView;
    private ImageButton minimizeButton;

    public TaskbarController(Context context) {
        super(context);
    }

    @Override
    public void onCreateHost(UIHost host) {
        super.onCreateHost(host);
        // Attempt to attach additional UI behavior after the original taskbar is drawn.
        try {
            // rootView is the top-level taskbar layout added by the existing implementation
            rootView = host.getRootView();
            if(rootView != null) {
                setupFrostedBlur(rootView);
                setupMinimizeButton(rootView);
            }
        } catch (Throwable t) {
            // Fail silently to avoid breaking the upstream behavior
        }
    }

    private void setupFrostedBlur(View v) {
        try {
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                float radius = 20f; // tweakable
                RenderEffect blur = RenderEffect.createBlurEffect(radius, radius, Shader.TileMode.CLAMP);
                v.setRenderEffect(blur);
            } else {
                // For older platforms use a translucent overlay drawable as a graceful fallback
                v.setBackgroundResource(R.drawable.frosted_overlay);
            }
        } catch (Throwable t) {
            // best-effort only
        }
    }

    private void setupMinimizeButton(View root) {
        try {
            minimizeButton = root.findViewById(R.id.tb_minimize);
            if(minimizeButton != null) {
                minimizeButton.setOnClickListener((view) -> {
                    try {
                        // Best-effort minimize: request a basic ActivityOptions transition on the host
                        ActivityOptions opts = ActivityOptions.makeBasic();
                        if(host instanceof UIHostService) {
                            ((UIHostService) host).startMinimizeForegroundApp(opts.toBundle());
                        }
                    } catch (Throwable t) {
                        // fallback: hide taskbar if minimize not supported
                        try { host.hideTaskbar(); } catch (Throwable ignored) {}
                    }
                });
            }
        } catch (Throwable ignored) {}
    }
}
