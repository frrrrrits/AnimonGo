package com.androlua.source;

import com.luajava.LuaObject;

import android.os.Environment;
import android.content.Context;

import com.androlua.LuaApplication;
import com.androlua.network.LuaHttp;

import java.io.File;

public class SourceManager {
    private static final String APP_DIR = "source";
    
    private static Context getContext() {
        return LuaApplication.getInstance().getContext();
    }
    
    public static void download(final String url,final String id,final String pluginName, final LuaObject callback) {
        new Thread() {
            @Override
            public void run() {
                super.run();
                try {
                    String destDirectory = getAndroLuaDir() + "/" + getSourceDir(id);
                    String savePath = destDirectory + "/" + pluginName;
                    LuaHttp.downloadFile(url, savePath);
                    callback.call(destDirectory);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }.start();
    }
    
    public static boolean sdCardAvaible() {
        return Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState());
    }
    
    public static String getSourceDir(final String id) {
        File destDir = new File(id);
        if (!destDir.exists()) {
            destDir.mkdir();
        }
        return destDir.getAbsolutePath();
    }
    
    public static String getAndroLuaDir() {
        File appDir;
        if (sdCardAvaible()) {
            appDir = getContext().getExternalFilesDir(APP_DIR);
        } else {
            appDir = new File(getContext().getFilesDir(), APP_DIR);
        }
        appDir.mkdirs();
        return appDir.getAbsolutePath();
    }
    
    public static void deleteFileOrDir(File file) {
        if (file == null || !file.exists()) {
            return;
        }
        if (!file.isDirectory()) {
            file.delete();
            return;
        }
        File[] files = file.listFiles();
        if (files == null) {
            return;
        }
        for (File f : files) {
            deleteFileOrDir(f);
        }
        file.delete();
    }
}
