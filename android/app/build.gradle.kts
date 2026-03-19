// ✅ Signing configuration - supports both local (key.properties) and Codemagic (env vars)
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Load local key.properties if it exists (for local builds)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.cycleguard.safety"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
        }
    }

    defaultConfig {
        applicationId = "com.cycleguard.safety"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            // Codemagic environment variables take priority over key.properties
            keyAlias = System.getenv("CM_KEY_ALIAS") ?: keystoreProperties["keyAlias"] as String?
            keyPassword = System.getenv("CM_KEY_PASSWORD") ?: keystoreProperties["keyPassword"] as String?
            storeFile = (System.getenv("CM_KEYSTORE_PATH") ?: keystoreProperties["storeFile"] as String?)?.let { file(it) }
            storePassword = System.getenv("CM_KEYSTORE_PASSWORD") ?: keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
