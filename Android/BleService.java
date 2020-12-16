package com.acv.radio.bluetooth;

import android.app.Service;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import com.acv.radio.App;
import java.util.Hashtable;
import java.util.Map;

public class BleService extends Service {
    public static final String SERVICE_NAME = "com.acv.radio.bluetooth.BleService";
    private static final String TAG = "BleService";
    /* access modifiers changed from: private */
    public BleManagerImpl bleManager;
    private BleManagerImplCallbacks callbacks = new BleManagerImplCallbacks() {
        public void onBonded() {
        }

        public void onBondingRequired() {
        }

        public void onDeviceDisconnecting() {
        }

        public void onDeviceNotSupported() {
        }

        public void onLinkLossOccur() {
        }

        public void onServicesDiscovered(boolean z) {
        }

        public void bleDataSendStateChange(int i) {
            Log.i(BleService.TAG, "BleService BleManagerImplCallbacks-->bleDataSendStateChange state:" + i);
        }

        public void receiveDataSuccess(BleNotifyData bleNotifyData) {
            if (BleService.this.serviceFunctionTable != null) {
                for (Map.Entry value : BleService.this.serviceFunctionTable.entrySet()) {
                    ((ServiceFunction) value.getValue()).onReceiveData(bleNotifyData);
                }
            }
        }

        public void onDeviceConnected() {
            if (BleService.this.serviceFunctionTable != null) {
                for (Map.Entry value : BleService.this.serviceFunctionTable.entrySet()) {
                    ((ServiceFunction) value.getValue()).onDeviceConnected();
                }
            }
        }

        public void onDeviceDisconnected() {
            if (BleService.this.serviceFunctionTable != null) {
                for (Map.Entry value : BleService.this.serviceFunctionTable.entrySet()) {
                    ((ServiceFunction) value.getValue()).onDeviceDisconnected();
                }
            }
            if (BleService.this.bleManager != null) {
                BleService.this.bleManager.clear();
            }
            BleService.this.clearState();
        }

        public void onDeviceReady() {
            if (BleService.this.serviceFunctionTable != null) {
                for (Map.Entry value : BleService.this.serviceFunctionTable.entrySet()) {
                    ((ServiceFunction) value.getValue()).onDeviceReady();
                }
            }
        }

        public void onError(String str, int i) {
            Log.e(BleService.TAG, "BleService-->onError message:" + str + ",errorCode:" + i);
            if ("ConnectFail".equals(str)) {
                BleService.this.disconnectDevice();
                if (BleService.this.serviceFunctionTable != null) {
                    for (Map.Entry value : BleService.this.serviceFunctionTable.entrySet()) {
                        ((ServiceFunction) value.getValue()).onDeviceDisconnected();
                    }
                }
            }
        }
    };
    private final IBinder mBinder = new LocalBinder();
    private BluetoothDevice mDevice;
    /* access modifiers changed from: private */
    public Hashtable<String, ServiceFunction> serviceFunctionTable;

    public interface ServiceFunction {
        void onDeviceConnected();

        void onDeviceDisconnected();

        void onDeviceReady();

        void onReceiveData(BleNotifyData bleNotifyData);
    }

    public void onCreate() {
        super.onCreate();
        initBleManager();
    }

    public void onDestroy() {
        Log.e(SERVICE_NAME, "BleService-->onDestroy");
        release();
    }

    public class LocalBinder extends Binder {
        public LocalBinder() {
        }

        public BleService getService() {
            return BleService.this;
        }
    }

    public IBinder onBind(Intent intent) {
        return this.mBinder;
    }

    public BleManagerImpl getBleManager() {
        return this.bleManager;
    }

    private void initBleManager() {
        if (Build.VERSION.SDK_INT >= 18) {
            Log.i(TAG, "BleService-->initBleManager()");
            this.bleManager = new BleManagerImpl(this);
            this.bleManager.setBleManagerImplCallback(this.callbacks);
            this.bleManager.setBleManagerHandler(this);
        }
    }

    public void release() {
        StringBuilder sb = new StringBuilder();
        sb.append("BleService-->release() bleManager is null:");
        sb.append(this.bleManager == null);
        Log.i(TAG, sb.toString());
        if (this.bleManager != null) {
            this.bleManager.disconnect();
            this.bleManager.close();
            this.callbacks = null;
            this.bleManager.setBleManagerImplCallback((BleManagerImplCallbacks) null);
            this.bleManager.setBleManagerHandler((Context) null);
            this.bleManager.clear();
            this.bleManager = null;
        }
        this.mDevice = null;
        if (this.serviceFunctionTable != null) {
            this.serviceFunctionTable.clear();
            this.serviceFunctionTable = null;
        }
        App.mBluetoothConnected = false;
    }

    public void connectDevice(BluetoothDevice bluetoothDevice) {
        if (getBleManager() == null) {
            initBleManager();
        }
        if (getBleManager() != null) {
            getBleManager().disconnect();
            getBleManager().connect(bluetoothDevice);
            this.mDevice = bluetoothDevice;
        }
    }

    public void disconnectDevice() {
        if (getBleManager() != null) {
            getBleManager().disconnect();
            getBleManager().clear();
        }
        this.bleManager = null;
        this.mDevice = null;
    }

    public boolean isBleOk() {
        return getBleManager() != null && getBleManager().isDataChannelOk();
    }

    public BluetoothDevice getConnectedDevice() {
        return this.mDevice;
    }

    public void addServiceFunction(String str, ServiceFunction serviceFunction) {
        if (this.serviceFunctionTable == null) {
            this.serviceFunctionTable = new Hashtable<>();
        }
        if (str != null && serviceFunction != null) {
            this.serviceFunctionTable.put(str, serviceFunction);
        }
    }

    public void removeServiceFunction(String str) {
        if (this.serviceFunctionTable != null && str != null) {
            this.serviceFunctionTable.remove(str);
        }
    }

    public void write(byte[] bArr, boolean z, boolean z2) {
        if (this.bleManager != null) {
            BleSendData bleSendData = new BleSendData(bArr);
            bleSendData.isAck = !z;
            this.bleManager.addDataToSendQueue(bleSendData, z2);
        }
    }

    /* access modifiers changed from: private */
    public void clearState() {
        this.mDevice = null;
    }
}