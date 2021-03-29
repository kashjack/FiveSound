package com.acv.radio.activity;

import android.animation.ObjectAnimator;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatCheckBox;
import android.util.Log;
import android.view.View;
import android.view.animation.LinearInterpolator;
import android.widget.Button;
import android.widget.CompoundButton;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.acv.radio.widget.AutoFixImageView;
import com.five.sound.R;

public class MusicActivity extends BaseHeadActivity {
    private Button btn_play_mode;
    /* access modifiers changed from: private */
    public AppCompatCheckBox ckb_play;
    private long currentPlayTime;
    private AutoFixImageView img_disk;
    private int playModeIndex;
    private int[] playModes = {0, 1, 4};
    private ObjectAnimator rotateAnimation;

    /* access modifiers changed from: protected */
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_music);
        initView();
    }

    /* access modifiers changed from: protected */
    public void initView() {
        super.initView();
        setUiTitle(R.string.activity_music_title);
        this.img_disk = (AutoFixImageView) findViewById(R.id.img_disk);
        this.btn_play_mode = (Button) findViewById(R.id.btn_play_mode);
        this.ckb_play = (AppCompatCheckBox) findViewById(R.id.ckb_play);
        this.ckb_play.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton compoundButton, boolean z) {
                if (MusicActivity.this.toggleByMan) {
                    MusicActivity.this.ckb_play.setChecked(!z);
                    MusicActivity.this.sendData(Command.playPause(Command.KEY_PRESS));
                }
            }
        });
    }

    /* access modifiers changed from: protected */
    public void onBleServiceConnected() {
        super.onBleServiceConnected();
        sendData(Command.getPlayPause());
        sendCommand(Command.getPlayTime(), true);
    }

    /* access modifiers changed from: protected */
    public void receiveData(BleNotifyData bleNotifyData) {
        super.receiveData(bleNotifyData);
        if (bleNotifyData != null) {
            Log.i("ACV_RADIO", "MusicActivity-->receiveData cmd:" + CommandParser.parseCmdStr(bleNotifyData.cmdH, bleNotifyData.cmdL) + ",data length:" + bleNotifyData.length);
            switch (bleNotifyData.cmd) {
                case GET_PLAY_PAUSE:
                    updatePlayPause(bleNotifyData);
                    return;
                case PLAY_MODE:
                    updatePlayMode(bleNotifyData);
                    return;
                default:
                    return;
            }
        }
    }

    private void updatePlayPause(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 1) {
            Log.e("ACV_RADIO", "MusicActivity GET_PLAY_PAUSE data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        boolean z = false;
        Command.logoutAllByte("MusicActivity GET_PLAY_PAUSE data: ", bArr, false);
        int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
        if (this.ckb_play != null) {
            this.toggleByMan = false;
            AppCompatCheckBox appCompatCheckBox = this.ckb_play;
            if (unsignedByteToInt == 0) {
                z = true;
            }
            appCompatCheckBox.setChecked(z);
            this.toggleByMan = true;
            if (unsignedByteToInt == 0) {
                resumeRotate();
            } else {
                pauseRotate();
            }
        }
    }

    private void updatePlayMode(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("MusicActivity PLAY_MODE data: ", bArr, true);
            if (bleNotifyData.length == 1) {
                int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                if (unsignedByteToInt == 0) {
                    updatePlayModeImage(0);
                    this.playModeIndex = 0;
                } else if (unsignedByteToInt == 1) {
                    updatePlayModeImage(1);
                    this.playModeIndex = 1;
                } else if (unsignedByteToInt == 4) {
                    updatePlayModeImage(4);
                    this.playModeIndex = 2;
                }
            }
        } else {
            Log.e("ACV_RADIO", "MusicActivity PLAY_MODE data error..");
        }
    }

    public void doClick(View view) {
        switch (view.getId()) {
            case R.id.btn_next:
                sendData(Command.next(Command.KEY_PRESS));
                return;
            case R.id.btn_play_mode:
                int[] iArr = this.playModes;
                int i = this.playModeIndex + 1;
                this.playModeIndex = i;
                int i2 = iArr[i % 3];
                Log.i("ACV_RADIO", "set play mode:" + i2);
                sendData(Command.playMode(i2));
                updatePlayModeImage(i2);
                return;
            case R.id.btn_prev:
                sendData(Command.prev(Command.KEY_PRESS));
                return;
            default:
                return;
        }
    }

    private void updatePlayModeImage(int i) {
        if (this.btn_play_mode != null) {
            if (i != 4) {
                switch (i) {
                    case 0:
                        this.btn_play_mode.setBackgroundResource(R.drawable.ic_play_mode_list);
                        return;
                    case 1:
                        this.btn_play_mode.setBackgroundResource(R.drawable.ic_play_mode_only);
                        return;
                    default:
                        return;
                }
            } else {
                this.btn_play_mode.setBackgroundResource(R.drawable.ic_play_mode_random);
            }
        }
    }

    /* access modifiers changed from: protected */
    public void onDestroy() {
        super.onDestroy();
        stopRotate();
    }

    private void startRotate() {
        if (this.img_disk != null && this.rotateAnimation == null) {
            this.rotateAnimation = ObjectAnimator.ofFloat(this.img_disk, "rotation", new float[]{0.0f, 360.0f});
            this.rotateAnimation.setDuration(5000);
            this.rotateAnimation.setInterpolator(new LinearInterpolator());
            this.rotateAnimation.setRepeatCount(-1);
            this.rotateAnimation.start();
        }
    }

    public void pauseRotate() {
        if (this.rotateAnimation == null) {
            return;
        }
        if (Build.VERSION.SDK_INT >= 19) {
            if (!this.rotateAnimation.isPaused()) {
                this.rotateAnimation.pause();
            }
        } else if (this.rotateAnimation.isRunning()) {
            this.currentPlayTime = this.rotateAnimation.getCurrentPlayTime();
            this.rotateAnimation.cancel();
        }
    }

    private void resumeRotate() {
        if (this.rotateAnimation == null) {
            startRotate();
        } else if (Build.VERSION.SDK_INT >= 19) {
            if (this.rotateAnimation.isPaused()) {
                this.rotateAnimation.resume();
            }
        } else if (!this.rotateAnimation.isRunning()) {
            this.rotateAnimation.setCurrentPlayTime(this.currentPlayTime);
            this.rotateAnimation.start();
        }
    }

    public void stopRotate() {
        if (this.rotateAnimation != null) {
            this.rotateAnimation.end();
        }
    }
}