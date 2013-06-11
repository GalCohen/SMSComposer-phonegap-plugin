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

//
//  SMSComposer.m
//  SMS Composer plugin for PhoneGap
//
//  Created by Grant Sanders on 12/25/2010.
//

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
