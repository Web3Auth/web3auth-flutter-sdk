# Keep Kotlin metadata
-keepclassmembers class ** {
    @kotlin.Metadata *;
}

# Keep public classes and members of your SDK
-keep class com.web3auth.** { *; }

# If using Gson (for JSON parsing)
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep method names and constructor params
-keepattributes Signature, InnerClasses, EnclosingMethod, *Annotation*, SourceFile, LineNumberTable

# If you use coroutines or lambdas
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# To avoid stripping methods like getError(), setCustomTabsClosed(), etc.
-keepclassmembers class ** {
    *** getError(...);
    void setCustomTabsClosed(...);
}

# Preserve Kotlin metadata and parameter names
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod
-keep class kotlin.Metadata { *; }
-keepclassmembers class ** {
    @kotlin.Metadata *;
}

# Optional: Keep your SDK class and its methods fully
-keep class com.web3auth.flutter.web3auth_flutter.Web3AuthFlutterPlugin {
    *;
}

-keepclassmembers class com.web3auth.core.Web3Auth {
    public static <methods>;
}

# Preserve the entire Kotlin object class (prevents it from being removed/renamed)
-keep class com.web3auth.core.types.Web3AuthError {
    *;
}
