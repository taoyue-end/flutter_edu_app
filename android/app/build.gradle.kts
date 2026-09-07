import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // 注意：你的工程是 Flutter 新模板（AGP 9.0.1 + Kotlin 2.3.20），
    // Kotlin Android 插件由 flutter-gradle-plugin 自动应用，
    // 因此不能照抄教程 2.3 的 id("kotlin-android")（会重复应用导致报错）。
    id("dev.flutter.flutter-gradle-plugin")
}

// ---------- 签名信息：只从 key.properties 读取（本地）或 CI 动态生成 ----------
// 该文件已被 .gitignore 忽略，绝不允许提交到仓库。
fun loadSigningProperties(): Properties {
    val props = Properties()
    val keyProps = rootProject.file("key.properties")
    if (keyProps.exists()) {
        props.load(FileInputStream(keyProps))
    }
    return props
}
val signingProps = loadSigningProperties()

android {
    namespace = "com.taoyue.edu"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // 正式包名（全网唯一，上架后不可改）
        applicationId = "com.taoyue.edu"
        minSdk = flutter.minSdkVersion
        // 教程 2.3 在此显式写 targetSdk = 34；
        // 你的 Flutter 模板默认值（flutter.targetSdkVersion）已 ≥ 34，满足第 7 章上架要求，
        // 故保留默认，避免把新模板更高的 targetSdk 人为改低。
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ---------- 多环境 flavor：dev / staging / prod ----------
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            // 包名后缀是环境隔离的根：三套包可以同时装在一台手机上
            applicationIdSuffix = ".dev"
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
        }
        create("prod") {
            dimension = "env"
            // 无后缀 = 正式包名 com.taoyue.edu
        }
    }

    signingConfigs {
        create("release") {
            val storeFileProp = signingProps.getProperty("storeFile")
            if (storeFileProp != null) {
                storeFile = file(storeFileProp)
                storePassword = signingProps.getProperty("storePassword")
                keyAlias = signingProps.getProperty("keyAlias")
                keyPassword = signingProps.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // 有 key.properties（本地）或 CI 注入时才启用正式签名；
            // 没有签名配置时 release 构建会失败——这是故意的，防止产出未签名包。
            signingConfig = signingConfigs.findByName("release")
        }
    }
}

// jvmTarget：Kotlin 2.3.20 用新 DSL compilerOptions（教程 2.3 的 kotlinOptions 是旧 DSL，新模板里不可用）
kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
