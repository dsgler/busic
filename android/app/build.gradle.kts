plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.busic"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.1.12297006"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.busic"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

//   splits {

//     // 基于不同的abi架构配置不同的apk
//     abi {

//       // 必须为true，打包才会为不同的abi生成不同的apk
//       isEnable = true
     
//       // 默认情况下，包含了所有的ABI。
//       // 所以使用reset()清空所有的ABI，再使用include指定我们想要生成的架构armeabi-v7a、arm-v8a
//       reset()

//       // 逗号分隔列表的形式指定 Gradle 应针对哪些 ABI 生成 APK。只与 reset() 结合使用，以指定确切的 ABI 列表。
//       // include "armeabi-v7a", "arm64-v8a"
//       include("arm64-v8a")

//       // 是否生成通用的apk，也就是包含所有ABI的apk。如果设为 true，那么除了按 ABI 生成的 APK 之外，
//     }
//   }
}

flutter {
    source = "../.."
}
