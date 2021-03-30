package com.acv.radio;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.SharedPreferences;
import android.support.annotation.NonNull;
import java.util.LinkedHashSet;
import java.util.Set;

public class PrefsHelper {
    private static final boolean DEFAULT_BOOLEAN_VALUE = false;
    private static final double DEFAULT_DOUBLE_VALUE = -1.0d;
    private static final float DEFAULT_FLOAT_VALUE = -1.0f;
    private static final int DEFAULT_INT_VALUE = -1;
    private static final long DEFAULT_LONG_VALUE = -1;
    private static final String DEFAULT_STRING_VALUE = "";
    private static final String LENGTH = "_length";
    private static PrefsHelper prefsInstance;
    private static SharedPreferences sharedPreferences;

    private PrefsHelper(@NonNull Context context, String str) {
        sharedPreferences = context.getApplicationContext().getSharedPreferences(str, 0);
    }

    public static PrefsHelper with(@NonNull Context context, String str) {
        prefsInstance = new PrefsHelper(context, str);
        return prefsInstance;
    }

    public String read(String str) {
        return sharedPreferences.getString(str, "");
    }

    public String read(String str, String str2) {
        return sharedPreferences.getString(str, str2);
    }

    public void write(String str, String str2) {
        sharedPreferences.edit().putString(str, str2).apply();
    }

    public int readInt(String str) {
        return sharedPreferences.getInt(str, -1);
    }

    public int readInt(String str, int i) {
        return sharedPreferences.getInt(str, i);
    }

    public void writeInt(String str, int i) {
        sharedPreferences.edit().putInt(str, i).apply();
    }

    public double readDouble(String str) {
        if (!contains(str)) {
            return DEFAULT_DOUBLE_VALUE;
        }
        return Double.longBitsToDouble(readLong(str));
    }

    public double readDouble(String str, double d) {
        if (!contains(str)) {
            return d;
        }
        return Double.longBitsToDouble(readLong(str));
    }

    public void writeDouble(String str, double d) {
        writeLong(str, Double.doubleToRawLongBits(d));
    }

    public float readFloat(String str) {
        return sharedPreferences.getFloat(str, -1.0f);
    }

    public float readFloat(String str, float f) {
        return sharedPreferences.getFloat(str, f);
    }

    public void writeFloat(String str, float f) {
        sharedPreferences.edit().putFloat(str, f).apply();
    }

    public long readLong(String str) {
        return sharedPreferences.getLong(str, -1);
    }

    public long readLong(String str, long j) {
        return sharedPreferences.getLong(str, j);
    }

    public void writeLong(String str, long j) {
        sharedPreferences.edit().putLong(str, j).apply();
    }

    public boolean readBoolean(String str) {
        return sharedPreferences.getBoolean(str, false);
    }

    public boolean readBoolean(String str, boolean z) {
        return sharedPreferences.getBoolean(str, z);
    }

    public void writeBoolean(String str, boolean z) {
        sharedPreferences.edit().putBoolean(str, z).apply();
    }

    @TargetApi(11)
    public void putStringSet(String str, Set<String> set) {
        sharedPreferences.edit().putStringSet(str, set).apply();
    }

    public void putOrderedStringSet(String str, Set<String> set) {
        int i;
        SharedPreferences sharedPreferences2 = sharedPreferences;
        boolean contains = sharedPreferences2.contains(str + LENGTH);
        int i2 = 0;
        if (contains) {
            i = readInt(str + LENGTH);
        } else {
            i = 0;
        }
        writeInt(str + LENGTH, set.size());
        for (String write : set) {
            write(str + "[" + i2 + "]", write);
            i2++;
        }
        while (i2 < i) {
            remove(str + "[" + i2 + "]");
            i2++;
        }
    }

    @TargetApi(11)
    public Set<String> getStringSet(String str, Set<String> set) {
        return sharedPreferences.getStringSet(str, set);
    }

    public Set<String> getOrderedStringSet(String str, Set<String> set) {
        if (!contains(str + LENGTH)) {
            return set;
        }
        LinkedHashSet linkedHashSet = new LinkedHashSet();
        int readInt = readInt(str + LENGTH);
        if (readInt >= 0) {
            for (int i = 0; i < readInt; i++) {
                linkedHashSet.add(read(str + "[" + i + "]"));
            }
        }
        return linkedHashSet;
    }

    public void remove(String str) {
        if (contains(str + LENGTH)) {
            int readInt = readInt(str + LENGTH);
            if (readInt >= 0) {
                SharedPreferences.Editor edit = sharedPreferences.edit();
                edit.remove(str + LENGTH).apply();
                for (int i = 0; i < readInt; i++) {
                    SharedPreferences.Editor edit2 = sharedPreferences.edit();
                    edit2.remove(str + "[" + i + "]").apply();
                }
            }
        }
        sharedPreferences.edit().remove(str).apply();
    }

    public boolean contains(String str) {
        return sharedPreferences.contains(str);
    }

    public void clear() {
        sharedPreferences.edit().clear().apply();
    }
}