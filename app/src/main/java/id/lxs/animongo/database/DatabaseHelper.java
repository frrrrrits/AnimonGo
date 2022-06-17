package id.lxs.animongo.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

public class DatabaseHelper extends SQLiteOpenHelper {

    private static final String DATABASE_NAME = "id_animongo";
    private static final int VERSION_NUMBER = 2;

    private static final String TABLE_NAME = "animes";
    private static final String TABLE_EPISODE = "episode";

    public static final String COL_ID = "_id";
    public static final String COL_URL = "url";
    public static final String COL_NAME = "name";
    public static final String COL_SOURCE = "source";
    public static final String COL_THUMBNAIL = "thumbnail";
    public static final String COL_LATESTEPS = "latesteps";
    public static final String COL_EPSTOTAL = "epstotal";

    public static final String COL_EPISODE_URL = "episode_url";
    public static final String COL_EPISODE_NAME = "episode_name";

    private static final String CREATE_TABLE = "CREATE TABLE " + TABLE_NAME
            + " (" + COL_ID + " INTEGER NOT NULL PRIMARY KEY,"
            + COL_URL + " TEXT NOT NULL,"
            + COL_NAME + " TEXT NOT NULL,"
            + COL_SOURCE + " INTEGER NOT NULL,"
            + COL_THUMBNAIL + " TEXT NOT NULL,"
            + COL_LATESTEPS + " INTEGER NOT NULL,"
            + COL_EPSTOTAL + " INTEGER NOT NULL" + ")";

    private static final String CREATE_TABLE_EPISODE = "CREATE TABLE " + TABLE_EPISODE
            + " (" + COL_ID + " INTEGER NOT NULL PRIMARY KEY,"
            + COL_EPISODE_URL + " TEXT NOT NULL,"
            + COL_EPISODE_NAME + " TEXT NOT NULL)";

    private static final String DROP_TABLE = "DROP TABLE IF EXISTS " + TABLE_NAME;

    private static final String DROP_TABLE_EPISODE = "DROP TABLE IF EXISTS " + TABLE_EPISODE;

    private static DatabaseHelper instance;

    private boolean firstCreate;
    private DatabaseListener mListener;

    public DatabaseHelper(Context context, DatabaseListener listener) {
        super(context, DATABASE_NAME, (SQLiteDatabase.CursorFactory) null, VERSION_NUMBER);
        instance = this;
        this.mListener = listener;
    }

    public static DatabaseHelper getInstance() {
        return instance;
    }

    public interface DatabaseListener {
        void onDatabaseChanged();
    }

    public boolean isFirstCreate() {
        return this.firstCreate;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CREATE_TABLE);
        db.execSQL(CREATE_TABLE_EPISODE);
        this.firstCreate = true;
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL(DROP_TABLE);
        db.execSQL(DROP_TABLE_EPISODE);
        onCreate(db);
    }

    public boolean isFavorite(String name) {
        boolean ret = true;
        String[] args = {name};
        try {
            Cursor cursor = getReadableDatabase().query(TABLE_NAME, (String[]) null, COL_NAME + "=?", args, (String) null, (String) null, (String) null, (String) null);
            if (cursor == null) {
                return false;
            }
            if (cursor.getCount() <= 0) {
                ret = false;
            }
            cursor.close();
            return ret;
        } catch (SQLiteException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEpisode(String url) {
        boolean ret = true;
        String[] args = {url};
        try {
            Cursor cursor = getReadableDatabase().query(TABLE_EPISODE, (String[]) null, COL_EPISODE_URL + "=?", args, (String) null, (String) null, (String) null, (String) null);
            if (cursor == null) {
                return false;
            }
            if (cursor.getCount() <= 0) {
                ret = false;
            }
            cursor.close();
            return ret;
        } catch (SQLiteException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Cursor queryFavorite() {
        return getReadableDatabase().query(TABLE_NAME, (String[]) null, (String) null, (String[]) null, (String) null, (String) null, (String) null);
    }

    public Cursor queryEpisode() {
        return getReadableDatabase().query(TABLE_EPISODE, (String[]) null, (String) null, (String[]) null, (String) null, (String) null, (String) null);
    }

    public long insertFavorite(String url, String name, String source, String thumbnail, String latesteps, String epstotal) {
        if (isFavorite(name)) {
            return -1;
        }
        try {
            long insert = getWritableDatabase().insert(TABLE_NAME, (String) null, valuesFavorite(url, name, source, thumbnail, latesteps, epstotal));
            if (mListener != null) {
                this.mListener.onDatabaseChanged();
            }
            return insert;
        } catch (SQLiteException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public long insertEpisode(String url, String name) {
        if (isEpisode(url)) {
            return -1;
        }
        try {
            long insert = getWritableDatabase().insert(TABLE_EPISODE, (String) null, valuesEpisode(url, name));
            if (mListener != null) {
                this.mListener.onDatabaseChanged();
            }
            return insert;
        } catch (SQLiteException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public void deleteFavorite(String url) {
        String[] args = {url};
        getWritableDatabase().delete(TABLE_NAME, COL_NAME + "=?", args);
        if (mListener != null) {
            this.mListener.onDatabaseChanged();
        }
    }

    public void deleteEpisode(String url) {
        String[] args = {url};
        getWritableDatabase().delete(TABLE_EPISODE, COL_EPISODE_URL + "=?", args);
        if (mListener != null) {
            this.mListener.onDatabaseChanged();
        }
    }

    public void deleteAllFavorite() {
        getWritableDatabase().delete(TABLE_NAME, null, null);
        if (mListener != null) {
            this.mListener.onDatabaseChanged();
        }
    }

    public void deleteAllEpisode() {
        getWritableDatabase().delete(TABLE_EPISODE, null, null);
        if (mListener != null) {
            this.mListener.onDatabaseChanged();
        }
    }

    public void updateFavorite(int id, String url, String name, String source, String thumbnail, String latesteps, String epstotal) {
        String[] args = {Integer.toString(id)};
        getWritableDatabase().update(TABLE_NAME, valuesFavorite(url, name, source, thumbnail, latesteps, epstotal), COL_ID + "=?", args);
        this.mListener.onDatabaseChanged();
    }

    public void updateEpisode(int id, String url, String name) {
        String[] args = {Integer.toString(id)};
        getWritableDatabase().update(TABLE_EPISODE, valuesEpisode(url, name), COL_ID + "=?", args);
        this.mListener.onDatabaseChanged();
    }

    private ContentValues valuesFavorite(String url, String name, String source, String thumbnail, String latesteps,  String epstotal) {
        ContentValues contentValues = new ContentValues();
        contentValues.put(COL_URL, url);
        contentValues.put(COL_NAME, name);
        contentValues.put(COL_SOURCE, source);
        contentValues.put(COL_THUMBNAIL, thumbnail);
        contentValues.put(COL_LATESTEPS, latesteps);
        contentValues.put(COL_EPSTOTAL, epstotal);
        return contentValues;
    }

    private ContentValues valuesEpisode(String url, String name) {
        ContentValues contentValues = new ContentValues();
        contentValues.put(COL_EPISODE_URL, url);
        contentValues.put(COL_EPISODE_NAME, name);
        return contentValues;
    }

}