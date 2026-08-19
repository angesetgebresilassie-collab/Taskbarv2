#!/usr/bin/env bash
set -euo pipefail

# Usage:
# 1) git clone git@github.com:angesetgebresilassie-collab/Taskbarv2.git
# 2) cd Taskbarv2
# 3) Save this script as apply_patch.sh
# 4) chmod +x apply_patch.sh
# 5) ./apply_patch.sh
#
# The script creates branch feature/macos-theme-frosted-minimize, writes files, commits, and pushes.

BRANCH="feature/macos-theme-frosted-minimize"
echo "Creating and switching to branch: $BRANCH"
git checkout -b "$BRANCH"

echo "Writing files…"

cat > settings.gradle <<'EOF'
include ':app'
EOF

cat > build.gradle <<'EOF'
// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:8.1.0"
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

mkdir -p app
cat > app/build.gradle <<'EOF'
plugins {
    id 'com.android.application'
}

android {
    compileSdk 34

    defaultConfig {
        applicationId "com.example.taskbarv2"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "0.1"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    namespace 'com.example.taskbarv2'
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.core:core-ktx:1.9.0'
    // BlurView fallback for pre-API 31
    implementation 'com.eightbitlab:blurview:1.6.6'
}
EOF

mkdir -p app/src/main
cat > app/src/main/AndroidManifest.xml <<'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.taskbarv2">

    <application
        android:allowBackup="true"
        android:label="Taskbarv2"
        android:icon="@mipmap/ic_launcher">
        <activity android:name="com.example.taskbarv2.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
EOF

mkdir -p app/src/main/java/com/example/taskbarv2
cat > app/src/main/java/com/example/taskbarv2/MainActivity.java <<'EOF'
package com.example.taskbarv2;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView tv = new TextView(this);
        tv.setText("Taskbarv2 - initial skeleton. Integration in progress.");
        tv.setPadding(40,40,40,40);
        setContentView(tv);
    }
}
EOF

cat > README.md <<'EOF'
# Taskbarv2

This repository will receive a copy of farmerbb/Taskbar and subsequent enhancements:

Planned work (branch: feature/macos-theme-frosted-minimize)
- Import farmerbb/Taskbar project sources as the base.
- Implement macOS Monterey-style freeform window chrome (rounded title bar + traffic-light controls).
- Add app-wide frosted-glass blur using RenderEffect (API 31+) with BlurView fallback for older devices (minSdk 21).
- Change minimize behavior to move task to background (not finish), start a KeepAlive foreground service while minimized, and provide an adjustable timeout in Settings.
- Request "Ignore battery optimizations" permission flow (user prompt) to improve background persistence.
- Polish UI across the app: spacing, icons, typography, color tokens.
- Add CI (GitHub Actions) that builds APK artifacts for testing.

Current status
- Initial project skeleton committed and branch created. Next: import Taskbar sources, implement UI and services, push incremental commits, and attach test APKs via CI.

If you want to test early builds, tell me and I'll enable APK artifact uploads in the workflow (default: enabled).
EOF

mkdir -p .github/workflows
cat > .github/workflows/android.yml <<'EOF'
name: Android CI

on:
  push:
    branches:
      - feature/macos-theme-frosted-minimize
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Set up JDK 17
      uses: actions/setup-java@v4
      with:
        distribution: temurin
        java-version: 17

    - name: Build Debug APK
      run: |
        ./gradlew assembleDebug

    - name: Upload APK
      uses: actions/upload-artifact@v4
      with:
        name: app-debug-apk
        path: app/build/outputs/apk/debug/app-debug.apk
EOF

echo "Staging files…"
git add -A

echo "Committing…"
git commit -m "chore: add project skeleton, initial Android module, and CI workflow for feature/macos-theme-frosted-minimize"

echo "Pushing branch to origin…"
git push -u origin "$BRANCH"

echo "Done. Branch '$BRANCH' pushed. I will continue with implementation after you tell me the branch is present."
EOF

How to run the script
1) Clone your repo locally if you haven’t already:
   - git clone git@github.com:angesetgebresilassie-collab/Taskbarv2.git
   - cd Taskbarv2
2) Save the provided apply_patch.sh (copy/paste the script text above into a file).
3) chmod +x apply_patch.sh
4) ./apply_patch.sh
5) After it finishes, go to GitHub → your repo → Branches and confirm feature/macos-theme-frosted-minimize exists.
6) Tell me “Branch pushed” and I’ll continue implementing the feature (I’ll provide the next patch/commits or PR instructions as needed).

Option 2 — If you want a patch file (git unified diff)
- Save the following content to taskbarv2_changes.patch and apply with git apply or review manually. Note: for easiest and safest result, use the script above.

```diff name=taskbarv2_changes.patch
*** Begin Patch
*** Add File: settings.gradle
+include ':app'
+
*** End Patch
*** Begin Patch
*** Add File: build.gradle
+// Top-level build file where you can add configuration options common to all sub-projects/modules.
+buildscript {
+    repositories {
+        google()
+        mavenCentral()
+    }
+    dependencies {
+        classpath "com.android.tools.build:gradle:8.1.0"
+    }
+}
+allprojects {
+    repositories {
+        google()
+        mavenCentral()
+    }
+}
+
*** End Patch
*** Begin Patch
*** Add File: app/build.gradle
+plugins {
+    id 'com.android.application'
+}
+
+android {
+    compileSdk 34
+
+    defaultConfig {
+        applicationId "com.example.taskbarv2"
+        minSdk 21
+        targetSdk 34
+        versionCode 1
+        versionName "0.1"
+    }
+
+    buildTypes {
+        release {
+            minifyEnabled false
+            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
+        }
+    }
+
+    namespace 'com.example.taskbarv2'
+}
+
+dependencies {
+    implementation 'androidx.appcompat:appcompat:1.6.1'
+    implementation 'androidx.core:core-ktx:1.9.0'
+    // BlurView fallback for pre-API 31
+    implementation 'com.eightbitlab:blurview:1.6.6'
+}
+
*** End Patch
*** Begin Patch
*** Add File: app/src/main/AndroidManifest.xml
+<manifest xmlns:android="http://schemas.android.com/apk/res/android"
+    package="com.example.taskbarv2">
+
+    <application
+        android:allowBackup="true"
+        android:label="Taskbarv2"
+        android:icon="@mipmap/ic_launcher">
+        <activity android:name="com.example.taskbarv2.MainActivity"
+            android:exported="true">
+            <intent-filter>
+                <action android:name="android.intent.action.MAIN" />
+                <category android:name="android.intent.category.LAUNCHER" />
+            </intent-filter>
+        </activity>
+    </application>
+
+</manifest>
+
*** End Patch
*** Begin Patch
*** Add File: app/src/main/java/com/example/taskbarv2/MainActivity.java
+package com.example.taskbarv2;
+
+import android.app.Activity;
+import android.os.Bundle;
+import android.widget.TextView;
+
+public class MainActivity extends Activity {
+    @Override
+    protected void onCreate(Bundle savedInstanceState) {
+        super.onCreate(savedInstanceState);
+        TextView tv = new TextView(this);
+        tv.setText("Taskbarv2 - initial skeleton. Integration in progress.");
+        tv.setPadding(40,40,40,40);
+        setContentView(tv);
+    }
+}
+
*** End Patch
*** Begin Patch
*** Add File: README.md
+# Taskbarv2
+
+This repository will receive a copy of farmerbb/Taskbar and subsequent enhancements:
+
+Planned work (branch: feature/macos-theme-frosted-minimize)
+- Import farmerbb/Taskbar project sources as the base.
+- Implement macOS Monterey-style freeform window chrome (rounded title bar + traffic-light controls).
+- Add app-wide frosted-glass blur using RenderEffect (API 31+) with BlurView fallback for older devices (minSdk 21).
+- Change minimize behavior to move task to background (not finish), start a KeepAlive foreground service while minimized, and provide an adjustable timeout in Settings.
+- Request "Ignore battery optimizations" permission flow (user prompt) to improve background persistence.
+- Polish UI across the app: spacing, icons, typography, color tokens.
+- Add CI (GitHub Actions) that builds APK artifacts for testing.
+
+Current status
+- Initial project skeleton committed and branch created. Next: import Taskbar sources, implement UI and services, push incremental commits, and attach test APKs via CI.
+
+If you want to test early builds, tell me and I'll enable APK artifact uploads in the workflow (default: enabled).
+
*** End Patch
*** Begin Patch
*** Add File: .github/workflows/android.yml
+name: Android CI
+
+on:
+  push:
+    branches:
+      - feature/macos-theme-frosted-minimize
+  workflow_dispatch:
+
+jobs:
+  build:
+    runs-on: ubuntu-latest
+
+    steps:
+    - name: Checkout
+      uses: actions/checkout@v4
+
+    - name: Set up JDK 17
+      uses: actions/setup-java@v4
+      with:
+        distribution: temurin
+        java-version: 17
+
+    - name: Build Debug APK
+      run: |
+        ./gradlew assembleDebug
+
+    - name: Upload APK
+      uses: actions/upload-artifact@v4
+      with:
+        name: app-debug-apk
+        path: app/build/outputs/apk/debug/app-debug.apk
+
*** End Patch