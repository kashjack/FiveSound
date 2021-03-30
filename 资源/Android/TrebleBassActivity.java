package com.acv.radio.activity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import com.acv.radio.Config;
import com.acv.radio.PrefsHelper;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.acv.radio.widget.OnRotateChangeListener;
import com.acv.radio.widget.RotaryKnob;
import com.five.sound.R;

public class TrebleBassActivity extends BaseActivity {
    private TextView btn_eq;
    private int curBass;
    private int curTreble;
    private RotaryKnob knob_bass;
    private RotaryKnob knob_treble;
    /* access modifiers changed from: private */
    public int lastBass;
    /* access modifiers changed from: private */
    public int lastTreble;
    /* access modifiers changed from: private */
    public int maxBass;
    /* access modifiers changed from: private */
    public int maxTreble;
    /* access modifiers changed from: private */
    public TextView tv_bass_db;
    /* access modifiers changed from: private */
    public TextView tv_treble_db;

    /* access modifiers changed from: protected */
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_treble_bass);
        initView();
    }

    /* access modifiers changed from: protected */
    public void onBleServiceConnected() {
        super.onBleServiceConnected();
        sendData(Command.getBTBF());
        sendData(Command.getEQ());
    }

    /* access modifiers changed from: protected */
    public void initView() {
        super.initView();
        setUiTitle(R.string.activity_treble_bass_title);
        this.tv_treble_db = (TextView) findViewById(R.id.tv_treble_db);
        this.tv_bass_db = (TextView) findViewById(R.id.tv_bass_db);
        this.btn_eq = (TextView) findViewById(R.id.btn_eq);
        this.btn_eq.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                Log.e("ACV_RADIO", "205 btn_eq click...." + System.currentTimeMillis());
                TrebleBassActivity.this.sendCommand(Command.setEQ(), true);
            }
        });
        this.knob_bass = (RotaryKnob) findViewById(R.id.knob_bass);
        this.knob_treble = (RotaryKnob) findViewById(R.id.knob_treble);
        this.knob_bass.setRotateChangeListener(new OnRotateChangeListener() {
            public void onStartTrackingTouch(RotaryKnob rotaryKnob) {
            }

            public void onProgressChanged(RotaryKnob rotaryKnob, int i, boolean z) {
                if (z && TrebleBassActivity.this.lastBass != i) {
                    int access$100 = (TrebleBassActivity.this.maxBass * i) / 100;
                    Log.i("ACV_RADIO", "TrebleBassActivity set bass:" + access$100);
                    TrebleBassActivity.this.sendCommand(Command.setBass(access$100), false);
                    int unused = TrebleBassActivity.this.lastBass = i;
                    if (TrebleBassActivity.this.tv_bass_db != null) {
                        TextView access$200 = TrebleBassActivity.this.tv_bass_db;
                        access$200.setText((access$100 - (TrebleBassActivity.this.maxBass / 2)) + " dB");
                    }
                }
            }

            public void onStopTrackingTouch(RotaryKnob rotaryKnob) {
                int progress = rotaryKnob.getProgress();
                int access$100 = (TrebleBassActivity.this.maxBass * progress) / 100;
                Log.i("ACV_RADIO", "TrebleBassActivity set stop bass:" + access$100);
                TrebleBassActivity.this.sendCommand(Command.setBass(access$100), true);
                int unused = TrebleBassActivity.this.lastBass = progress;
                if (TrebleBassActivity.this.tv_bass_db != null) {
                    TextView access$200 = TrebleBassActivity.this.tv_bass_db;
                    access$200.setText((access$100 - (TrebleBassActivity.this.maxBass / 2)) + " dB");
                }
            }
        });
        this.knob_treble.setRotateChangeListener(new OnRotateChangeListener() {
            public void onStartTrackingTouch(RotaryKnob rotaryKnob) {
            }

            public void onProgressChanged(RotaryKnob rotaryKnob, int i, boolean z) {
                if (z && TrebleBassActivity.this.lastTreble != i) {
                    int access$400 = (TrebleBassActivity.this.maxTreble * i) / 100;
                    Log.i("ACV_RADIO", "TrebleBassActivity set treble:" + access$400);
                    TrebleBassActivity.this.sendCommand(Command.setTreble(access$400), false);
                    int unused = TrebleBassActivity.this.lastTreble = i;
                    if (TrebleBassActivity.this.tv_treble_db != null) {
                        TextView access$500 = TrebleBassActivity.this.tv_treble_db;
                        access$500.setText((access$400 - (TrebleBassActivity.this.maxTreble / 2)) + " dB");
                    }
                }
            }

            public void onStopTrackingTouch(RotaryKnob rotaryKnob) {
                int progress = rotaryKnob.getProgress();
                int access$400 = (TrebleBassActivity.this.maxTreble * progress) / 100;
                Log.i("ACV_RADIO", "TrebleBassActivity set stop treble:" + access$400);
                TrebleBassActivity.this.sendCommand(Command.setTreble(access$400), true);
                int unused = TrebleBassActivity.this.lastTreble = progress;
                if (TrebleBassActivity.this.tv_treble_db != null) {
                    TextView access$500 = TrebleBassActivity.this.tv_treble_db;
                    access$500.setText((access$400 - (TrebleBassActivity.this.maxTreble / 2)) + " dB");
                }
            }
        });
        this.curBass = PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_CUR_BASS);
        this.maxBass = PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_MAX_BASS, 14);
        updateBassUi(this.curBass, this.maxBass);
        this.curTreble = PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_CUR_TREBLE);
        this.maxTreble = PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_MAX_TREBLE, 14);
        updateTrebleUi(this.curTreble, this.maxTreble);
    }

    private void updateBassUi(int i, int i2) {
        Log.i("ACV_RADIO", "TrebleBassActivity-->updateBassUi curBass:" + i + ",maxBass:" + i2);
        if (this.tv_bass_db != null) {
            TextView textView = this.tv_bass_db;
            textView.setText((i - (i2 / 2)) + " dB");
        }
        if (i2 > 0) {
            int i3 = (i * 100) / i2;
            if (this.knob_bass != null) {
                this.toggleByMan = false;
                this.knob_bass.setProgress(i3);
                this.toggleByMan = true;
            }
        }
    }

    private void updateTrebleUi(int i, int i2) {
        Log.i("ACV_RADIO", "TrebleBassActivity-->updateTrebleUi curTreble:" + i + ",maxTreble:" + i2);
        if (this.tv_treble_db != null) {
            TextView textView = this.tv_treble_db;
            textView.setText((i - (i2 / 2)) + " dB");
        }
        if (i2 > 0) {
            int i3 = (i * 100) / i2;
            if (this.knob_treble != null) {
                this.toggleByMan = false;
                this.knob_treble.setProgress(i3);
                this.toggleByMan = true;
            }
        }
    }

    /* access modifiers changed from: protected */
    public void receiveData(BleNotifyData bleNotifyData) {
        super.receiveData(bleNotifyData);
        if (bleNotifyData != null) {
            String parseCmdStr = CommandParser.parseCmdStr(bleNotifyData.cmdH, bleNotifyData.cmdL);
            if (parseCmdStr != null && !parseCmdStr.startsWith("Get Play T")) {
                byte[] bArr = bleNotifyData.data;
                Command.logoutAllByte("TrebleBassActivity-->receiveData cmd:" + parseCmdStr + ",data length:" + bleNotifyData.length + ",data: ", bArr, true);
            }
            switch (bleNotifyData.cmd) {
                case GET_BTBF:
                    updateBassTreble(bleNotifyData);
                    return;
                case BASS:
                    updateBass(bleNotifyData);
                    return;
                case TREBLE:
                    updateTreble(bleNotifyData);
                    return;
                case GET_EQ:
                    updateEQ(bleNotifyData);
                    return;
                case SET_EQ:
                    updateEQ(bleNotifyData);
                    return;
                default:
                    return;
            }
        }
    }

    private void updateEQ(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("TrebleBassActivity SET_EQ data: ", bArr, true);
            int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
            updateEQText(unsignedByteToInt);
            Log.i("ACV_RADIO", "TrebleBassActivity SET_EQ eqType:" + unsignedByteToInt);
            return;
        }
        Log.e("ACV_RADIO", "TrebleBassActivity SET_EQ data error..");
    }

    private void updateEQText(int i) {
        if (this.btn_eq != null) {
            switch (i) {
                case 0:
                    this.btn_eq.setText(R.string.eq_user);
                    return;
                case 1:
                    this.btn_eq.setText(R.string.eq_pop);
                    return;
                case 2:
                    this.btn_eq.setText(R.string.eq_rock);
                    return;
                case 3:
                    this.btn_eq.setText(R.string.eq_jazz);
                    return;
                case 4:
                    this.btn_eq.setText(R.string.eq_classic);
                    return;
                case 5:
                    this.btn_eq.setText(R.string.eq_country);
                    return;
                default:
                    return;
            }
        }
    }

    private void updateBass(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 2) {
            Log.e("ACV_RADIO", "TrebleBassActivity BASS data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("TrebleBassActivity BASS data: ", bArr, true);
        this.maxBass = CommandParser.unsignedByteToInt(bArr[0]);
        this.curBass = CommandParser.unsignedByteToInt(bArr[1]);
        PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_CUR_BASS, this.curBass);
        PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_MAX_BASS, this.maxBass);
        updateBassUi(this.curBass, this.maxBass);
        Log.i("ACV_RADIO", "TrebleBassActivity BASS maxBass:" + this.maxBass + ",curBass:" + this.curBass);
    }

    private void updateTreble(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 2) {
            Log.e("ACV_RADIO", "TrebleBassActivity GET_BTBF data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("TrebleBassActivity TREBLE data: ", bArr, true);
        this.maxTreble = CommandParser.unsignedByteToInt(bArr[0]);
        this.curTreble = CommandParser.unsignedByteToInt(bArr[1]);
        PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_CUR_TREBLE, this.curTreble);
        PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_MAX_TREBLE, this.maxTreble);
        updateTrebleUi(this.curTreble, this.maxTreble);
        Log.i("ACV_RADIO", "TrebleBassActivity GET_BTBF maxTreble:" + this.maxTreble + ",curTreble:" + this.curTreble);
    }

    private void updateBassTreble(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 8) {
            Log.e("ACV_RADIO", "TrebleBassActivity GET_BTBF data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("TrebleBassActivity GET_BTBF data: ", bArr, true);
        this.maxBass = CommandParser.unsignedByteToInt(bArr[0]);
        this.curBass = CommandParser.unsignedByteToInt(bArr[1]);
        this.maxTreble = CommandParser.unsignedByteToInt(bArr[2]);
        this.curTreble = CommandParser.unsignedByteToInt(bArr[3]);
        updateBassUi(this.curBass, this.maxBass);
        updateTrebleUi(this.curTreble, this.maxTreble);
        Log.i("ACV_RADIO", "TrebleBassActivity GET_BTBF maxBass:" + this.maxBass + ",curBass:" + this.curBass + ",maxTreble:" + this.maxTreble + ",curTreble:" + this.curTreble);
    }
}