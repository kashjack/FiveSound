package com.acv.radio.activity;

import android.annotation.TargetApi;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.Intent;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import com.acv.radio.Config;
import com.acv.radio.DeviceListAdapter;
import com.acv.radio.PrefsHelper;
import com.acv.radio.ThreadManager;
import com.acv.radio.scanner.BluetoothLeScannerCompat;
import com.acv.radio.scanner.ExtendedBluetoothDevice;
import com.acv.radio.scanner.ScanCallback;
import com.acv.radio.scanner.ScanFilter;
import com.acv.radio.scanner.ScanResult;
import com.acv.radio.scanner.ScanSettings;
import com.five.sound.R;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

public class SearchActivity extends BaseActivity implements DeviceListAdapter.OnDisconnectClickListener {
    public static final String INTENT_KEY_AUTO_CONNECT_ADDRESS = "autoConnectAddress";
    private static final int MSG_CONNECTING = 105;
    public static final int REQUEST_ENABLE_BLUETOOTH = 21;
    public static final int REQUEST_ENABLE_GPS = 20;
    private static final String TAG = "SearchActivity";
    private final int REQUEST_PERMISSION = 16;
    /* access modifiers changed from: private */
    public DeviceListAdapter adapter;
    /* access modifiers changed from: private */
    public String autoConnectAddress = null;
    private ImageView btn_bluetooth_scan;
    private final String[] connectingText = {"connecting", "connecting.", "connecting..", "connecting..."};
    private ListView listView;
    /* access modifiers changed from: private */
    public boolean mIsScanning;
    private ScanCallback mScanCallback;
    private MyHandler myHandler;
    private int textIndex;
    private TextView tv_connect_status;

    public static class MyHandler extends Handler {
        private WeakReference<SearchActivity> mActivity;

        public MyHandler(SearchActivity searchActivity) {
            this.mActivity = new WeakReference<>(searchActivity);
        }

        public void handleMessage(Message message) {
            SearchActivity searchActivity;
            if (message.what == 105 && (searchActivity = (SearchActivity) this.mActivity.get()) != null) {
                searchActivity.updateConnectingText();
                searchActivity.getHandler().sendEmptyMessageDelayed(105, 500);
            }
            super.handleMessage(message);
        }
    }

    /* access modifiers changed from: private */
    public void updateConnectingText() {
        this.textIndex++;
        if (this.tv_connect_status != null) {
            this.tv_connect_status.setText(this.connectingText[this.textIndex % this.connectingText.length]);
        }
    }

    public MyHandler getHandler() {
        if (this.myHandler == null) {
            this.myHandler = new MyHandler(this);
        }
        return this.myHandler;
    }

    /* access modifiers changed from: protected */
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_search);
        Intent intent = getIntent();
        if (intent != null) {
            this.autoConnectAddress = intent.getStringExtra(INTENT_KEY_AUTO_CONNECT_ADDRESS);
        }
        initView();
        initPermission();
    }

    /* access modifiers changed from: protected */
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (intent != null) {
            this.autoConnectAddress = intent.getStringExtra(INTENT_KEY_AUTO_CONNECT_ADDRESS);
            if (this.autoConnectAddress != null && this.autoConnectAddress.length() > 10 && this.btn_bluetooth_scan != null) {
                this.btn_bluetooth_scan.performClick();
            }
        }
    }

    private void initPermission() {
        ArrayList arrayList = new ArrayList();
        for (String str : new String[]{"android.permission.ACCESS_COARSE_LOCATION", "android.permission.ACCESS_FINE_LOCATION"}) {
            if (ContextCompat.checkSelfPermission(this, str) != 0) {
                arrayList.add(str);
            }
        }
        if (arrayList.size() > 0) {
            ActivityCompat.requestPermissions(this, (String[]) arrayList.toArray(new String[arrayList.size()]), 16);
        } else {
            openOrSearchBluetooth();
        }
    }

    public void onRequestPermissionsResult(int i, @NonNull String[] strArr, int[] iArr) {
        if (i == 16 && iArr != null && iArr.length > 0) {
            if (iArr[0] == 0) {
                openOrSearchBluetooth();
            } else {
                Toast.makeText(this, R.string.bluetooth_denied, 0).show();
            }
        }
    }

    /* access modifiers changed from: protected */
    public void initView() {
        super.initView();
        setUiTitle(R.string.activity_search_title);
        this.listView = (ListView) findViewById(R.id.listView);
        this.adapter = new DeviceListAdapter(this, this);
        this.listView.setAdapter(this.adapter);
        this.listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
                BluetoothDevice bluetoothDevice = SearchActivity.this.adapter.getBluetoothDevice(i);
                if (SearchActivity.this.mBleService != null) {
                    BluetoothDevice connectedDevice = SearchActivity.this.mBleService.getConnectedDevice();
                    if (connectedDevice == null || !connectedDevice.equals(bluetoothDevice)) {
                        SearchActivity.this.mBleService.disconnectDevice();
                        if (bluetoothDevice != null) {
                            SearchActivity.this.mBleService.connectDevice(bluetoothDevice);
                            SearchActivity.this.adapter.updateDeviceConnectStatus(bluetoothDevice.getAddress(), true);
                            SearchActivity.this.getHandler().sendEmptyMessage(105);
                            return;
                        }
                        return;
                    }
                    SearchActivity.this.deviceReady();
                }
            }
        });
        this.tv_connect_status = (TextView) findViewById(R.id.tv_connect_status);
        this.btn_bluetooth_scan = (ImageView) findViewById(R.id.btn_bluetooth_scan);
        this.btn_bluetooth_scan.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                SearchActivity.this.openOrSearchBluetooth();
            }
        });
    }

    /* access modifiers changed from: protected */
    public void onDestroy() {
        super.onDestroy();
        if (this.myHandler != null) {
            this.myHandler.removeCallbacksAndMessages((Object) null);
        }
        this.myHandler = null;
    }

    /* access modifiers changed from: protected */
    public void onBleServiceConnected() {
        BluetoothDevice connectedDevice;
        super.onBleServiceConnected();
        if (this.mBleService != null && (connectedDevice = this.mBleService.getConnectedDevice()) != null) {
            this.adapter.addConnectedDevice(connectedDevice);
        }
    }

    /* access modifiers changed from: private */
    public void openOrSearchBluetooth() {
        if (isBluetoothReady()) {
            search("", 12000);
        } else {
            openBluetooth();
        }
    }

    public void onDisconnectClick(BluetoothDevice bluetoothDevice, int i) {
        stopScan();
        if (this.mBleService != null) {
            if (bluetoothDevice != null) {
                this.adapter.updateDeviceConnectStatus(bluetoothDevice.getAddress(), false);
            }
            this.mBleService.disconnectDevice();
            PrefsHelper.with(this, Config.PREF_NAME).write(Config.SP_KEY_DEVICE_MAC, "");
        }
    }

    /* access modifiers changed from: protected */
    public void deviceReady() {
        BluetoothDevice connectedDevice;
        super.deviceReady();
        getHandler().removeMessages(105);
        if (this.tv_connect_status != null) {
            this.tv_connect_status.setText(R.string.connected);
        }
        if (!(this.mBleService == null || (connectedDevice = this.mBleService.getConnectedDevice()) == null)) {
            this.adapter.updateDeviceConnectStatus(connectedDevice.getAddress(), true);
        }
        ThreadManager.getMainHandler().postDelayed(new Runnable() {
            public void run() {
                SearchActivity.this.finish();
            }
        }, 1000);
    }

    /* access modifiers changed from: protected */
    public void deviceDisconnected() {
        BluetoothDevice connectedDevice;
        super.deviceDisconnected();
        if (!(this.mBleService == null || (connectedDevice = this.mBleService.getConnectedDevice()) == null)) {
            this.adapter.updateDeviceConnectStatus(connectedDevice.getAddress(), false);
        }
        getHandler().removeMessages(105);
        if (this.tv_connect_status != null) {
            this.tv_connect_status.setText(R.string.disconnected);
        }
    }

    /* access modifiers changed from: protected */
    public void onPause() {
        super.onPause();
        stopScan();
    }

    /* access modifiers changed from: protected */
    public boolean isBluetoothReady() {
        if (!isBleEnabled()) {
            return false;
        }
        if (Build.VERSION.SDK_INT >= 23) {
            return isGpsEnable();
        }
        return true;
    }

    /* access modifiers changed from: protected */
    public void openBluetooth() {
        if (!isBleEnabled()) {
            requestBlueTooth();
        } else if (Build.VERSION.SDK_INT < 23) {
            bluetoothIsReady();
        } else if (isGpsEnable()) {
            bluetoothIsReady();
        } else {
            Log.i(TAG, "openBluetooth-->enableGPS");
            Toast.makeText(this, getString(R.string.heart_rate_ble_must_with_gps), 0).show();
            enableGPS();
        }
    }

    @TargetApi(18)
    public boolean isBleEnabled() {
        BluetoothAdapter adapter2;
        if (Build.VERSION.SDK_INT < 18 || (adapter2 = ((BluetoothManager) getSystemService("bluetooth")).getAdapter()) == null || !adapter2.isEnabled()) {
            return false;
        }
        return true;
    }

    public void requestBlueTooth() {
        startActivityForResult(new Intent("android.bluetooth.adapter.action.REQUEST_ENABLE"), 21);
    }

    public boolean isGpsEnable() {
        LocationManager locationManager = (LocationManager) getSystemService("location");
        if (locationManager == null) {
            return false;
        }
        try {
            return locationManager.isProviderEnabled("gps");
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void enableGPS() {
        Log.i(TAG, "enableGPS");
        try {
            Intent intent = new Intent("android.settings.LOCATION_SOURCE_SETTINGS");
            if (intent.resolveActivity(getPackageManager()) != null) {
                startActivityForResult(intent, 20);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void bluetoothIsReady() {
        search("", 12000);
    }

    /* access modifiers changed from: protected */
    public void search(String str, long j) {
        if (j < 5000 || j > 30000) {
            j = 12000;
        }
        if (str != null && !this.mIsScanning) {
            Log.i(TAG, "SearchActivity-->search macAddress:" + str);
            BluetoothLeScannerCompat scanner = BluetoothLeScannerCompat.getScanner();
            ScanSettings build = new ScanSettings.Builder().setScanMode(2).setReportDelay(1000).setUseHardwareBatchingIfSupported(false).build();
            this.mScanCallback = new ScanCallback() {
                public void onScanResult(int i, ScanResult scanResult) {
                    super.onScanResult(i, scanResult);
                    StringBuilder sb = new StringBuilder();
                    sb.append("onScanResult result is null:");
                    sb.append(scanResult == null);
                    Log.i(SearchActivity.TAG, sb.toString());
                }

                public void onBatchScanResults(List<ScanResult> list) {
                    if (list != null) {
                        Log.i(SearchActivity.TAG, "onBatchScanResults results size:" + list.size());
                        if (SearchActivity.this.adapter != null) {
                            SearchActivity.this.adapter.update(list);
                        }
                        if (!TextUtils.isEmpty(SearchActivity.this.autoConnectAddress) && SearchActivity.this.autoConnectAddress.length() > 10) {
                            for (ScanResult next : list) {
                                if (next != null && next.getDevice() != null && SearchActivity.this.autoConnectAddress.equalsIgnoreCase(next.getDevice().getAddress())) {
                                    SearchActivity.this.autoConnect();
                                    return;
                                }
                            }
                            return;
                        }
                        return;
                    }
                    Log.e(SearchActivity.TAG, "onBatchScanResults results is null");
                }

                public void onScanFailed(int i) {
                    super.onScanFailed(i);
                    Log.e(SearchActivity.TAG, "onScanFailed errorCode:" + i);
                }
            };
            try {
                scanner.startScan((List<ScanFilter>) null, build, this.mScanCallback);
            } catch (Exception unused) {
                if (this.mScanCallback != null) {
                    this.mScanCallback.onScanFailed(-1);
                }
                Toast.makeText(this, R.string.scanner_empty, 0).show();
            }
            this.mIsScanning = true;
            ThreadManager.getMainHandler().postDelayed(new Runnable() {
                public void run() {
                    if (SearchActivity.this.mIsScanning) {
                        SearchActivity.this.stopScan();
                    }
                }
            }, j);
        }
    }

    /* access modifiers changed from: private */
    public void autoConnect() {
        List<ExtendedBluetoothDevice> data;
        if (this.listView != null && this.adapter != null && (data = this.adapter.getData()) != null) {
            int i = -1;
            int i2 = 0;
            while (true) {
                if (i2 < data.size()) {
                    ExtendedBluetoothDevice extendedBluetoothDevice = data.get(i2);
                    if (extendedBluetoothDevice != null && extendedBluetoothDevice.device != null && this.autoConnectAddress.equalsIgnoreCase(extendedBluetoothDevice.device.getAddress())) {
                        i = i2;
                        break;
                    }
                    i2++;
                } else {
                    break;
                }
            }
            if (i > 0) {
                this.listView.performItemClick(this.listView.getAdapter().getView(i, (View) null, (ViewGroup) null), i, this.listView.getAdapter().getItemId(i));
            }
        }
    }

    /* access modifiers changed from: protected */
    public void stopScan() {
        if (this.mIsScanning) {
            Log.i(TAG, "SearchActivity-->stopScan");
            BluetoothLeScannerCompat scanner = BluetoothLeScannerCompat.getScanner();
            if (this.mScanCallback != null) {
                scanner.stopScan(this.mScanCallback);
            }
            this.mScanCallback = null;
            this.mIsScanning = false;
        }
    }

    /* access modifiers changed from: protected */
    public void onActivityResult(int i, int i2, Intent intent) {
        switch (i) {
            case 20:
                if (-1 == i2 || isGpsEnable()) {
                    bluetoothIsReady();
                    return;
                } else {
                    Toast.makeText(this, getString(R.string.heart_rate_ble_must_with_gps), 0).show();
                    return;
                }
            case 21:
                if (-1 != i2) {
                    Toast.makeText(this, getString(R.string.activity_search_bt_fail), 0).show();
                    return;
                } else if (Build.VERSION.SDK_INT < 23) {
                    bluetoothIsReady();
                    return;
                } else if (isGpsEnable()) {
                    bluetoothIsReady();
                    return;
                } else {
                    Toast.makeText(this, getString(R.string.heart_rate_ble_must_with_gps), 0).show();
                    Log.i(TAG, "onActivityResult-->enableGPS");
                    enableGPS();
                    return;
                }
            default:
                return;
        }
    }
}