# Ignore warnings for missing Play Core classes (if not using Play Core)
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Keep essential Flutter classes
-keep class io.flutter.** { *; }
-keepclassmembers class * {
    @io.flutter.embedding.engine.deferredcomponents.DeferredComponentManager <methods>;
}

# Preserve Play Core classes if they are used
-keep class com.google.android.play.core.** { *; }

# Preserve JSON parsing libraries (if using Gson or similar)
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keep class org.json.** { *; }

# Preserve Retrofit or HTTP client (if using it for networking)
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Avoid stripping logs during debugging
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# Preserve classes related to HttpClient
-keep class org.apache.http.** { *; }
-keep class java.net.** { *; }
-keep class javax.net.** { *; }

# Preserve BillDesk SDK classes
-keep class com.billDeskSDK.** { *; }
-keepclassmembers class com.billDeskSDK.** { *; }

# Preserve SSL and certificate handling
-keep class javax.net.ssl.** { *; }
-keep class javax.security.cert.** { *; }

# Preserve callback classes and interfaces
-keepclassmembers class * implements com.billDeskSDK.ResponseHandler {
    *;
}

# Preserve GetX library
-keep class **.get.** { *; }
-keepclassmembers class **.get.** { *; }

# Preserve file and storage-related classes
-keep class java.io.** { *; }

# Preserve methods and fields for dynamic features (if using deferred components)
-keepclassmembers class * {
    @com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener <methods>;
}
