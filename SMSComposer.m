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

#import "SMSComposer.h"

@implementation SMSComposer

-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (SMSComposer*)[super initWithWebView:theWebView];
    return self;
}

- (void)showSMSComposer:(NSArray*)arguments withDict:(NSDictionary*)options
{

    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {          

        if (![messageClass canSendText]) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"SMS Text not available."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"SMS Text not available."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }

    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;


    NSString* body = nil;
    NSArray* toRecipientsString = nil;
    
    @try {
        body = [options objectForKey:@"body"];
        if(body) {
             picker.body = [options valueForKey:@"body"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SMSComposer - Cannot set body; error: %@", exception);
    }
    
    @try {
        toRecipientsString = [options objectForKey:@"toRecipients"];
        if(toRecipientsString) {
            [picker setRecipients:toRecipientsString];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SMSComposer - Cannot set toRecipients; error: %@", exception);
    }

    [self.viewController presentModalViewController:picker animated:YES];
    [picker release];

}

// Dismisses the composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{   
    // Notifies users about errors associated with the interface
    int webviewResult = 0;

    switch (result)
    {
        case MessageComposeResultCancelled:
            webviewResult = 0;
            break;
        case MessageComposeResultSent:
            webviewResult = 1;
            break;
        case MessageComposeResultFailed:
            webviewResult = 2;
            break;
        default:
            webviewResult = 3;
            break;
    }

    [self.viewController dismissModalViewControllerAnimated:YES];

    NSString* jsString = [[NSString alloc] initWithFormat:@"window.plugins.smsComposer._didFinishWithResult(%d);",webviewResult];
    [self writeJavascript:jsString];
    [jsString release];

}

@end
