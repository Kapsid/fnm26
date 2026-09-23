import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing, read from android/key.properties -- which is git-ignored,
// because it names a keystore and holds its passwords.
//
// See key.properties.example for the four values, and the note on
// `bundleRelease` below for what happens when the file is absent.
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKey = keystorePropertiesFile.exists()
val keystoreProperties = Properties().apply {
    if (hasReleaseKey) keystorePropertiesFile.inputStream().use { load(it) }
}

android {
    namespace = "com.fnm.fnm"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.fnm.fnm"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // The real key when there is one. Without it this falls back to the
            // debug key so a local `flutter build apk --release` still works for
            // sideloading onto a test phone -- but see the guard below: the
            // artefact you actually UPLOAD can never be signed that way.
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

// The one build that must never be debug-signed.
//
// `bundleRelease` produces the .aab uploaded to Play, and Play rejects a
// debug-signed one outright -- but only after you have built it, waited for the
// upload and read the error. This says so at the point the mistake is made.
// Sideloading builds are deliberately left alone, so the day-to-day loop of
// pushing a release APK to a phone still works with no keystore at all.
tasks.matching { it.name == "bundleRelease" }.configureEach {
    doFirst {
        if (!hasReleaseKey) {
            throw GradleException(
                "Cannot build a release bundle: android/key.properties is " +
                    "missing, so this would be signed with the DEBUG key and " +
                    "Play would reject it. Copy key.properties.example, " +
                    "create a keystore, and fill in the four values."
            )
        }
    }
}

flutter {
    source = "../.."
}
