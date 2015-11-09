/*
 * Copyright (C) 2012 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Message;
import android.os.Parcel;
import android.text.TextUtils;
import android.telephony.Rlog;
import java.util.ArrayList;

/*
 * Custom NovaThor SimReady RIL for Sony Radio
 *
 * {@hide}
 */
public class SonyU8500RIL extends RIL implements CommandsInterface {
    static final String LOG_TAG = "SonyU8500RIL";

    public SonyU8500RIL(Context context, int networkMode, int cdmaSubscription) {
        this(context, networkMode, cdmaSubscription, null);
    }

    public SonyU8500RIL(Context context, int preferredNetworkType,
            int cdmaSubscription, Integer instanceId) {
        super(context, preferredNetworkType, cdmaSubscription, instanceId);
        mQANElements = 5;
    }

    private void
    setNetworkSelectionMode(String operatorNumeric, Message response) {
        RILRequest rr;

        if (operatorNumeric == null)
            rr = RILRequest.obtain(RIL_REQUEST_SET_NETWORK_SELECTION_AUTOMATIC, response);
        else
            rr = RILRequest.obtain(RIL_REQUEST_SET_NETWORK_SELECTION_MANUAL, response);

        rr.mParcel.writeString(operatorNumeric);
        rr.mParcel.writeInt(-1);

        send(rr);
    }

    private void
    handleUnsupportedRequest(Message response) {
        if (response != null) {
            CommandException ex = new CommandException(
                CommandException.Error.REQUEST_NOT_SUPPORTED);
            AsyncResult.forMessage(response, null, ex);
            response.sendToTarget();
        }
    }

    @Override
    public void
    dial(String address, int clirMode, UUSInfo uusInfo, Message result) {
        RILRequest rr = RILRequest.obtain(RIL_REQUEST_DIAL, result);

        rr.mParcel.writeString(address);
        rr.mParcel.writeInt(clirMode);

        if (uusInfo == null) {
            rr.mParcel.writeInt(0); // UUS information is absent
        } else {
            rr.mParcel.writeInt(1); // UUS information is present
            rr.mParcel.writeInt(uusInfo.getType());
            rr.mParcel.writeInt(uusInfo.getDcs());
            rr.mParcel.writeByteArray(uusInfo.getUserData());
        }
        rr.mParcel.writeInt(255);

        if (RILJ_LOGD) riljLog(rr.serialString() + "> " + requestToString(rr.mRequest));

        send(rr);
    }

    @Override
    public void
    setNetworkSelectionModeAutomatic(Message response) {
        setNetworkSelectionMode(null, response);
    }

    @Override
    public void
    setNetworkSelectionModeManual(String operatorNumeric, Message response) {
        setNetworkSelectionMode(operatorNumeric, response);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void getCellInfoList(Message result) {
        Rlog.i(LOG_TAG, "RIL_REQUEST_GET_CELL_INFO_LIST is not supported");
        handleUnsupportedRequest(result);
    }

    @Override
    public void
    getHardwareConfig (Message result) {
        Rlog.i(LOG_TAG, "RIL_REQUEST_GET_HARDWARE_CONFIG is not supported");
        handleUnsupportedRequest(result);
    }

    @Override
    public void getImsRegistrationState(Message result) {
        Rlog.i(LOG_TAG, "RIL_REQUEST_IMS_REGISTRATION_STATE is not supported");
        handleUnsupportedRequest(result);
    }

    @Override
    public void getRadioCapability(Message response) {
        Rlog.i(LOG_TAG, "RIL_REQUEST_GET_RADIO_CAPABILITY is not supported");
        handleUnsupportedRequest(response);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setCellInfoListRate(int rateInMillis, Message response) {
        Rlog.i(LOG_TAG, "RIL_REQUEST_SET_UNSOL_CELL_INFO_LIST_RATE is not supported");
        handleUnsupportedRequest(response);
    }

    public void setInitialAttachApn(String apn, String protocol, int authType, String username,
            String password, Message result) {
        Rlog.i(LOG_TAG, "RIL_REQUEST_SET_INITIAL_ATTACH_APN is not supported");
        handleUnsupportedRequest(result);
    }

    @Override
    public void startLceService(int reportIntervalMs, boolean pullMode, Message response) {
        Rlog.i(LOG_TAG, "RIL_REQUEST_START_LCE is not supported");
        handleUnsupportedRequest(response);
    }

}
