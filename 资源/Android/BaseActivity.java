package com.acv.radio.activity;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.support.annotation.StringRes;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.AppCompatCheckBox;
import android.text.TextUtils;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import com.acv.radio.App;
import com.acv.radio.Config;
import com.acv.radio.PrefsHelper;
import com.acv.radio.bluetooth.BleNotifyData;
import com.acv.radio.bluetooth.BleService;
import com.acv.radio.bluetooth.Command;
import com.acv.radio.bluetooth.CommandParser;
import com.five.sound.R;
import java.util.List;

public abstract class BaseActivity extends AppCompatActivity {
    protected final String TAG = "ACV_RADIO";
    protected AppCompatCheckBox ckb_connect_state;
    /* access modifiers changed from: private */
    public int lastVolume;
    protected BleService mBleService;
    protected ServiceConnection mBleServiceCon;
    protected BleService.ServiceFunction mBleServiceFun;
    protected String mPageName;
    private boolean mSongAlbumUpdated;
    private boolean mSongArtistUpdated;
    private boolean mSongTitleUpdated;
    protected SeekBar seek_volume;
    protected boolean toggleByMan = true;
    protected TextView tv_title;

    /* access modifiers changed from: protected */
    public void onBleServiceDisconnected() {
    }

    /* access modifiers changed from: protected */
    public void updateAlbumText(String str) {
    }

    /* access modifiers changed from: protected */
    public void updateArtistText(String str) {
    }

    /* access modifiers changed from: protected */
    public void updatePlayModeText(int i) {
    }

    /* access modifiers changed from: protected */
    public void updatePlayTimeAndMode(int i, int i2) {
    }

    /* access modifiers changed from: protected */
    public void updatePlayTotalTimeText(int i) {
    }

    /* access modifiers changed from: protected */
    public void updateSongFileName(String str) {
    }

    /* access modifiers changed from: protected */
    public void updateSongTitleText(String str) {
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        this.mPageName = getClass().getName();
        Log.i("ACV_RADIO", "BaseActivity mPageName:" + this.mPageName);
        bindBleService();
    }

    /* access modifiers changed from: protected */
    public void initView() {
        this.tv_title = (TextView) findViewById(R.id.tv_title);
        this.ckb_connect_state = (AppCompatCheckBox) findViewById(R.id.ckb_connect_state);
        if (this.ckb_connect_state != null) {
            this.ckb_connect_state.setOnClickListener(new View.OnClickListener() {
                public void onClick(View view) {
                    BaseActivity.this.ckb_connect_state.setChecked(!BaseActivity.this.ckb_connect_state.isChecked());
                    if (BaseActivity.this instanceof MainActivity) {
                        BaseActivity.this.gotoSearchActivity("");
                    }
                }
            });
        }
        this.seek_volume = (SeekBar) findViewById(R.id.seek_volume);
        if (this.seek_volume != null) {
            this.seek_volume.setMax(App.maxVolume == 0 ? 100 : App.maxVolume);
            if (App.curVolume < 0) {
                App.curVolume = 0;
            } else if (App.curVolume > App.maxVolume) {
                App.curVolume = App.maxVolume;
            }
            this.seek_volume.setProgress(App.curVolume);
            this.seek_volume.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                public void onStartTrackingTouch(SeekBar seekBar) {
                }

                public void onProgressChanged(SeekBar seekBar, int i, boolean z) {
                    if (z) {
                        Log.i("ACV_RADIO", "seek_volume set volume:" + i + ",maxVolume:" + App.maxVolume);
                        if (i != BaseActivity.this.lastVolume) {
                            BaseActivity.this.sendCommand(Command.setVolume(i), false);
                            int unused = BaseActivity.this.lastVolume = i;
                        }
                    }
                }

                public void onStopTrackingTouch(SeekBar seekBar) {
                    int progress = seekBar.getProgress();
                    BaseActivity.this.sendCommand(Command.setVolume(progress), true);
                    int unused = BaseActivity.this.lastVolume = progress;
                }
            });
        }
    }

    /* access modifiers changed from: protected */
    public void gotoSearchActivity(String str) {
        Intent intent = new Intent(this, SearchActivity.class);
        intent.putExtra(SearchActivity.INTENT_KEY_AUTO_CONNECT_ADDRESS, str);
        intent.addFlags(67108864);
        startActivity(intent);
    }

    /* access modifiers changed from: protected */
    public void setUiTitle(@StringRes int i) {
        if (this.tv_title != null) {
            this.tv_title.setText(i);
        }
    }

    /* access modifiers changed from: protected */
    public void setConnectState(boolean z) {
        if (this.ckb_connect_state != null) {
            this.ckb_connect_state.setChecked(z);
        }
    }

    /* access modifiers changed from: protected */
    public void onResume() {
        super.onResume();
        setConnectState(App.mBluetoothConnected);
        if (App.mBluetoothConnected) {
            sendData(Command.getVolume());
        }
        if (App.fromBackground && App.mBluetoothConnected) {
            App.fromBackground = false;
            navigation(PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_MODE));
        }
    }

    /* access modifiers changed from: protected */
    public void onDestroy() {
        super.onDestroy();
        if (this.mBleService != null) {
            unbindBleService();
        }
    }

    public boolean onOptionsItemSelected(MenuItem menuItem) {
        if (menuItem.getItemId() == 16908332) {
            finish();
        }
        return super.onOptionsItemSelected(menuItem);
    }

    public void updateVolume(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length < 2) {
            Log.e("ACV_RADIO", "GET_VOL data error..");
            return;
        }
        Command.logoutAllByte("GET_VOL data: ", bleNotifyData.data, true);
        App.maxVolume = CommandParser.unsignedByteToInt(bleNotifyData.data[0]);
        App.curVolume = CommandParser.unsignedByteToInt(bleNotifyData.data[1]);
        if (App.maxVolume > 0 && App.curVolume >= 0 && App.curVolume <= App.maxVolume && this.seek_volume != null) {
            this.seek_volume.setMax(App.maxVolume);
            this.seek_volume.setProgress(App.curVolume);
        }
    }

    public void backHome(View view) {
        finish();
    }

    /* access modifiers changed from: protected */
    public void bindBleService() {
        this.mBleServiceFun = new BleService.ServiceFunction() {
            public void onDeviceConnected() {
            }

            public void onDeviceReady() {
                App.mBluetoothConnected = true;
                BaseActivity.this.runOnUiThread(new Runnable() {
                    public void run() {
                        BaseActivity.this.getInitStatus();
                        BaseActivity.this.deviceReady();
                    }
                });
            }

            public void onDeviceDisconnected() {
                App.mBluetoothConnected = false;
                BaseActivity.this.runOnUiThread(new Runnable() {
                    public void run() {
                        BaseActivity.this.deviceDisconnected();
                    }
                });
            }

            public void onReceiveData(final BleNotifyData bleNotifyData) {
                BaseActivity.this.runOnUiThread(new Runnable() {
                    public void run() {
                        BaseActivity.this.receiveData(bleNotifyData);
                    }
                });
            }
        };
        Intent intent = new Intent(this, BleService.class);
        this.mBleServiceCon = new ServiceConnection() {
            public void onServiceDisconnected(ComponentName componentName) {
            }

            public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
                if (componentName.getClassName().equals(BleService.SERVICE_NAME)) {
                    BaseActivity.this.mBleService = ((BleService.LocalBinder) iBinder).getService();
                    if (!(BaseActivity.this.mBleService == null || BaseActivity.this.mBleServiceFun == null || BaseActivity.this.mPageName == null)) {
                        BaseActivity.this.mBleService.addServiceFunction(BaseActivity.this.mPageName, BaseActivity.this.mBleServiceFun);
                    }
                    BaseActivity.this.onBleServiceConnected();
                }
            }
        };
        bindService(intent, this.mBleServiceCon, 1);
    }

    /* access modifiers changed from: protected */
    public void unbindBleService() {
        if (this.mBleServiceCon != null && Build.VERSION.SDK_INT >= 18) {
            unbindService(this.mBleServiceCon);
            if (!(this.mBleService == null || this.mPageName == null)) {
                this.mBleService.removeServiceFunction(this.mPageName);
            }
            onBleServiceDisconnected();
            this.mBleService = null;
            this.mBleServiceCon = null;
        }
    }

    /* access modifiers changed from: protected */
    public void startBleService() {
        startService(new Intent(this, BleService.class));
    }

    /* access modifiers changed from: protected */
    public void stopBleService() {
        stopService(new Intent(this, BleService.class));
    }

    /* access modifiers changed from: private */
    public void getInitStatus() {
        sendData(Command.getVolume());
    }

    /* access modifiers changed from: protected */
    public void deviceReady() {
        setConnectState(true);
        Toast.makeText(this, R.string.bluetooth_connected, 0).show();
        if (this.mBleService != null && this.mBleService.getConnectedDevice() != null) {
            String address = this.mBleService.getConnectedDevice().getAddress();
            if (!TextUtils.isEmpty(address)) {
                PrefsHelper.with(this, Config.PREF_NAME).write(Config.SP_KEY_DEVICE_MAC, address);
                App.reconnectTimes = 0;
            }
        }
    }

    /* access modifiers changed from: protected */
    public void deviceDisconnected() {
        setConnectState(false);
        PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_IN_CALLING, false);
        gotoMainActivity(true, false);
        Toast.makeText(this, R.string.bluetooth_not_connected, 0).show();
        reconnect();
    }

    /* access modifiers changed from: protected */
    public void reconnect() {
        if (App.reconnectTimes < 3) {
            String read = PrefsHelper.with(this, Config.PREF_NAME).read(Config.SP_KEY_DEVICE_MAC);
            if (!TextUtils.isEmpty(read) && read.length() > 10) {
                gotoSearchActivity(read);
                App.reconnectTimes++;
            }
        }
    }

    /* access modifiers changed from: protected */
    public void receiveData(BleNotifyData bleNotifyData) {
        byte[] bArr;
        byte[] bArr2;
        if (bleNotifyData != null) {
            Log.i("ACV_RADIO", "BaseActivity-->receiveData cmd:" + CommandParser.parseCmdStr(bleNotifyData.cmdH, bleNotifyData.cmdL) + ",data length:" + bleNotifyData.length);
            switch (bleNotifyData.cmd) {
                case GET_VOL:
                    updateVolume(bleNotifyData);
                    return;
                case SELECT_MODE:
                case GET_MODE:
                    if (bleNotifyData.length >= 1 && (bArr = bleNotifyData.data) != null && bArr.length != 0) {
                        int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                        Log.i("ACV_RADIO", "MainActivity-->receiveData mode:" + unsignedByteToInt);
                        if (unsignedByteToInt >= 0 && unsignedByteToInt < 6) {
                            PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_MODE, unsignedByteToInt);
                            PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_IN_CALLING, false);
                        }
                        Log.i("ACV_RADIO", "MainActivity-->receiveData mode redefine:" + unsignedByteToInt);
                        navigation(unsignedByteToInt);
                        return;
                    }
                    return;
                case CALL_STATUS:
                    if (bleNotifyData.length == 1 && (bArr2 = bleNotifyData.data) != null && bArr2.length != 0) {
                        int unsignedByteToInt2 = CommandParser.unsignedByteToInt(bArr2[0]);
                        Log.i("ACV_RADIO", "BaseActivity-->CALL_STATUS receiveData mode:" + unsignedByteToInt2);
                        if (unsignedByteToInt2 != 254) {
                            switch (unsignedByteToInt2) {
                                case 0:
                                    if (PrefsHelper.with(this, Config.PREF_NAME).readBoolean(Config.SP_KEY_IN_CALLING, false)) {
                                        PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_IN_CALLING, false);
                                        gotoMusicActivity(false);
                                        return;
                                    }
                                    PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_IN_CALLING, false);
                                    return;
                                case 1:
                                case 2:
                                case 3:
                                    PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_IN_CALLING, true);
                                    if (App.isForeground) {
                                        gotoMainActivity(true, true);
                                        return;
                                    }
                                    return;
                                default:
                                    return;
                            }
                        } else {
                            PrefsHelper.with(this, Config.PREF_NAME).writeBoolean(Config.SP_KEY_IN_CALLING, false);
                            return;
                        }
                    } else {
                        return;
                    }
                case GET_PLAY_TIME:
                    updatePlayTime(bleNotifyData);
                    return;
                case GET_PLAY_TOTAL_TIME:
                    updateTotalTime(bleNotifyData);
                    return;
                case PLAY_MODE:
                    updatePlayMode(bleNotifyData);
                    return;
                case CUR_ALBUM:
                    updateAlbum(bleNotifyData);
                    return;
                case CUR_TITLE:
                    updateSongTitle(bleNotifyData);
                    return;
                case CUR_ARTIST:
                    updateArtist(bleNotifyData);
                    return;
                case CUR_FILE_NAME:
                    updateFileName(bleNotifyData);
                    return;
                default:
                    return;
            }
        }
    }

    private void navigation(int i) {
        switch (i) {
            case 1:
                gotoUsbActivity(true);
                return;
            case 2:
                gotoCardActivity(true);
                return;
            case 3:
                gotoAuxActivity(true);
                return;
            case 4:
                gotoMusicActivity(true);
                return;
            case 5:
                gotoRadioActivity(true);
                return;
            default:
                return;
        }
    }

    private void updatePlayTime(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data == null || bleNotifyData.length <= 2) {
            Log.e("ACV_RADIO", "UsbActivity GET_PLAY_TIME data error..");
            return;
        }
        byte[] bArr = bleNotifyData.data;
        Command.logoutAllByte("UsbActivity GET_PLAY_TIME data: ", bArr, true);
        int unsignedBytesToInt = CommandParser.unsignedBytesToInt(bArr[1], bArr[0]);
        int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[2]);
        PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_PLAY_MODE, unsignedByteToInt);
        updatePlayTimeAndMode(unsignedBytesToInt, unsignedByteToInt);
    }

    private void updateTotalTime(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("BaseActivity GET_PLAY_TOTAL_TIME data: ", bArr, true);
            int unsignedBytesArrayToInt = CommandParser.unsignedBytesArrayToInt(bArr, true);
            PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_PLAY_TOTAL_TIME, unsignedBytesArrayToInt);
            updatePlayTotalTimeText(unsignedBytesArrayToInt);
            return;
        }
        Log.e("ACV_RADIO", "BaseActivity GET_PLAY_TOTAL_TIME data error..");
    }

    private void updatePlayMode(BleNotifyData bleNotifyData) {
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("BaseActivity PLAY_MODE data: ", bArr, true);
            if (bleNotifyData.length == 1) {
                int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                PrefsHelper.with(this, Config.PREF_NAME).writeInt(Config.SP_KEY_PLAY_MODE, unsignedByteToInt);
                updatePlayModeText(unsignedByteToInt);
                return;
            }
            return;
        }
        Log.e("ACV_RADIO", "BaseActivity PLAY_MODE data error..");
    }

    private void updateAlbum(BleNotifyData bleNotifyData) {
        this.mSongAlbumUpdated = true;
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("BaseActivity CUR_ALBUM data: ", bArr, false);
            if (bArr.length > 0) {
                int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                byte[] bArr2 = new byte[(bArr.length - 1)];
                System.arraycopy(bArr, 1, bArr2, 0, bArr2.length);
                String bytesToString = CommandParser.bytesToString(bArr2, unsignedByteToInt);
                PrefsHelper.with(this, Config.PREF_NAME).write(Config.SP_KEY_ALBUM, bytesToString);
                updateAlbumText(bytesToString);
                return;
            }
        } else {
            Log.e("ACV_RADIO", "BaseActivity CUR_ALBUM data error..");
        }
        updateAlbumText("");
    }

    private void updateSongTitle(BleNotifyData bleNotifyData) {
        this.mSongTitleUpdated = true;
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("BaseActivity CUR_TITLE data: ", bArr, false);
            if (bArr.length > 0) {
                int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                byte[] bArr2 = new byte[(bArr.length - 1)];
                System.arraycopy(bArr, 1, bArr2, 0, bArr2.length);
                String bytesToString = CommandParser.bytesToString(bArr2, unsignedByteToInt);
                PrefsHelper.with(this, Config.PREF_NAME).write(Config.SP_KEY_SONG_NAME, bytesToString);
                updateSongTitleText(bytesToString);
                return;
            }
        } else {
            Log.e("ACV_RADIO", "BaseActivity CUR_TITLE data error..");
        }
        updateSongTitleText("");
    }

    private void updateArtist(BleNotifyData bleNotifyData) {
        this.mSongArtistUpdated = true;
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("BaseActivity CUR_ARTIST data: ", bArr, false);
            if (bArr.length > 0) {
                int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                byte[] bArr2 = new byte[(bArr.length - 1)];
                System.arraycopy(bArr, 1, bArr2, 0, bArr2.length);
                String bytesToString = CommandParser.bytesToString(bArr2, unsignedByteToInt);
                PrefsHelper.with(this, Config.PREF_NAME).write(Config.SP_KEY_ARTIST, bytesToString);
                updateArtistText(bytesToString);
                return;
            }
        } else {
            Log.e("ACV_RADIO", "BaseActivity CUR_ARTIST data error..");
        }
        updateArtistText("");
    }

    private void updateFileName(BleNotifyData bleNotifyData) {
        if (!this.mSongTitleUpdated) {
            updateSongTitleText("");
        }
        if (!this.mSongArtistUpdated) {
            updateArtistText("");
        }
        if (!this.mSongAlbumUpdated) {
            updateAlbumText("");
        }
        this.mSongTitleUpdated = false;
        this.mSongArtistUpdated = false;
        this.mSongAlbumUpdated = false;
        if (bleNotifyData.data != null) {
            byte[] bArr = bleNotifyData.data;
            Command.logoutAllByte("BaseActivity CUR_FILE_NAME data: ", bArr, false);
            if (bArr.length > 0) {
                int unsignedByteToInt = CommandParser.unsignedByteToInt(bArr[0]);
                byte[] bArr2 = new byte[(bArr.length - 1)];
                System.arraycopy(bArr, 1, bArr2, 0, bArr2.length);
                String bytesToString = CommandParser.bytesToString(bArr2, unsignedByteToInt);
                PrefsHelper.with(this, Config.PREF_NAME).write(Config.SP_KEY_SONG_FILE_NAME, bytesToString);
                updateSongFileName(bytesToString);
                return;
            }
        } else {
            Log.e("ACV_RADIO", "BaseActivity CUR_FILE_NAME data error..");
        }
        updateSongFileName("");
    }

    private void gotoMainActivity(boolean z, boolean z2) {
        Intent intent = new Intent(this, MainActivity.class);
        intent.putExtra(MainActivity.SHOULD_GET_CALL_STATE, z2);
        intent.addFlags(67108864);
        startActivity(intent);
        if (z && isNotMainActivity()) {
            finish();
        }
    }

    private boolean isNotMainActivity() {
        return !(this instanceof MainActivity);
    }

    /* access modifiers changed from: protected */
    public void gotoRadioActivity(boolean z) {
        if (this instanceof RadioActivity) {
            Log.i("ACV_RADIO", "gotoRadioActivity instanceof RadioActivity");
        } else if (!isTopActivity(RadioActivity.class.getName()) && App.isForeground) {
            Intent intent = new Intent(this, RadioActivity.class);
            intent.addFlags(67108864);
            startActivity(intent);
            if (z && isNotMainActivity()) {
                finish();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void gotoMusicActivity(boolean z) {
        if (this instanceof MusicActivity) {
            Log.i("ACV_RADIO", "gotoMusicActivity instanceof MusicActivity");
        } else if (!isTopActivity(MusicActivity.class.getName()) && App.isForeground && PrefsHelper.with(this, Config.PREF_NAME).readInt(Config.SP_KEY_MODE, 0) == 4) {
            Intent intent = new Intent(this, MusicActivity.class);
            intent.addFlags(67108864);
            startActivity(intent);
            if (z && isNotMainActivity()) {
                finish();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void gotoUsbActivity(boolean z) {
        if (this instanceof UsbActivity) {
            Log.i("ACV_RADIO", "gotoUsbActivity instanceof UsbActivity");
        } else if (!isTopActivity(UsbActivity.class.getName()) && App.isForeground) {
            Intent intent = new Intent(this, UsbActivity.class);
            intent.addFlags(67108864);
            startActivity(intent);
            if (z && isNotMainActivity()) {
                finish();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void gotoCardActivity(boolean z) {
        if (this instanceof CardActivity) {
            Log.i("ACV_RADIO", "gotoCardActivity instanceof CardActivity");
        } else if (!isTopActivity(CardActivity.class.getName()) && App.isForeground) {
            Intent intent = new Intent(this, CardActivity.class);
            intent.addFlags(67108864);
            startActivity(intent);
            if (z && isNotMainActivity()) {
                finish();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void gotoAuxActivity(boolean z) {
        if (this instanceof AuxActivity) {
            Log.i("ACV_RADIO", "gotoAuxActivity instanceof AuxActivity");
        } else if (!isTopActivity(AuxActivity.class.getName()) && App.isForeground) {
            Intent intent = new Intent(this, AuxActivity.class);
            intent.addFlags(67108864);
            startActivity(intent);
            if (z && isNotMainActivity()) {
                finish();
            }
        }
    }

    private boolean isTopActivity(String str) {
        List<ActivityManager.RunningTaskInfo> runningTasks;
        ComponentName componentName;
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        Log.i("ACV_RADIO", "isTopActivity activityName:" + str);
        ActivityManager activityManager = (ActivityManager) getSystemService("activity");
        if (activityManager == null || (runningTasks = activityManager.getRunningTasks(1)) == null || runningTasks.size() <= 0 || (componentName = runningTasks.get(0).topActivity) == null) {
            return false;
        }
        Log.i("ACV_RADIO", "isTopActivity componentName.getClassName():" + componentName.getClassName());
        return str.equals(componentName.getClassName());
    }

    /* access modifiers changed from: protected */
    public void gotoTrebleBassActivity() {
        startActivity(new Intent(this, TrebleBassActivity.class));
    }

    /* access modifiers changed from: protected */
    public void onBleServiceConnected() {
        getInitStatus();
    }

    /* access modifiers changed from: protected */
    public void sendData(byte[] bArr) {
        if (!App.mBluetoothConnected) {
            Toast.makeText(this, R.string.bluetooth_not_connected, 0).show();
        } else if (this.mBleService != null) {
            this.mBleService.write(bArr, true, false);
        }
    }

    /* access modifiers changed from: protected */
    public void sendCommand(byte[] bArr, boolean z) {
        Command.logoutAllByte("sendCommand bytes:", bArr, false);
        if (!App.mBluetoothConnected) {
            Toast.makeText(this, R.string.bluetooth_not_connected, 0).show();
        } else if (this.mBleService != null) {
            this.mBleService.write(bArr, false, z);
        }
    }
}