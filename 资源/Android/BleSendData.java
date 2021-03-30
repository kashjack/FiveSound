package com.acv.radio.bluetooth;

import com.acv.radio.bluetooth.CommandParser;

public class BleSendData {
    public CommandParser.CMD cmd;
    public byte[] data;
    public int dataIndex;
    public boolean isAck;
    public int maxNumInQueue;

    public BleSendData(byte[] bArr) {
        this(bArr, false, 0);
    }

    public BleSendData(byte[] bArr, boolean z, int i) {
        this.data = bArr;
        this.isAck = z;
        this.dataIndex = i;
        this.maxNumInQueue = 1;
        if (bArr != null && bArr.length > 5) {
            this.cmd = CommandParser.parseCmd(bArr[3], bArr[4]);
            this.maxNumInQueue = setMaxNumInQueue();
        }
    }

    private int setMaxNumInQueue() {
        switch (this.cmd) {
            case SET_VOL:
            case BASS:
            case TREBLE:
            case BALANCE:
            case FADE:
                return 5;
            case ST:
                return 1;
            default:
                return 1;
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("[ isAck:");
        sb.append(this.isAck);
        if (this.data == null || this.data.length < 6) {
            sb.append(",send data not valid..");
        } else {
            sb.append(",command:");
            sb.append(CommandParser.parseCmdStr(this.data[3], this.data[4]));
            sb.append(",cmd:");
            sb.append(this.cmd);
            sb.append(",data:");
            byte[] bArr = this.data;
            int length = bArr.length;
            for (int i = 0; i < length; i++) {
                sb.append(String.format("%02x", new Object[]{Byte.valueOf(bArr[i])}));
            }
            sb.append(" ]");
        }
        return sb.toString();
    }
}