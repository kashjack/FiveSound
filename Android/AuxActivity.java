package com.acv.radio.activity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import com.acv.radio.bluetooth.BleNotifyData;
import com.five.sound.R;

public class AuxActivity extends BaseHeadActivity {
    /* access modifiers changed from: protected */
    @Override // android.support.v4.app.SupportActivity, android.support.v7.app.AppCompatActivity, com.acv.radio.activity.BaseActivity, android.support.v4.app.FragmentActivity
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.activity_aux);
        initView();
    }

    /* access modifiers changed from: protected */
    @Override // com.acv.radio.activity.BaseHeadActivity, com.acv.radio.activity.BaseActivity
    public void initView() {
        super.initView();
        setUiTitle(R.string.activity_aux_title);
        this.checkboxDisable[0] = false;
        this.checkboxDisable[1] = false;
    }

    /* access modifiers changed from: protected */
    @Override // com.acv.radio.activity.BaseActivity
    public void onBleServiceConnected() {
        super.onBleServiceConnected();
    }

    /* access modifiers changed from: protected */
    @Override // com.acv.radio.activity.BaseHeadActivity, com.acv.radio.activity.BaseActivity
    public void receiveData(BleNotifyData bleNotifyData) {
        super.receiveData(bleNotifyData);
    }
}