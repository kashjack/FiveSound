package com.acv.radio.activity;

import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatCheckBox;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.LinearInterpolator;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.SeekBar;
import android.widget.TextView;
import com.acv.radio.Config;
import com.acv.radio.PrefsHelper;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.acv.radio.widget.AutoFixImageView;
import com.five.sound.R;
import java.util.Locale;

public class UsbActivity extends BaseHeadActivity {
    /* access modifiers changed from: private */
    public Button btn_next;
    private Button btn_play_mode;
    /* access modifiers changed from: private */
    public Button btn_prev;
    /* access modifiers changed from: private */
    public AppCompatCheckBox ckb_play;
    private long currentPlayTime;
    private AutoFixImageView img_disk;
    /* access modifiers changed from: private */
    public long mBtnNextDownTime;
    /* access modifiers changed from: private */
    public boolean mBtnNextHold = false;
    /* access modifiers changed from: private */
    public long mBtnPrevDownTime;
    /* access modifiers changed from: private */
    public boolean mBtnPrevHold = false;
    /* access modifiers changed from: private */
    public long mNextLastMoveTime;
    /* access modifiers changed from: private */
    public long mPrevLastMoveTime;
    /* access modifiers changed from: private */
    public boolean mShouldUpdateProgress = true;
    private int playModeIndex;
    private int[] playModes = {0, 1, 4};
    private ObjectAnimator rotateAnimation;
    private SeekBar seek_song;
    /* access modifiers changed from: private */
    public int totalTime;
    private TextView tv_album;
    private TextView tv_duration;
    private TextView tv_file_name;
    private TextView tv_position;
    private TextView tv_singer;
    private TextView tv_song_name;

    /* access modifiers changed from: protected */
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_usb);
        initView();
        init();
    }

    /* access modifiers changed from: protected */
    @SuppressLint({"ClickableViewAccessibility"})
    public void initView() {
        super.initView();
        setUiTitle(R.string.activity_usb_title);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setHomeAsUpIndicator((int) R.drawable.ic_back_home);
        }
        this.checkboxDisable[0] = false;
        this.checkboxDisable[1] = false;
        this.checkboxDisable[3] = false;
        this.checkboxDisable[4] = false;
        this.tv_singer = (TextView) findViewById(R.id.tv_singer);
        this.tv_song_name = (TextView) findViewById(R.id.tv_song_name);
        this.tv_album = (TextView) findViewById(R.id.tv_album);
        this.tv_file_name = (TextView) findViewById(R.id.tv_file_name);
        this.tv_position = (TextView) findViewById(R.id.tv_position);
        this.tv_duration = (TextView) findViewById(R.id.tv_duration);
        this.seek_song = (SeekBar) findViewById(R.id.seek_song);
        this.seek_song.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            public void onProgressChanged(SeekBar seekBar, int i, boolean z) {
            }

            public void onStartTrackingTouch(SeekBar seekBar) {
                boolean unused = UsbActivity.this.mShouldUpdateProgress = false;
            }

            public void onStopTrackingTouch(SeekBar seekBar) {
                int progress = seekBar.getProgress();
                int access$100 = (UsbActivity.this.totalTime * progress) / 100;
                Log.i("ACV_RADIO", "seek_song set play time:" + access$100 + ",progress:" + progress + ",total time:" + UsbActivity.this.totalTime);
                UsbActivity.this.sendCommand(Command.setPlayTime(access$100), true);
                boolean unused = UsbActivity.this.mShouldUpdateProgress = true;
            }
        });
        this.btn_play_mode = (Button) findViewById(R.id.btn_play_mode);
        this.img_disk = (AutoFixImageView) findViewById(R.id.img_disk);
        this.ckb_play = (AppCompatCheckBox) findViewById(R.id.ckb_play);
        this.ckb_play.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton compoundButton, boolean z) {
                if (UsbActivity.this.toggleByMan) {
                    UsbActivity.this.ckb_play.setChecked(!z);
                    UsbActivity.this.sendData(Command.playPause(Command.KEY_PRESS));
                }
            }
        });
        this.btn_prev = (Button) findViewById(R.id.btn_prev);
        this.btn_prev.setOnTouchListener(new View.OnTouchListener() {
            public boolean onTouch(View view, MotionEvent motionEvent) {
                if (motionEvent.getAction() == 0) {
                    long unused = UsbActivity.this.mBtnPrevDownTime = System.currentTimeMillis();
                    UsbActivity.this.btn_prev.setBackground(UsbActivity.this.getDrawable(R.drawable.btn_prev_pressed));
                } else if (motionEvent.getAction() == 2) {
                    long currentTimeMillis = System.currentTimeMillis();
                    if (UsbActivity.this.mBtnPrevHold || currentTimeMillis - UsbActivity.this.mBtnPrevDownTime > 500) {
                        boolean unused2 = UsbActivity.this.mBtnPrevHold = true;
                        if (currentTimeMillis - UsbActivity.this.mPrevLastMoveTime > 300) {
                            Log.i("ACV_RADIO", "btn_prev hold..");
                            UsbActivity.this.sendCommand(Command.prev(Command.KEY_HOLD), true);
                            long unused3 = UsbActivity.this.mPrevLastMoveTime = currentTimeMillis;
                        }
                    }
                } else if (motionEvent.getAction() == 1) {
                    if (UsbActivity.this.mBtnPrevHold) {
                        Log.i("ACV_RADIO", "btn_prev release..");
                        boolean unused4 = UsbActivity.this.mBtnPrevHold = false;
                        UsbActivity.this.sendCommand(Command.prev(Command.KEY_RELEASE), true);
                    } else {
                        Log.i("ACV_RADIO", "btn_prev click..");
                        UsbActivity.this.sendData(Command.prev(Command.KEY_PRESS));
                    }
                    UsbActivity.this.btn_prev.setBackground(UsbActivity.this.getDrawable(R.drawable.btn_prev_normal));
                    long unused5 = UsbActivity.this.mBtnPrevDownTime = 0;
                    long unused6 = UsbActivity.this.mPrevLastMoveTime = 0;
                }
                return true;
            }
        });
        this.btn_next = (Button) findViewById(R.id.btn_next);
        this.btn_next.setOnTouchListener(new View.OnTouchListener() {
            public boolean onTouch(View view, MotionEvent motionEvent) {
                if (motionEvent.getAction() == 0) {
                    long unused = UsbActivity.this.mBtnNextDownTime = System.currentTimeMillis();
                    UsbActivity.this.btn_next.setBackground(UsbActivity.this.getDrawable(R.drawable.btn_next_pressed));
                } else if (motionEvent.getAction() == 2) {
                    long currentTimeMillis = System.currentTimeMillis();
                    if (UsbActivity.this.mBtnNextHold || currentTimeMillis - UsbActivity.this.mBtnNextDownTime > 500) {
                        boolean unused2 = UsbActivity.this.mBtnNextHold = true;
                        if (currentTimeMillis - UsbActivity.this.mNextLastMoveTime > 300) {
                            Log.i("ACV_RADIO", "btn_next hold..");
                            UsbActivity.this.sendCommand(Command.next(Command.KEY_HOLD), true);
                            long unused3 = UsbActivity.this.mNextLastMoveTime = currentTimeMillis;
                        }
                    }
                } else if (motionEvent.getAction() == 1) {
                    if (UsbActivity.this.mBtnNextHold) {
                        Log.i("ACV_RADIO", "btn_next release..");
                        boolean unused4 = UsbActivity.this.mBtnNextHold = false;
                        UsbActivity.this.sendCommand(Command.next(Command.KEY_RELEASE), true);
                    } else {
                        Log.i("ACV_RADIO", "btn_next click..");
                        UsbActivity.this.sendData(Command.next(Command.KEY_PRESS));
                    }
                    UsbActivity.this.btn_next.setBackground(UsbActivity.this.getDrawable(R.drawable.btn_next_normal));
                    long unused5 = UsbActivity.this.mBtnNextDownTime = 0;
                    long unused6 = UsbActivity.this.mNextLastMoveTime = 0;
                }
                return true;
            }
        });
    }

    private void init() {
        updatePlayTotalTimeText(PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_PLAY_TOTAL_TIME, 0));
        updatePlayModeText(PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_PLAY_MODE));
        updateAlbumText(PrefsHelper.with(this, Config.PREF_NAME).read(Config.SP_KEY_ALBUM));
        updateSongTitleText(PrefsHelper.with(this, Config.PREF_NAME).read(Config.SP_KEY_SONG_NAME));
        updateArtistText(PrefsHelper.with(this, Config.PREF_NAME).read(Config.SP_KEY_ARTIST));
        updateSongFileName(PrefsHelper.with(this, Config.PREF_NAME).read(Config.SP_KEY_SONG_FILE_NAME));
    }

    /* access modifiers changed from: protected */
    public void onBleServiceConnected() {
        super.onBleServiceConnected();
        sendData(Command.getPlayPause());
        sendCommand(Command.getPlayTime(), true);
    }

    public void doClick(View view) {
        if (view.getId() == R.id.btn_play_mode) {
            int[] iArr = this.playModes;
            int i = this.playModeIndex + 1;
            this.playModeIndex = i;
            int i2 = iArr[i % 3];
            Log.i("ACV_RADIO", "set play mode:" + i2);
            sendData(Command.playMode(i2));
            updatePlayModeImage(i2);
        }
    }

    /* access modifiers changed from: protected */
    public void receiveData(BleNotifyData bleNotifyData) {
        super.receiveData(bleNotifyData);
        if (bleNotifyData != null) {
            Log.i("ACV_RADIO", "UsbActivity-->receiveData cmd:" + CommandParser.parseCmdStr(bleNotifyData.cmdH, bleNotifyData.cmdL) + ",data length:" + bleNotifyData.length);
            if (AnonymousClass5.$SwitchMap$com$acv$radio$bluetooth$CommandParser$CMD[bleNotifyData.cmd.ordinal()] == 1) {
                updatePlayPause(bleNotifyData);
            }
        }
    }

    /* renamed from: com.acv.radio.activity.UsbActivity$5  reason: invalid class name */
    static /* synthetic */ class AnonymousClass5 {
        static final /* synthetic */ int[] $SwitchMap$com$acv$radio$bluetooth$CommandParser$CMD = new int[CommandParser.CMD.values().length];

        static {
            try {
                $SwitchMap$com$acv$radio$bluetooth$CommandParser$CMD[CommandParser.CMD.GET_PLAY_PAUSE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
        }
    }

    private void updatePlayPause(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length != 1) {
            Log.e("ACV_RADIO", "UsbActivity GET_PLAY_PAUSE data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        boolean z = false;
        Command.logoutAllByte("UsbActivity GET_PLAY_PAUSE data: ", bArr, false);
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
    public void updateSongFileName(String str) {
        super.updateSongFileName(str);
        if (this.tv_file_name != null) {
            TextView textView = this.tv_file_name;
            if (str == null) {
                str = "";
            }
            textView.setText(str);
        }
    }

    /* access modifiers changed from: protected */
    public void updateArtistText(String str) {
        super.updateArtistText(str);
        if (this.tv_singer != null) {
            TextView textView = this.tv_singer;
            if (str == null) {
                str = "";
            }
            textView.setText(str);
        }
    }

    /* access modifiers changed from: protected */
    public void updateAlbumText(String str) {
        super.updateAlbumText(str);
        if (this.tv_album != null) {
            TextView textView = this.tv_album;
            if (str == null) {
                str = "";
            }
            textView.setText(str);
        }
    }

    /* access modifiers changed from: protected */
    public void updateSongTitleText(String str) {
        super.updateSongTitleText(str);
        if (this.tv_song_name != null) {
            TextView textView = this.tv_song_name;
            if (str == null) {
                str = "";
            }
            textView.setText(str);
        }
    }

    /* access modifiers changed from: protected */
    public void updatePlayTotalTimeText(int i) {
        super.updatePlayTotalTimeText(i);
        this.totalTime = i;
        int i2 = i / 3600;
        int i3 = i - (i2 * 3600);
        int i4 = i3 / 60;
        int i5 = i3 - (i4 * 60);
        if (this.tv_duration == null) {
            return;
        }
        if (i2 == 0) {
            this.tv_duration.setText(String.format(Locale.getDefault(), "%02d:%02d", new Object[]{Integer.valueOf(i4), Integer.valueOf(i5)}));
            return;
        }
        this.tv_duration.setText(String.format(Locale.getDefault(), "%d:%02d:%02d", new Object[]{Integer.valueOf(i2), Integer.valueOf(i4), Integer.valueOf(i5)}));
    }

    /* access modifiers changed from: protected */
    public void updatePlayModeText(int i) {
        super.updatePlayModeText(i);
        if (i == 0) {
            updatePlayModeImage(0);
            this.playModeIndex = 0;
        } else if (i == 1) {
            updatePlayModeImage(1);
            this.playModeIndex = 1;
        } else if (i == 4) {
            updatePlayModeImage(4);
            this.playModeIndex = 2;
        }
    }

    /* access modifiers changed from: protected */
    public void updatePlayTimeAndMode(int i, int i2) {
        int i3;
        super.updatePlayTimeAndMode(i, i2);
        int i4 = i / 3600;
        int i5 = i - (i4 * 3600);
        int i6 = i5 / 60;
        int i7 = i5 - (i6 * 60);
        if (this.tv_position != null) {
            if (i4 == 0) {
                this.tv_position.setText(String.format(Locale.getDefault(), "%02d:%02d", new Object[]{Integer.valueOf(i6), Integer.valueOf(i7)}));
            } else {
                this.tv_position.setText(String.format(Locale.getDefault(), "%d:%02d:%02d", new Object[]{Integer.valueOf(i4), Integer.valueOf(i6), Integer.valueOf(i7)}));
            }
        }
        if (this.totalTime > 0 && (i3 = (i * 100) / this.totalTime) >= 0 && i3 <= 100 && this.mShouldUpdateProgress && this.seek_song != null) {
            this.seek_song.setProgress(i3);
        }
        updatePlayModeText(i2);
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