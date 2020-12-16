package com.acv.radio.activity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.acv.radio.widget.RadioChannel;
import com.five.sound.R;
import java.util.Locale;

public class RadioActivity extends BaseHeadActivity {
    private final String amFormat = "%.0f";
    private int band;
    private TextView btn_stereo;
    private final String fmFormat = "%.2f";
    private float[] presetChannels;
    private final String[] radioMode = {"FM1", "FM2", "FM3", "AM1", "AM2"};
    private RadioChannel radio_scale;
    private int stereo;
    private TextView tv_fm;
    private TextView tv_fm_band;
    private TextView tv_preset1;
    private TextView tv_preset2;
    private TextView tv_preset3;
    private TextView tv_preset4;
    private TextView tv_preset5;
    private TextView tv_preset6;
    private TextView tv_unit;

    /* access modifiers changed from: protected */
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_radio);
        initView();
    }

    /* access modifiers changed from: protected */
    public void initView() {
        super.initView();
        setUiTitle(R.string.activity_radio_title);
        this.checkboxDisable[0] = false;
        this.checkboxDisable[1] = false;
        this.tv_fm_band = (TextView) findViewById(R.id.tv_fm_band);
        this.tv_fm = (TextView) findViewById(R.id.tv_fm);
        this.tv_unit = (TextView) findViewById(R.id.tv_unit);
        this.radio_scale = (RadioChannel) findViewById(R.id.radio_scale);
        this.btn_stereo = (TextView) findViewById(R.id.btn_stereo);
        this.tv_preset1 = (TextView) findViewById(R.id.tv_preset1);
        this.tv_preset1.setLongClickable(true);
        this.tv_preset1.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                RadioActivity.this.sendData(Command.key1Press(Command.KEY_PRESS));
            }
        });
        this.tv_preset1.setOnLongClickListener(new View.OnLongClickListener() {
            public boolean onLongClick(View view) {
                RadioActivity.this.sendData(Command.key1Press(Command.KEY_LONG_PRESS));
                return true;
            }
        });
        this.tv_preset2 = (TextView) findViewById(R.id.tv_preset2);
        this.tv_preset2.setLongClickable(true);
        this.tv_preset2.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                RadioActivity.this.sendData(Command.key2Press(Command.KEY_PRESS));
            }
        });
        this.tv_preset2.setOnLongClickListener(new View.OnLongClickListener() {
            public boolean onLongClick(View view) {
                RadioActivity.this.sendData(Command.key2Press(Command.KEY_LONG_PRESS));
                return true;
            }
        });
        this.tv_preset3 = (TextView) findViewById(R.id.tv_preset3);
        this.tv_preset3.setLongClickable(true);
        this.tv_preset3.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                RadioActivity.this.sendData(Command.key3Press(Command.KEY_PRESS));
            }
        });
        this.tv_preset3.setOnLongClickListener(new View.OnLongClickListener() {
            public boolean onLongClick(View view) {
                RadioActivity.this.sendData(Command.key3Press(Command.KEY_LONG_PRESS));
                return true;
            }
        });
        this.tv_preset4 = (TextView) findViewById(R.id.tv_preset4);
        this.tv_preset4.setLongClickable(true);
        this.tv_preset4.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                RadioActivity.this.sendData(Command.key4Press(Command.KEY_PRESS));
            }
        });
        this.tv_preset4.setOnLongClickListener(new View.OnLongClickListener() {
            public boolean onLongClick(View view) {
                RadioActivity.this.sendData(Command.key4Press(Command.KEY_LONG_PRESS));
                return true;
            }
        });
        this.tv_preset5 = (TextView) findViewById(R.id.tv_preset5);
        this.tv_preset5.setLongClickable(true);
        this.tv_preset5.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                RadioActivity.this.sendData(Command.key5Press(Command.KEY_PRESS));
            }
        });
        this.tv_preset5.setOnLongClickListener(new View.OnLongClickListener() {
            public boolean onLongClick(View view) {
                RadioActivity.this.sendData(Command.key5Press(Command.KEY_LONG_PRESS));
                return true;
            }
        });
        this.tv_preset6 = (TextView) findViewById(R.id.tv_preset6);
        this.tv_preset6.setLongClickable(true);
        this.tv_preset6.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                RadioActivity.this.sendData(Command.key6Press(Command.KEY_PRESS));
            }
        });
        this.tv_preset6.setOnLongClickListener(new View.OnLongClickListener() {
            public boolean onLongClick(View view) {
                RadioActivity.this.sendData(Command.key6Press(Command.KEY_LONG_PRESS));
                return true;
            }
        });
    }

    /* access modifiers changed from: protected */
    public void onBleServiceConnected() {
        super.onBleServiceConnected();
        sendData(Command.GetPresetChannel());
        sendData(Command.getBandFreq());
        sendData(Command.getLoud());
        sendData(Command.getSub());
        sendData(Command.getSt());
    }

    public void doClick(View view) {
        switch (view.getId()) {
            case R.id.btn_band:
                sendData(Command.band(Command.KEY_PRESS));
                return;
            case R.id.btn_fm_add:
                sendData(Command.next(Command.KEY_PRESS));
                return;
            case R.id.btn_fm_sub:
                sendData(Command.prev(Command.KEY_PRESS));
                return;
            case R.id.btn_stereo:
                sendData(Command.setSt());
                if (this.stereo == 1) {
                    this.stereo = 0;
                } else {
                    this.stereo = 1;
                }
                if (this.btn_stereo != null) {
                    this.btn_stereo.setText(this.stereo == 1 ? R.string.stereo : R.string.mono);
                    return;
                }
                return;
            default:
                return;
        }
    }

    /* access modifiers changed from: protected */
    public void receiveData(BleNotifyData bleNotifyData) {
        super.receiveData(bleNotifyData);
        if (bleNotifyData != null) {
            Log.i("ACV_RADIO", "RadioActivity-->receiveData cmd:" + CommandParser.parseCmdStr(bleNotifyData.cmdH, bleNotifyData.cmdL) + ",data length:" + bleNotifyData.length);
            switch (bleNotifyData.cmd) {
                case GET_MUTE:
                    updateMute(bleNotifyData);
                    return;
                case BAND_FREQ:
                    updateBandFreq(bleNotifyData);
                    return;
                case CMD_CH_GET:
                    updatePresetChannel(bleNotifyData);
                    return;
                case GET_ST:
                    updateStereo(bleNotifyData);
                    return;
                case FAM_CH1:
                    updatePreset(bleNotifyData, 0);
                    return;
                case FAM_CH2:
                    updatePreset(bleNotifyData, 1);
                    return;
                case FAM_CH3:
                    updatePreset(bleNotifyData, 2);
                    return;
                case FAM_CH4:
                    updatePreset(bleNotifyData, 3);
                    return;
                case FAM_CH5:
                    updatePreset(bleNotifyData, 4);
                    return;
                case FAM_CH6:
                    updatePreset(bleNotifyData, 5);
                    return;
                default:
                    return;
            }
        }
    }

    private void updatePreset(BleNotifyData bleNotifyData, int i) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("RadioActivity FAM_CH1 data: ", bArr, true);
            if (bleNotifyData.length == 2) {
                float unsignedBytesToInt = (float) CommandParser.unsignedBytesToInt(bArr[1], bArr[0]);
                if (this.band < 3) {
                    unsignedBytesToInt /= 100.0f;
                }
                if (i >= 0 && i < this.presetChannels.length) {
                    this.presetChannels[i] = unsignedBytesToInt;
                }
                setPresetChannelText(this.band);
                return;
            }
            return;
        }
        Log.e("ACV_RADIO", "RadioActivity GET_ST data error..");
    }

    private void updateStereo(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("RadioActivity GET_ST data: ", bArr, true);
            if (bleNotifyData.length == 1) {
                this.stereo = CommandParser.unsignedByteToInt(bArr[0]);
                if (this.btn_stereo != null) {
                    this.btn_stereo.setText(this.stereo == 1 ? R.string.stereo : R.string.mono);
                    return;
                }
                return;
            }
            return;
        }
        Log.e("ACV_RADIO", "RadioActivity GET_ST data error..");
    }

    private void updatePresetChannel(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 14) {
            Log.e("ACV_RADIO", "RadioActivity CMD_CH_GET data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("RadioActivity CMD_CH_GET data: ", bArr, true);
        this.presetChannels = new float[6];
        for (int i = 0; i < 6; i++) {
            int i2 = i * 2;
            float unsignedBytesToInt = (float) CommandParser.unsignedBytesToInt(bArr[i2 + 3], bArr[i2 + 2]);
            Log.i("ACV_RADIO", "updatePresetChannel band:" + this.band);
            if (this.band < 3) {
                unsignedBytesToInt /= 100.0f;
            }
            this.presetChannels[i] = unsignedBytesToInt;
        }
        setPresetChannelText(this.band);
    }

    private void setPresetChannelText(int i) {
        String str = i < 3 ? "%.2f" : "%.0f";
        if (this.presetChannels != null && this.presetChannels.length > 0) {
            switch (this.presetChannels.length) {
                case 1:
                    this.tv_preset1.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[0])}));
                    return;
                case 2:
                    this.tv_preset1.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[0])}));
                    this.tv_preset2.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[1])}));
                    return;
                case 3:
                    this.tv_preset1.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[0])}));
                    this.tv_preset2.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[1])}));
                    this.tv_preset3.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[2])}));
                    return;
                case 4:
                    this.tv_preset1.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[0])}));
                    this.tv_preset2.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[1])}));
                    this.tv_preset3.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[2])}));
                    this.tv_preset4.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[3])}));
                    return;
                case 5:
                    this.tv_preset1.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[0])}));
                    this.tv_preset2.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[1])}));
                    this.tv_preset3.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[2])}));
                    this.tv_preset4.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[3])}));
                    this.tv_preset5.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[4])}));
                    return;
                case 6:
                    this.tv_preset1.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[0])}));
                    this.tv_preset2.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[1])}));
                    this.tv_preset3.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[2])}));
                    this.tv_preset4.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[3])}));
                    this.tv_preset5.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[4])}));
                    this.tv_preset6.setText(String.format(Locale.getDefault(), str, new Object[]{Float.valueOf(this.presetChannels[5])}));
                    return;
                default:
                    return;
            }
        }
    }

    public void updateMute(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            Command.logoutAllByte("RadioActivity GET_MUTE data: ", bleNotifyData.data, true);
        } else {
            Log.e("ACV_RADIO", "RadioActivity GET_MUTE data error..");
        }
    }

    private void updateBandFreq(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 4) {
            Log.e("ACV_RADIO", "RadioActivity BAND_FREQ data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("RadioActivity BAND_FREQ data: ", bArr, true);
        this.band = CommandParser.unsignedByteToInt(bArr[0]);
        int unsignedBytesToInt = CommandParser.unsignedBytesToInt(bArr[1], bArr[2]);
        float f = 0.0f;
        if (this.band >= 0 && this.band < this.radioMode.length) {
            if (this.tv_fm_band != null) {
                this.tv_fm_band.setText(this.radioMode[this.band]);
            }
            if (this.tv_unit != null) {
                if (this.band < 3) {
                    f = ((float) unsignedBytesToInt) / 100.0f;
                    this.tv_unit.setText(R.string.mhz);
                } else {
                    f = (float) unsignedBytesToInt;
                    this.tv_unit.setText(R.string.khz);
                }
            }
            if (this.tv_fm != null) {
                this.tv_fm.setText(String.format(Locale.getDefault(), this.band < 3 ? "%.2f" : "%.0f", new Object[]{Float.valueOf(f)}));
            }
            if (this.radio_scale != null) {
                this.radio_scale.setProgress(this.band < 3 ? (int) (((f - 85.0f) * 100.0f) / 25.0f) : (int) (((f - 520.0f) * 100.0f) / 1200.0f));
            }
        }
    }

    private void highLightPresetChannel(int i) {
        this.tv_preset1.setTextColor(ContextCompat.getColor(this, R.color.text_grey_to_white));
        this.tv_preset2.setTextColor(ContextCompat.getColor(this, R.color.text_grey_to_white));
        this.tv_preset3.setTextColor(ContextCompat.getColor(this, R.color.text_grey_to_white));
        this.tv_preset4.setTextColor(ContextCompat.getColor(this, R.color.text_grey_to_white));
        this.tv_preset5.setTextColor(ContextCompat.getColor(this, R.color.text_grey_to_white));
        this.tv_preset6.setTextColor(ContextCompat.getColor(this, R.color.text_grey_to_white));
        switch (i) {
            case 1:
                this.tv_preset1.setTextColor(ContextCompat.getColor(this, R.color.textColor));
                return;
            case 2:
                this.tv_preset2.setTextColor(ContextCompat.getColor(this, R.color.textColor));
                return;
            case 3:
                this.tv_preset3.setTextColor(ContextCompat.getColor(this, R.color.textColor));
                return;
            case 4:
                this.tv_preset4.setTextColor(ContextCompat.getColor(this, R.color.textColor));
                return;
            case 5:
                this.tv_preset5.setTextColor(ContextCompat.getColor(this, R.color.textColor));
                return;
            case 6:
                this.tv_preset6.setTextColor(ContextCompat.getColor(this, R.color.textColor));
                return;
            default:
                return;
        }
    }
}