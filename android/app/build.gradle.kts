import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") // Corrige o id do plugin
    // O plugin do Flutter deve vir depois dos outros
    id("dev.flutter.flutter-gradle-plugin")
}

// 🔹 Carregar o arquivo key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "co.hibeauty"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    packaging {
        resources {
            // 🔹 Exclusões robustas para arquivos macOS
            excludes += "/**/._*"
            excludes += "**/._*"
            excludes += "**/*._*"
            excludes += "._*"
            excludes += "/**/.DS_Store"
            excludes += "**/.DS_Store"
            excludes += ".DS_Store"
            excludes += "**/__MACOSX/**"
            excludes += "__MACOSX/**"
            excludes += "**/.Spotlight-V100"
            excludes += "**/.Trashes"
            excludes += "**/*~"
            excludes += "**/*.tmp"
            excludes += "**/*.bak"
        }
        
        // 🔹 Filtros adicionais para packaged resources
        jniLibs {
            excludes += "/**/._*"
            excludes += "**/._*"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "co.hibeauty"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyAliasValue = keystoreProperties["keyAlias"] as String?
            val keyPasswordValue = keystoreProperties["keyPassword"] as String?
            val storeFileValue = keystoreProperties["storeFile"] as String?
            val storePasswordValue = keystoreProperties["storePassword"] as String?

            if (keyAliasValue != null && keyPasswordValue != null && storeFileValue != null && storePasswordValue != null) {
                keyAlias = keyAliasValue
                keyPassword = keyPasswordValue
                storeFile = file(storeFileValue)
                storePassword = storePasswordValue
            } else {
                println("⚠️  Aviso: key.properties não encontrado ou incompleto, usando configuração padrão.")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}


flutter {
    source = "../.."
}
