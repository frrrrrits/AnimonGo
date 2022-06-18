package com.androlua.network;

import androidx.annotation.NonNull;

import com.luajava.LuaObject;
import com.luajava.LuaTable;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Dns;
import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class LuaHttp {

    private static LuaHttp instance;
    private final OkHttpClient httpClient;

    private LuaHttp() {
        OkHttpClient.Builder builder = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .addNetworkInterceptor(new CacheInterceptor());

        httpClient = builder.build();
    }

    public static LuaHttp getInstance() {
        if (instance == null) {
            synchronized (LuaHttp.class) {
                if (instance == null) {
                    instance = new LuaHttp();
                }
            }
        }
        return instance;
    }

    public static OkHttpClient getClient() {
        return getInstance().httpClient;
    }

    private static OkHttpClient createOkHttpClient(OkHttpClient httpClient) {
        Dns dns = DohProviders.dohCloudflare(httpClient);
        OkHttpClient.Builder okHttpClientBuilder = httpClient
                .newBuilder();
        return okHttpClientBuilder.dns(dns).build();
    }

    public static void cancelAll() {
        getInstance().httpClient.dispatcher().cancelAll();
    }

    public static void cancelWithTag(String tags) {
        for (Call call : getInstance().httpClient.dispatcher().queuedCalls()) {
            if (Objects.equals(call.request().tag(), tags)) {
                call.cancel();
            }
        }
    }

    public static void request(final LuaTable options, final LuaObject callback) {
        getInstance().httpClient.newCall(buildRequest(options))
                .enqueue(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        try {
                            callback.call(e);
                        } catch (Exception e1) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        try {
                            Object o = options.get("outputFile");
                            if (o != null) {
                                InputStream inputStream = response.body().byteStream();
                                String filePath;
                                if (o instanceof String) {
                                    filePath = (String) o;
                                } else {
                                    filePath = o.toString();
                                }
                                String outputFile = saveToFile(inputStream, filePath);
                                callback.call(null, response.code(), outputFile);
                                return;
                            }
                            callback.call(null, response.code(), response.body().string());
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });
    }

    public static void requestSync(final LuaTable options, final LuaObject callback) {
        try {
            Response response = getInstance().httpClient.newCall(buildRequest(options)).execute();
            Object o = options.get("outputFile");
            if (o != null) {
                InputStream inputStream = response.body().byteStream();
                String filePath;
                if (o instanceof String) {
                    filePath = (String) o;
                } else {
                    filePath = o.toString();
                }
                String outputFile = saveToFile(inputStream, filePath);
                callback.call(null, response.code(), outputFile);
                return;
            }
            callback.call(null, response.code(), response.body().string());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @NonNull
    private static Request buildRequest(LuaTable options) {
        Request.Builder builder = new Request.Builder();
        String url = (String) options.get("url");
        builder.url(url);

        String tag = (String) options.get("tag");
        if (tag != null) {
            builder.tag(options);
        }

        String method = (String) options.get("method");
        if ("GET".equals(method)) {
            builder.get();
        } else if ("POST".equals(method)) {
            RequestBody requestBody = getRequestBody(options);
            if (requestBody != null) {
                builder.post(requestBody);
            }
        } else if ("PUT".equals(method)) {
            RequestBody requestBody = getRequestBody(options);
            if (requestBody != null) {
                builder.put(requestBody);
            }
        } else if ("DELETE".equals(method)) {
            RequestBody requestBody = getRequestBody(options);
            if (requestBody != null) {
                builder.delete(requestBody);
            } else {
                builder.delete();
            }
        } else {
            builder.get();
        }

        LuaTable headers = (LuaTable) options.get("headers");
        if (headers != null) {
            for (Object key : headers.keySet()) {
                String value = (String) headers.get(key);
                int i = value.indexOf(":");
                if (i == -1) {
                    continue;
                }
                String[] header = new String[]{
                        value.substring(0, i),
                        value.substring(i + 1)
                };
                builder.header(header[0].trim(), header[1].trim());
            }
        }
        return builder.build();
    }

    private static RequestBody getRequestBody(LuaTable options) {
        String body = (String) options.get("body");
        if (body != null) {
            return RequestBody.create(MediaType.parse("application/json; charset=utf-8"), body);
        }

        Map formData = (Map) options.get("formData");
        if (formData != null) {
            FormBody.Builder bodyBuilder = new FormBody.Builder();
            for (Object key : formData.keySet()) {
                String value = (String) formData.get(key);
                int i = value.indexOf(":");
                if (i == -1) {
                    continue;
                }
                String[] params = new String[]{
                        value.substring(0, i),
                        value.substring(i + 1)
                };
                bodyBuilder.add(params[0].trim(), params[1].trim());
            }
            return bodyBuilder.build();
        }

        Map multipart = (Map) options.get("multipart");
        if (multipart != null) {
            MultipartBody.Builder bodyBuilder = new MultipartBody.Builder()
                    .setType(MultipartBody.FORM);
            for (Object key : multipart.keySet()) {
                String value = (String) multipart.get(key);
                int i = value.indexOf(":");
                if (i == -1) {
                    continue;
                }
                String[] params = new String[]{
                        value.substring(0, i),
                        value.substring(i + 1)
                };
                String itemKey = params[0].trim();
                String itemValue = params[1].trim();
                if (itemValue.startsWith("/")) {
                    File file = new File(itemValue);
                    if (file.exists()) {
                        bodyBuilder.addFormDataPart(itemKey, file.getName(),
                                RequestBody.create(MediaType.parse("image/png"), file));
                    }
                } else {
                    bodyBuilder.addFormDataPart(itemKey, itemValue);
                }
            }
            return bodyBuilder.build();
        }
        return new FormBody.Builder().build();
    }

    public static boolean downloadFile(String url, String savePath) {
        return downloadFile(url, savePath, null);
    }

    public static boolean downloadFile(String url, String savePath, ArrayList<String> headers) {
        try {
            final File file = new File(savePath);
            if (file.exists()) {
                return true;
            }

            OkHttpClient client = new OkHttpClient.Builder()
                    .connectTimeout(10, TimeUnit.SECONDS)
                    .writeTimeout(10, TimeUnit.SECONDS)
                    .readTimeout(30, TimeUnit.SECONDS)
                    .build();

            Request.Builder builder = new Request.Builder().url(url);
            if (headers != null) {
                for (String header : headers) {
                    int i = header.indexOf(":");
                    if (i <= 0) {
                        continue;
                    }
                    String key = header.substring(0, i);
                    String v = header.substring(i + 1);
                    builder.addHeader(key, v);
                }
            }
            final Request request = builder.build();
            Response response = client.newCall(request).execute();

            InputStream is = null;
            byte[] buf = new byte[2048];
            FileOutputStream fos = null;
            try {
                is = response.body().byteStream();
                fos = new FileOutputStream(file);
                int len = 0;
                while ((len = is.read(buf)) != -1) {
                    fos.write(buf, 0, len);
                }
                fos.flush();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (is != null) {
                        is.close();
                    }
                    if (fos != null) {
                        fos.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String saveToFile(InputStream in, String filePath) {
        try {
            FileOutputStream out = new FileOutputStream(filePath);
            byte[] buffer = new byte[1024];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
            in.close();
            out.flush();
            out.close();
            return filePath;
        } catch (Exception e) {
            e.printStackTrace();
            return filePath;
        }
    }

    public static String saveToFile(String txt, String filePath) {
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            FileWriter fooWriter = new FileWriter(file, false); // true to append // false to overwrite.
            fooWriter.write(txt);
            fooWriter.close();
            return file.getAbsolutePath();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return txt;
    }
}