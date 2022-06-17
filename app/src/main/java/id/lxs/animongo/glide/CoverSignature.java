package id.lxs.animongo.glide;

import androidx.annotation.NonNull;
import com.bumptech.glide.load.Key;
import java.security.MessageDigest;
import java.io.File;

public final class CoverSignature implements Key {
    private final String key;
    
    public CoverSignature(@NonNull String url, File file) {
        this.key = url + file.lastModified();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof CoverSignature) {
            CoverSignature other = (CoverSignature) obj;
            return this.key.equals(other.key);
        }
        return false;
    }

    @Override
    public int hashCode() {
        return this.key.hashCode();
    }

    @Override
    public void updateDiskCacheKey(@NonNull MessageDigest messageDigest) {
        messageDigest.update(this.key.getBytes(CHARSET));
    }
}