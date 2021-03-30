package com.acv.radio.bluetooth;

import android.util.Log;

public class Command {
    public static int KEY_HOLD = 4;
    public static int KEY_LONG_PRESS = 2;
    public static int KEY_PRESS = 1;
    public static int KEY_RELEASE = 8;
    public static final String TAG = "Command";

    public static byte[] nextMode() {
        return commandNoData(1, 1);
    }

    public static byte[] selectMode(int i) {
        return commandWithData(1, 2, i);
    }

    public static byte[] getMode() {
        return commandNoData(1, 3);
    }

    public static byte[] volumeAdd() {
        return commandNoData(2, 1);
    }

    public static byte[] volumeSub() {
        return commandNoData(2, 2);
    }

    public static byte[] setVolume(int i) {
        return commandWithData(2, 3, i);
    }

    public static byte[] getVolume() {
        return commandNoData(2, 4);
    }

    public static byte[] setEQ() {
        return commandNoData(2, 5);
    }

    public static byte[] getEQ() {
        return commandNoData(2, 6);
    }

    public static byte[] setMute(boolean z) {
        return commandWithData(2, 7, z ? 1 : 0);
    }

    public static byte[] setBass(int i) {
        return commandWithData(2, 8, i);
    }

    public static byte[] setTreble(int i) {
        return commandWithData(2, 9, i);
    }

    public static byte[] setBalance(int i) {
        return commandWithData(2, 10, i);
    }

    public static byte[] setFade(int i) {
        return commandWithData(2, 11, i);
    }

    public static byte[] setSt() {
        return commandNoData(2, 12);
    }

    public static byte[] getMute() {
        return commandNoData(2, 13);
    }

    public static byte[] getSt() {
        return commandNoData(2, 14);
    }

    public static byte[] getBTBF() {
        return commandNoData(2, 15);
    }

    public static byte[] setLoud(int i) {
        return commandWithData(2, 16, i);
    }

    public static byte[] getLoud() {
        return commandNoData(2, 17);
    }

    public static byte[] setSub(int i) {
        return commandWithData(2, 18, i);
    }

    public static byte[] getSub() {
        return commandNoData(2, 19);
    }

    public static byte[] prev(int i) {
        return commandWithData(3, 1, i);
    }

    public static byte[] playPause(int i) {
        return commandWithData(3, 2, i);
    }

    public static byte[] next(int i) {
        return commandWithData(3, 3, i);
    }

    public static byte[] band(int i) {
        return commandWithData(3, 4, i);
    }

    public static byte[] GetPresetChannel() {
        return commandNoData(3, 32);
    }

    public static byte[] key0Press(int i) {
        return commandWithData(3, 16, i);
    }

    public static byte[] key1Press(int i) {
        return commandWithData(3, 17, i);
    }

    public static byte[] key2Press(int i) {
        return commandWithData(3, 18, i);
    }

    public static byte[] key3Press(int i) {
        return commandWithData(3, 19, i);
    }

    public static byte[] key4Press(int i) {
        return commandWithData(3, 20, i);
    }

    public static byte[] key5Press(int i) {
        return commandWithData(3, 21, i);
    }

    public static byte[] key6Press(int i) {
        return commandWithData(3, 22, i);
    }

    public static byte[] getBandFreq() {
        return commandNoData(4, 2);
    }

    public static byte[] getPlayPause() {
        return commandNoData(4, 4);
    }

    public static byte[] getPlayTime() {
        return commandNoData(5, 1);
    }

    public static byte[] playMode(int i) {
        return commandWithData(5, 7, i);
    }

    public static byte[] getCallState() {
        return commandNoData(6, 2);
    }

    public static byte[] setCallState(int i) {
        return commandWithData(6, 3, i);
    }

    public static byte[] getAppName() {
        return commandNoData(6, 4);
    }

    public static byte[] setPlayTime(int i) {
        return commandWithData(5, 12, i, 2);
    }

    public static byte[] commandNoData(int i, int i2) {
        byte[] bArr = new byte[6];
        bArr[0] = 85;
        bArr[1] = -86;
        bArr[2] = 0;
        bArr[3] = (byte) i;
        bArr[4] = (byte) i2;
        bArr[5] = (byte) (0 - ((bArr[2] + bArr[3]) + bArr[4]));
        logoutAllByte("commandNoData: ", bArr, true);
        return bArr;
    }
    3 4 1
    public static byte[] commandWithData(int i, int i2, int i3) {
        byte[] bArr = new byte[7];
        bArr[0] = 85;
        bArr[1] = -86;
        bArr[2] = 1;
        bArr[3] = (byte) i;
        bArr[4] = (byte) i2;
        bArr[5] = (byte) (i3 & 255);
        bArr[6] = (byte) (0 - (((bArr[2] + bArr[3]) + bArr[4]) + bArr[5]));
        logoutAllByte("commandWithData: ", bArr, true);
        return bArr;
    }

    public static byte[] commandWithData(int i, int i2, int i3, int i4) {
        int i5 = i4 + 6;
        byte[] bArr = new byte[i5];
        bArr[0] = 85;
        bArr[1] = -86;
        bArr[2] = (byte) i4;
        int i6 = 3;
        bArr[3] = (byte) i;
        bArr[4] = (byte) i2;
        for (int i7 = 1; i7 <= i4; i7++) {
            bArr[i7 + 4] = (byte) ((i3 >> ((i7 - 1) * 8)) & 255);
        }
        byte b = bArr[2];
        while (true) {
            int i8 = i5 - 1;
            if (i6 < i8) {
                b = (byte) (b + bArr[i6]);
                i6++;
            } else {
                bArr[i8] = (byte) (0 - b);
                logoutAllByte("commandWithData: ", bArr, true);
                return bArr;
            }
        }
    }

    public static void logoutAllByte(String str, byte[] bArr, boolean z) {
        if (bArr != null && bArr.length != 0) {
            StringBuilder sb = new StringBuilder(str);
            int length = bArr.length;
            for (int i = 0; i < length; i++) {
                sb.append(String.format("%02x", new Object[]{Byte.valueOf(bArr[i])}));
            }
            sb.append("+");
            if (z) {
                Log.i(TAG, sb.toString());
            } else {
                Log.e(TAG, sb.toString());
            }
        }
    }
}