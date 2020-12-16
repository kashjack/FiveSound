package com.acv.radio.activity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.acv.radio.widget.FadeBalance;
import com.acv.radio.widget.RangeSeekBar;
import com.five.sound.R;

public class FadeBalanceActivity extends BaseActivity {
    private int curBalance;
    private int curFade;
    private FadeBalance fadeBalance;
    /* access modifiers changed from: private */
    public int lastBalance;
    /* access modifiers changed from: private */
    public int lastFade;
    private int maxBalance;
    private int maxFade;
    /* access modifiers changed from: private */
    public RangeSeekBar range_balance;
    /* access modifiers changed from: private */
    public RangeSeekBar range_fade;

    /* access modifiers changed from: protected */
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_fade_balance);
        initView();
    }

    /* access modifiers changed from: protected */
    public void initView() {
        super.initView();
        setUiTitle(R.string.activity_fade_balance_title);
        this.range_fade = (RangeSeekBar) findViewById(R.id.range_fade);
        this.range_balance = (RangeSeekBar) findViewById(R.id.range_balance);
        this.fadeBalance = (FadeBalance) findViewById(R.id.fade_balance);
        this.fadeBalance.setOnValueChangeListener(new FadeBalance.OnValueChangeListener() {
            public void onValueChanging(float f, float f2) {
                Log.i("ACV_RADIO", "fadeBalance onValueChanging ratioW:" + f + ",ratioH:" + f2);
                if (FadeBalanceActivity.this.range_balance != null) {
                    FadeBalanceActivity.this.range_balance.setRatio(f);
                    int value = FadeBalanceActivity.this.range_balance.getValue();
                    if (value != FadeBalanceActivity.this.lastBalance) {
                        FadeBalanceActivity.this.sendCommand(Command.setBalance(value), false);
                        int unused = FadeBalanceActivity.this.lastBalance = value;
                    }
                }
                if (FadeBalanceActivity.this.range_fade != null) {
                    FadeBalanceActivity.this.range_fade.setRatio(f2);
                    int value2 = FadeBalanceActivity.this.range_fade.getValue();
                    if (value2 != FadeBalanceActivity.this.lastFade) {
                        FadeBalanceActivity.this.sendCommand(Command.setFade(value2), false);
                        int unused2 = FadeBalanceActivity.this.lastFade = value2;
                    }
                }
            }

            public void onValueChanged(float f, float f2) {
                Log.e("ACV_RADIO", "fadeBalance onValueChanged ratioW:" + f + ",ratioH:" + f2);
                if (FadeBalanceActivity.this.range_balance != null) {
                    FadeBalanceActivity.this.range_balance.setRatio(f);
                    int value = FadeBalanceActivity.this.range_balance.getValue();
                    int unused = FadeBalanceActivity.this.lastBalance = value;
                    FadeBalanceActivity.this.sendCommand(Command.setBalance(value), true);
                }
                if (FadeBalanceActivity.this.range_fade != null) {
                    FadeBalanceActivity.this.range_fade.setRatio(f2);
                    int value2 = FadeBalanceActivity.this.range_fade.getValue();
                    int unused2 = FadeBalanceActivity.this.lastFade = value2;
                    FadeBalanceActivity.this.sendCommand(Command.setFade(value2), true);
                }
            }
        });
        this.range_fade.setOnRangeSeekBarChangeListener(new RangeSeekBar.OnRangeSeekBarChangeListener() {
            public void onProgressChanged(int i) {
                Log.i("ACV_RADIO", "range_fade onProgressChanged progress:" + i + ",ratio:" + FadeBalanceActivity.this.range_fade.getRatio());
                FadeBalanceActivity.this.updateFadeBalanceUi();
                if (FadeBalanceActivity.this.lastFade != i) {
                    FadeBalanceActivity.this.sendCommand(Command.setFade(i), false);
                    int unused = FadeBalanceActivity.this.lastFade = i;
                }
            }

            public void onStopTrackingTouch(int i) {
                FadeBalanceActivity.this.updateFadeBalanceUi();
                FadeBalanceActivity.this.sendCommand(Command.setFade(i), true);
                int unused = FadeBalanceActivity.this.lastFade = i;
            }
        });
        this.range_balance.setOnRangeSeekBarChangeListener(new RangeSeekBar.OnRangeSeekBarChangeListener() {
            public void onProgressChanged(int i) {
                Log.i("ACV_RADIO", "range_balance onProgressChanged progress:" + i + ",ratio:" + FadeBalanceActivity.this.range_balance.getRatio());
                FadeBalanceActivity.this.updateFadeBalanceUi();
                if (FadeBalanceActivity.this.lastBalance != i) {
                    FadeBalanceActivity.this.sendCommand(Command.setBalance(i), false);
                    int unused = FadeBalanceActivity.this.lastBalance = i;
                }
            }

            public void onStopTrackingTouch(int i) {
                FadeBalanceActivity.this.updateFadeBalanceUi();
                FadeBalanceActivity.this.sendCommand(Command.setBalance(i), true);
                int unused = FadeBalanceActivity.this.lastBalance = i;
            }
        });
        this.range_balance.setValue(0);
        this.range_fade.setValue(0);
        updateFadeBalanceUi();
    }

    /* access modifiers changed from: protected */
    public void onBleServiceConnected() {
        super.onBleServiceConnected();
        sendData(Command.getBTBF());
    }

    /* access modifiers changed from: private */
    public void updateFadeBalanceUi() {
        if (this.fadeBalance != null) {
            this.fadeBalance.setRatio(this.range_balance.getRatio(), this.range_fade.getRatio());
        }
    }

    private void updateFadeUi(int i, int i2) {
        if (i2 > 0) {
            int i3 = i2 - i;
            if (this.range_fade != null) {
                this.range_fade.setRange(i2);
                this.range_fade.setValue(i3);
            }
            updateFadeBalanceUi();
        }
    }

    private void updateBalanceUi(int i, int i2) {
        if (i2 > 0) {
            if (this.range_balance != null) {
                this.range_balance.setRange(i2);
                this.range_balance.setValue(i);
            }
            updateFadeBalanceUi();
        }
    }

    /* access modifiers changed from: protected */
    public void receiveData(BleNotifyData bleNotifyData) {
        super.receiveData(bleNotifyData);
        if (bleNotifyData != null) {
            Log.i("ACV_RADIO", "FadeBalanceActivity-->receiveData cmd:" + CommandParser.parseCmdStr(bleNotifyData.cmdH, bleNotifyData.cmdL) + ",data length:" + bleNotifyData.length);
            switch (bleNotifyData.cmd) {
                case GET_BTBF:
                    updateFadeBalance(bleNotifyData);
                    return;
                case FADE:
                    updateFade(bleNotifyData);
                    return;
                case BALANCE:
                    updateBalance(bleNotifyData);
                    return;
                default:
                    return;
            }
        }
    }

    private void updateFadeBalance(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 8) {
            Log.e("ACV_RADIO", "FadeBalanceActivity GET_BTBF data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("FadeBalanceActivity GET_BTBF data: ", bArr, true);
        this.maxBalance = CommandParser.unsignedByteToInt(bArr[4]);
        this.curBalance = CommandParser.unsignedByteToInt(bArr[5]);
        this.maxFade = CommandParser.unsignedByteToInt(bArr[6]);
        this.curFade = CommandParser.unsignedByteToInt(bArr[7]);
        updateBalanceUi(this.curBalance, this.maxBalance);
        updateFadeUi(this.curFade, this.maxFade);
        Log.i("ACV_RADIO", "FadeBalanceActivity BALANCE maxBalance:" + this.maxBalance + ",curBalance:" + this.curBalance + ",maxFade:" + this.maxFade + ",curFade:" + this.curFade);
    }

    private void updateBalance(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 2) {
            Log.e("ACV_RADIO", "FadeBalanceActivity BALANCE data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("FadeBalanceActivity BALANCE data: ", bArr, true);
        this.maxBalance = CommandParser.unsignedByteToInt(bArr[0]);
        this.curBalance = CommandParser.unsignedByteToInt(bArr[1]);
        updateBalanceUi(this.curBalance, this.maxBalance);
        Log.i("ACV_RADIO", "FadeBalanceActivity BALANCE maxBalance:" + this.maxBalance + ",curBalance:" + this.curBalance);
    }

    private void updateFade(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 2) {
            Log.e("ACV_RADIO", "FadeBalanceActivity FADE data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("FadeBalanceActivity FADE data: ", bArr, true);
        this.maxFade = CommandParser.unsignedByteToInt(bArr[0]);
        this.curFade = CommandParser.unsignedByteToInt(bArr[1]);
        updateFadeUi(this.curFade, this.maxFade);
        Log.i("ACV_RADIO", "FadeBalanceActivity FADE maxFade:" + this.maxFade + ",curFade:" + this.curFade);
    }

    public void reset(View view) {
        if (this.range_balance != null) {
            this.range_balance.setRatio(0.5f);
            sendCommand(Command.setBalance(this.range_balance.getValue()), true);
        }
        if (this.range_fade != null) {
            this.range_fade.setRatio(0.5f);
            sendCommand(Command.setFade(this.range_fade.getValue()), true);
        }
        if (this.fadeBalance != null) {
            this.fadeBalance.setRatio(0.5f, 0.5f);
        }
    }
}