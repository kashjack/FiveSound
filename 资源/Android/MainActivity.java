package com.acv.radio.activity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;
import com.acv.radio.App;
import com.acv.radio.Config;
import com.acv.radio.PrefsHelper;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.five.sound.R;

public class MainActivity extends BaseActivity {
    public static final String SHOULD_GET_CALL_STATE = "get_call_state";
    private boolean inCalling;

    private void setCallStateImage(int i) {
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_main);
        initView();
        startBleService();
    }

    /* access modifiers changed from: protected */
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (intent != null) {
            Log.i("ACV_RADIO", "MainActivity onNewIntent inCalling:" + this.inCalling);
            updateCallState();
        }
    }

    /* access modifiers changed from: protected */
    public void onResume() {
        super.onResume();
        updateCallState();
    }

    private void updateCallState() {
        this.inCalling = PrefsHelper.with(this, Config.PREF_NAME).readBoolean(Config.SP_KEY_IN_CALLING, false);
        Log.i("ACV_RADIO", "MainActivity updateCallState inCalling:" + this.inCalling);
        if (this.inCalling) {
            sendData(Command.getCallState());
        } else {
            setCallStateImage(0);
        }
    }

    /* access modifiers changed from: protected */
    public void initView() {
        super.initView();
    }

    public void doClick(View view) {
        switch (view.getId()) {
            case R.id.btn_aux_in:
                if (!this.inCalling) {
                    if (!App.mBluetoothConnected) {
                        Toast.makeText(this, R.string.bluetooth_not_connected, 0).show();
                        return;
                    }
                    sendData(Command.selectMode(3));
                    gotoAuxActivity(false);
                    return;
                }
                return;
            case R.id.btn_bt_music:
                if (!this.inCalling) {
                    if (!App.mBluetoothConnected) {
                        Toast.makeText(this, R.string.bluetooth_not_connected, 0).show();
                        return;
                    }
                    sendData(Command.selectMode(4));
                    gotoMusicActivity(false);
                    return;
                }
                return;
            case R.id.btn_card:
                if (!this.inCalling) {
                    sendData(Command.selectMode(2));
                    return;
                }
                return;
            case R.id.btn_radio:
                if (!this.inCalling) {
                    if (!App.mBluetoothConnected) {
                        Toast.makeText(this, R.string.bluetooth_not_connected, 0).show();
                        return;
                    }
                    sendData(Command.selectMode(5));
                    gotoRadioActivity(false);
                    return;
                }
                return;
            case R.id.btn_usb:
                if (!this.inCalling) {
                    sendData(Command.selectMode(1));
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
            Log.i("ACV_RADIO", "MainActivity-->receiveData cmd:" + CommandParser.parseCmdStr(bleNotifyData.cmdH, bleNotifyData.cmdL) + ",data length:" + bleNotifyData.length);
            if (AnonymousClass1.$SwitchMap$com$acv$radio$bluetooth$CommandParser$CMD[bleNotifyData.cmd.ordinal()] == 1) {
                updateCallState(bleNotifyData);
            }
        }
    }

    /* renamed from: com.acv.radio.activity.MainActivity$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$acv$radio$bluetooth$CommandParser$CMD = new int[CommandParser.CMD.values().length];

        static {
            try {
                $SwitchMap$com$acv$radio$bluetooth$CommandParser$CMD[CommandParser.CMD.GET_CALL_STATUS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
        }
    }

    private void updateCallState(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("MainActivity GET_CALL_STATUS data: ", bArr, true);
            if (bleNotifyData.length == 1) {
                int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                if (unsignedByteToInt == 1) {
                    setCallStateImage(1);
                } else if (unsignedByteToInt == 2) {
                    setCallStateImage(2);
                }
            }
        } else {
            Log.e("ACV_RADIO", "MainActivity GET_CALL_STATUS data error..");
        }
    }
}