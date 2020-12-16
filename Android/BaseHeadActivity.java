package com.acv.radio.activity;

import android.content.Intent;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import com.acv.radio.Config;
import com.acv.radio.PrefsHelper;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.five.sound.R;

public class BaseHeadActivity extends BaseActivity {
    protected boolean[] checkboxDisable = {false, false, true, true, true, false};
    private ImageView img_eon;
    private ImageView img_loud;
    private ImageView img_sub;
    private ImageView img_user;
    protected boolean isLoud;
    protected boolean isSub;

    /* access modifiers changed from: protected */
    public void initView() {
        super.initView();
        this.img_sub = (ImageView) findViewById(R.id.img_sub);
        this.img_sub.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                BaseHeadActivity.this.isSub = !BaseHeadActivity.this.isSub;
                BaseHeadActivity.this.checkSubChanged(BaseHeadActivity.this.isSub);
            }
        });
        this.img_loud = (ImageView) findViewById(R.id.img_loud);
        this.img_loud.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                BaseHeadActivity.this.isLoud = !BaseHeadActivity.this.isLoud;
                BaseHeadActivity.this.checkLoudChanged(BaseHeadActivity.this.isLoud);
            }
        });
        this.img_eon = (ImageView) findViewById(R.id.img_eon);
        this.img_user = (ImageView) findViewById(R.id.img_user);
        this.img_user.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                BaseHeadActivity.this.gotoTrebleBassActivity();
            }
        });
        this.isSub = PrefsHelper.with(this, Config.PREF_NAME).readBoolean(Config.SP_KEY_SUB, false);
        updateSubState();
        this.isLoud = PrefsHelper.with(this, Config.PREF_NAME).readBoolean(Config.SP_KEY_LOUD, false);
        updateLoudState();
    }

    /* access modifiers changed from: protected */
    public void checkSubChanged(boolean z) {
        sendData(Command.setSub(z ? 1 : 0));
    }

    /* access modifiers changed from: protected */
    public void checkLoudChanged(boolean z) {
        sendData(Command.setLoud(z ? 1 : 0));
    }

    /* access modifiers changed from: protected */
    public void receiveData(BleNotifyData bleNotifyData) {
        super.receiveData(bleNotifyData);
        if (bleNotifyData != null) {
            switch (bleNotifyData.cmd) {
                case GET_LOUD:
                    updateLoud(bleNotifyData);
                    return;
                case GET_SUB:
                    updateSub(bleNotifyData);
                    return;
                default:
                    return;
            }
        }
    }

    public void btnEffectClick(View view) {
        startActivity(new Intent(this, FadeBalanceActivity.class));
    }

    private void updateSub(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte(" GET_SUB data: ", bArr, true);
            if (bleNotifyData.length == 1) {
                boolean z = false;
                if (CommandParser.unsignedByteToInt(bArr[0]) == 1) {
                    z = true;
                }
                this.isSub = z;
                PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_SUB, this.isSub);
                updateSubState();
                return;
            }
            return;
        }
        Log.e("ACV_RADIO", "GET_SUB data error..");
    }

    private void updateLoud(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte(" GET_LOUD data: ", bArr, true);
            if (bleNotifyData.length == 1) {
                boolean z = false;
                if (CommandParser.unsignedByteToInt(bArr[0]) == 1) {
                    z = true;
                }
                this.isLoud = z;
                PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_LOUD, this.isLoud);
                updateLoudState();
                return;
            }
            return;
        }
        Log.e("ACV_RADIO", "GET_LOUD data error..");
    }

    private void updateSubState() {
        if (this.img_sub == null) {
            return;
        }
        if (this.isSub) {
            this.img_sub.setImageDrawable(ContextCompat.getDrawable(this, R.drawable.ic_sub_checked));
        } else {
            this.img_sub.setImageDrawable(ContextCompat.getDrawable(this, R.drawable.ic_sub_normal));
        }
    }

    private void updateLoudState() {
        if (this.img_loud == null) {
            return;
        }
        if (this.isLoud) {
            this.img_loud.setImageDrawable(ContextCompat.getDrawable(this, R.drawable.ic_loud_checked));
        } else {
            this.img_loud.setImageDrawable(ContextCompat.getDrawable(this, R.drawable.ic_loud_normal));
        }
    }
}