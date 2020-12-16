package com.acv.radio.bluetooth;

import android.support.v4.view.InputDeviceCompat;
import java.io.UnsupportedEncodingException;

public class CommandParser {
    public static boolean needSendAck(byte b, byte b2) {
        if ((b & 128) == 128) {
            return false;
        }
        if (((byte) (b & Byte.MAX_VALUE)) != 5) {
            return true;
        }
        if (b2 == 7) {
            return false;
        }
        switch (b2) {
            case 1:
                return false;
            case 2:
                return false;
            default:
                return true;
        }
    }

    public static String parseCmdStr(byte b, byte b2) {
        switch ((byte) (b & Byte.MAX_VALUE)) {
            case 1:
                return b2 == 1 ? "Next Mode" : b2 == 2 ? "Select Mode" : b2 == 3 ? "Get Mode" : "";
            case 2:
                switch (b2) {
                    case 1:
                        return "VOL+";
                    case 2:
                        return "VOL-";
                    case 3:
                        return "SET VOL";
                    case 4:
                        return "GET VOL";
                    case 5:
                        return "SET EQ";
                    case 6:
                        return "GET EQ";
                    case 7:
                        return "MUTE";
                    case 8:
                        return "BASS";
                    case 9:
                        return "TREBLE";
                    case 10:
                        return "BALANCE";
                    case 11:
                        return "FADE";
                    case 12:
                        return "ST";
                    case 13:
                        return "GET MUTE";
                    case 14:
                        return "GET ST";
                    case 15:
                        return "GET BTBF";
                    case 16:
                        return "SET LOUD";
                    case 17:
                        return "GET LOUD";
                    case 18:
                        return "SET SUB";
                    case 19:
                        return "GET SUB";
                    default:
                        return "";
                }
            case 3:
                switch (b2) {
                    case 1:
                        return "PREV";
                    case 2:
                        return "Play Pause";
                    case 3:
                        return "NEXT";
                    case 4:
                        return "BAND";
                    case 5:
                        return "AMS";
                    case 6:
                        return "Set Power";
                    default:
                        switch (b2) {
                            case 16:
                                return "Key0";
                            case 17:
                                return "Key1";
                            case 18:
                                return "Key2";
                            case 19:
                                return "Key3";
                            case 20:
                                return "Key4";
                            case 21:
                                return "Key5";
                            case 22:
                                return "Key6";
                            case 23:
                                return "Key7";
                            case 24:
                                return "Key8";
                            case 25:
                                return "Key9";
                            case 26:
                                return "FAM_CH1";
                            case 27:
                                return "FAM_CH2";
                            case 28:
                                return "FAM_CH3";
                            case 29:
                                return "FAM_CH4";
                            case 30:
                                return "FAM_CH5";
                            case 31:
                                return "FAM_CH6";
                            case 32:
                                return "CMD_CH_GET";
                            default:
                                return "";
                        }
                }
            case 4:
                switch (b2) {
                    case 1:
                        return "Set Time";
                    case 2:
                        return "Band Freq";
                    case 3:
                        return "Current Vol";
                    case 4:
                        return "Get Play/Pause";
                    default:
                        return "";
                }
            case 5:
                switch (b2) {
                    case 1:
                        return "Get Play Time";
                    case 2:
                        return "Get Play Total Time";
                    default:
                        switch (b2) {
                            case 7:
                                return "Play Mode";
                            case 8:
                                return "Cur Title";
                            case 9:
                                return "Cur Artist";
                            case 10:
                                return "Cur Album";
                            case 11:
                                return "Cur File Name";
                            case 12:
                                return "Get Play Time";
                            default:
                                return "";
                        }
                }
            case 6:
                switch (b2) {
                    case 1:
                        return "CALL STATUS";
                    case 2:
                        return "GET CALL STATUS;";
                    case 3:
                        return "CHANGE CALL STATUS";
                    case 4:
                        return "GET APP NAME";
                    default:
                        return "";
                }
            default:
                return "";
        }
    }

    public static int unsignedByteToInt(byte b) {
        return b & 255;
    }

    public enum PlayMode {
        LOOP_ALL(1),
        LOOP_SINGLE(2),
        LOOP_FOLDER(3),
        LOOP_NORMAL(4),
        LOOP_RANDOM(5),
        LOOP_BROWSE(6);

        private PlayMode(int i) {
        }
    }

    public enum CMD {
        UNKNOWN(0),
        NEXT_MODE(InputDeviceCompat.SOURCE_KEYBOARD),
        SELECT_MODE(258),
        GET_MODE(259),
        VOL_ADD(InputDeviceCompat.SOURCE_DPAD),
        VOL_SUB(514),
        SET_VOL(515),
        GET_VOL(516),
        SET_EQ(517),
        GET_EQ(518),
        MUTE(519),
        BASS(520),
        TREBLE(521),
        BALANCE(522),
        FADE(523),
        ST(524),
        GET_MUTE(525),
        GET_ST(526),
        GET_BTBF(527),
        SET_LOUD(528),
        GET_LOUD(529),
        SET_SUB(530),
        GET_SUB(531),
        PREV(769),
        PLAY_PAUSE(770),
        NEXT(771),
        BAND(772),
        AMS(773),
        SET_POWER(774),
        KEY0(784),
        KEY1(785),
        KEY2(786),
        KEY3(787),
        KEY4(788),
        KEY5(789),
        KEY6(790),
        KEY7(791),
        KEY8(792),
        KEY9(793),
        FAM_CH1(794),
        FAM_CH2(795),
        FAM_CH3(796),
        FAM_CH4(797),
        FAM_CH5(798),
        FAM_CH6(799),
        CMD_CH_GET(800),
        SET_TIME(InputDeviceCompat.SOURCE_GAMEPAD),
        BAND_FREQ(1026),
        CUR_VOL(1027),
        GET_PLAY_PAUSE(1028),
        GET_PLAY_TIME(1281),
        GET_PLAY_TOTAL_TIME(1282),
        PLAY_MODE(1287),
        CUR_TITLE(1288),
        CUR_ARTIST(1289),
        CUR_ALBUM(1290),
        CUR_FILE_NAME(1291),
        SET_PLAY_TIME(1292),
        CALL_STATUS(1537),
        GET_CALL_STATUS(1538),
        CHANGE_CALL_STATUS(1539),
        GET_APP_NAME(1540);
        
        private int code;

        private CMD(int i) {
            this.code = i;
        }

        public int getCode() {
            return this.code;
        }
    }

    public static CMD parseCmd(byte b, byte b2) {
        switch ((byte) (b & Byte.MAX_VALUE)) {
            case 1:
                if (b2 == 1) {
                    return CMD.NEXT_MODE;
                }
                if (b2 == 2) {
                    return CMD.SELECT_MODE;
                }
                if (b2 == 3) {
                    return CMD.GET_MODE;
                }
                break;
            case 2:
                switch (b2) {
                    case 1:
                        return CMD.VOL_ADD;
                    case 2:
                        return CMD.VOL_SUB;
                    case 3:
                        return CMD.SET_VOL;
                    case 4:
                        return CMD.GET_VOL;
                    case 5:
                        return CMD.SET_EQ;
                    case 6:
                        return CMD.GET_EQ;
                    case 7:
                        return CMD.MUTE;
                    case 8:
                        return CMD.BASS;
                    case 9:
                        return CMD.TREBLE;
                    case 10:
                        return CMD.BALANCE;
                    case 11:
                        return CMD.FADE;
                    case 12:
                        return CMD.ST;
                    case 13:
                        return CMD.GET_MUTE;
                    case 14:
                        return CMD.GET_ST;
                    case 15:
                        return CMD.GET_BTBF;
                    case 16:
                        return CMD.SET_LOUD;
                    case 17:
                        return CMD.GET_LOUD;
                    case 18:
                        return CMD.SET_SUB;
                    case 19:
                        return CMD.GET_SUB;
                }
            case 3:
                switch (b2) {
                    case 1:
                        return CMD.PREV;
                    case 2:
                        return CMD.PLAY_PAUSE;
                    case 3:
                        return CMD.NEXT;
                    case 4:
                        return CMD.BAND;
                    case 5:
                        return CMD.AMS;
                    case 6:
                        return CMD.SET_POWER;
                    default:
                        switch (b2) {
                            case 16:
                                return CMD.KEY0;
                            case 17:
                                return CMD.KEY1;
                            case 18:
                                return CMD.KEY2;
                            case 19:
                                return CMD.KEY3;
                            case 20:
                                return CMD.KEY4;
                            case 21:
                                return CMD.KEY5;
                            case 22:
                                return CMD.KEY6;
                            case 23:
                                return CMD.KEY7;
                            case 24:
                                return CMD.KEY8;
                            case 25:
                                return CMD.KEY9;
                            case 26:
                                return CMD.FAM_CH1;
                            case 27:
                                return CMD.FAM_CH2;
                            case 28:
                                return CMD.FAM_CH3;
                            case 29:
                                return CMD.FAM_CH4;
                            case 30:
                                return CMD.FAM_CH5;
                            case 31:
                                return CMD.FAM_CH6;
                            case 32:
                                return CMD.CMD_CH_GET;
                        }
                }
            case 4:
                switch (b2) {
                    case 1:
                        return CMD.SET_TIME;
                    case 2:
                        return CMD.BAND_FREQ;
                    case 3:
                        return CMD.CUR_VOL;
                    case 4:
                        return CMD.GET_PLAY_PAUSE;
                }
            case 5:
                switch (b2) {
                    case 1:
                        return CMD.GET_PLAY_TIME;
                    case 2:
                        return CMD.GET_PLAY_TOTAL_TIME;
                    default:
                        switch (b2) {
                            case 7:
                                return CMD.PLAY_MODE;
                            case 8:
                                return CMD.CUR_TITLE;
                            case 9:
                                return CMD.CUR_ARTIST;
                            case 10:
                                return CMD.CUR_ALBUM;
                            case 11:
                                return CMD.CUR_FILE_NAME;
                            case 12:
                                return CMD.SET_PLAY_TIME;
                        }
                }
            case 6:
                switch (b2) {
                    case 1:
                        return CMD.CALL_STATUS;
                    case 2:
                        return CMD.GET_CALL_STATUS;
                    case 3:
                        return CMD.CHANGE_CALL_STATUS;
                    case 4:
                        return CMD.GET_APP_NAME;
                }
        }
        return CMD.UNKNOWN;
    }

    public static String bytesToString(byte[] bArr, int i) {
        try {
            return new String(bArr, "ASCII");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return "";
        }
    }

    public static int unsignedBytesToInt(byte b, byte b2) {
        return unsignedByteToInt(b) + (unsignedByteToInt(b2) << 8);
    }

    public static int unsignedBytesToInt(byte b, byte b2, byte b3, byte b4) {
        return unsignedByteToInt(b) + (unsignedByteToInt(b2) << 8) + (unsignedByteToInt(b3) << 16) + (unsignedByteToInt(b4) << 24);
    }

    public static int unsignedBytesArrayToInt(byte[] bArr, boolean z) {
        int i = 0;
        if (z) {
            int i2 = 0;
            for (int length = bArr.length - 1; length >= 0; length--) {
                i += unsignedByteToInt(bArr[length]) << (i2 * 8);
                i2++;
            }
            return i;
        }
        int i3 = 0;
        while (i < bArr.length) {
            i3 += unsignedByteToInt(bArr[i]) << (i * 8);
            i++;
        }
        return i3;
    }
}