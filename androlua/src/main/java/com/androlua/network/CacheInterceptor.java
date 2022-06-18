package com.androlua.network;

import org.jetbrains.annotations.NotNull;
import java.io.IOException;
import okhttp3.CacheControl;
import okhttp3.Interceptor;
import okhttp3.Response;

public class CacheInterceptor implements Interceptor {
    @Override
    public Response intercept(@NotNull Chain chain) throws IOException {
        return chain.proceed(chain.request()).newBuilder()
                .removeHeader("Cache-Control") // Remove site cache
                .removeHeader("Pragma") // Remove site cache
                .addHeader("Cache-Control", CacheControl.FORCE_CACHE.toString())
                .build();
    }
}
