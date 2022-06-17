-keep public class * implements com.bumptech.glide.module.AppGlideModule

# Okhttp
-dontwarn okio.**
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.ParametersAreNonnullByDefault

-keep class com.google.android.material.** { *; }
-dontwarn com.google.android.material.**

-keep, allowoptimization class okhttp3.** { public protected *; }
-keep class org.** { *; }
-keep class com.androlua.** { *; }
-keep class com.luajava.** { *; }
-keep class id.lxs.animongo.** { *; }

-keep class android.**{*;}
-keep class androidx.**{*;}
-keep class com.**{*;}

-dontwarn okio.**
-keep class okio.**{*;}

