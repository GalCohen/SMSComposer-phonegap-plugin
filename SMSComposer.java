/**
 * 
 * SMS Composer plugin for PhoneGap/Cordova
 * window.plugins.SMSComposer
 *
 * Unified and updated API to be cross-platform by Gal Cohen in 2013.
 * galcohen26@gmail.com
 * https://github.com/GalCohen
 *
 * Original code from: 
 * android: https://github.com/phonegap/phonegap-plugins/tree/5cf45fcade4989668e95a6d34630d2021c45291a/Android/SMSPlugin
 * ios and js: https://github.com/phonegap/phonegap-plugins/blob/5cf45fcade4989668e95a6d34630d2021c45291a/iOS/SMSComposer/SMSComposer.js
 */
/*
Copyright (C) 2013 by Pierre-Yves Orban

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
package org.apache.cordova;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.PendingIntent;
import android.app.PendingIntent.CanceledException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.telephony.SmsManager;

public class SMSComposer extends CordovaPlugin {
	public final String ACTION_HAS_SMS_POSSIBILITY = "HasSMSPossibility";
	public final String ACTION_SEND_SMS = "showSMSComposer";

	private SmsManager smsManager = null;

	public SMSComposer() {
		super();
		smsManager = SmsManager.getDefault();
	}

	@Override
	public boolean execute(String action, JSONArray args,
			final CallbackContext callbackContext) throws JSONException {
		System.out.println("MADE IT HERE..." + action);
		JSONObject parameters = args.getJSONObject(0);

		if (action.equals(ACTION_HAS_SMS_POSSIBILITY)) {

			Activity ctx = this.cordova.getActivity();
			if (ctx.getPackageManager().hasSystemFeature(
					PackageManager.FEATURE_TELEPHONY)) {
				callbackContext.sendPluginResult(new PluginResult(
						PluginResult.Status.OK, true));
			} else {
				callbackContext.sendPluginResult(new PluginResult(
						PluginResult.Status.OK, false));
			}
			return true;
		} else if (action.equals(ACTION_SEND_SMS)) {
			System.out.println("MADE INTO HERE TOO...");
			try {
				System.out.println(parameters.toString());
				JSONArray phoneNumbers = parameters.getJSONArray("toRecipients");
				System.out.println("json 1 worked");
				System.out.println("1"+phoneNumbers.length());
				System.out.println("2"+phoneNumbers.toString());
				System.out.println("3"+phoneNumbers.get(0));
				System.out.println("4"+phoneNumbers.getString(0));
				String[] numbers = null;

				String message = parameters.getString("body");
				System.out.println("json 2 worked");
				System.out.println(message);

				if (phoneNumbers != null && phoneNumbers.length() > 0 && phoneNumbers.toString().equals("[\"\"]")) {
					numbers = new String[phoneNumbers.length()];
					System.out.println("string array created");
					for (int i = 0; i < phoneNumbers.length(); i++) {
						numbers[i] = phoneNumbers.getString(i);
						System.out.println(numbers[i]);
					}

					this.sendSMS(numbers, message);
				} else {
					this.openSMSComposer(message); // if the list is empty, open
													// composer instead.
				}

				callbackContext.sendPluginResult(new PluginResult(
						PluginResult.Status.OK));
			} catch (JSONException ex) {
				System.out.println("JSON ERRORS");
				callbackContext.sendPluginResult(new PluginResult(
						PluginResult.Status.ERROR, ex.getMessage()));
			} catch (Exception e) {
				System.out.println("Error handling: " + e.toString());
			}

			return true;
		}
		System.out.println("Error with api");
		callbackContext.sendPluginResult(new PluginResult(
				PluginResult.Status.ERROR, "Error, action doesnt fit api"));
		return false;
	}

	private void sendSMS(String[] phoneNumbers, String message) {
		PendingIntent sentIntent = PendingIntent.getActivity(
				this.cordova.getActivity(), 0, new Intent(), 0);
		System.out.println("sendSMS");
		for (int i = 0; i < phoneNumbers.length; i++) {
			smsManager.sendTextMessage(phoneNumbers[i], null, message,
					sentIntent, null);
			System.out.println("sent:" + message + " to:" + phoneNumbers[i]);
		}

		System.out.println("sent sms");
	}

	private void openSMSComposer(String message) {
		System.out.println("openSMSComposer");

		// Intent sentIntent = new Intent(Intent.ACTION_VIEW);
		// sentIntent.putExtra("sms_body", message);
		// sentIntent.setType("vnd.android-dir/mms-sms");
		// this.cordova.getActivity().startActivity(sentIntent);

		PendingIntent sentIntent = PendingIntent.getActivity(
				this.cordova.getActivity(), 0, new Intent(Intent.ACTION_VIEW),
				0);
		Intent intent = new Intent(Intent.ACTION_VIEW);
		intent.putExtra("sms_body", message);
		intent.setType("vnd.android-dir/mms-sms");
		// this.cordova.getActivity().startActivity(sentIntent);
		try {
			sentIntent.send(this.cordova.getActivity().getApplicationContext(),
					0, intent);
		} catch (CanceledException e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}

		System.out.println("sent sms");
	}
}