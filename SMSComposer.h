/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Gal Cohen

 * Original code from:
 * Pierre-Yves Orban, Daniel Shookowsky - android: https://github.com/phonegap/phonegap-plugins/tree/5cf45fcade4989668e95a6d34630d2021c45291a/Android/SMSPlugin
 * Randy McMillan - ios and js: https://github.com/phonegap/phonegap-plugins/blob/5cf45fcade4989668e95a6d34630d2021c45291a/iOS/SMSComposer/SMSComposer.js
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * SMS Composer plugin for PhoneGap/Cordova
 * window.plugins.SMSComposer
 *
 * Unified and updated API to be cross-platform by Gal Cohen in 2013.
 * galcohen26@gmail.com
 * https://github.com/GalCohen
 *
 */

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import <Cordova/CDVPlugin.h>
#endif

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SMSComposer : CDVPlugin <MFMessageComposeViewControllerDelegate> {
}

- (void)showSMSComposer:(NSArray*)arguments withDict:(NSDictionary*)options;
@end