# Phonegap/Cordova SMSComposer Plugin #

**Known Issues**
- This plugin is not yet plugman compatible. I will work on that in a future version.
- On android, you cannot pass the plugin an empty string for the sender's number field


**NOTICE: VERSION 2.1**
This is a plugin I modified for use for my phonegap app. I fixed a few bugs, modified the API to be consistent across both android and ios and included all the files necessary to run on both platforms.
I fully acknowledge the original creator of this plugin, I am simply revising and renewing this plugin.



Cordova 1.5.0 support added March 29 2012 - @RandyMcMillan

StatusBarHidden issue addressed

Comment/Uncomment line 56 in SMSComposer.m if your app shows/hides the statusbar when it is launched

SMSComposer.m LINE 56: [[UIApplication sharedApplication] setStatusBarHidden:YES];///This hides the statusbar when the picker is presented -@RandyMcMillan


## Adding the Plugin to your project ##

1. Add the SMSComposer.h and SMSComposer.m files to your "Plugins" folder in your PhoneGap project
2. Add the SMSComposer.js files to your "www" folder on disk, and add a reference to the .js file after phonegap.js.
3. Add the MessageUI framework to your Xcode project. In Xcode 4, double-click on the target, select "Build Phases" -> "Link Binary with Libraries" -> "+" and select "MessageUI.framework".
4. Add to config.xml under plugins:` <plugin name="SMSComposer" value="SMSComposer" />` or, if using the new format, 
` <feature name="SMSComposer">
        <param name="ios-package" value="SMSComposer" />
    </feature>`
- On android, in the value attribute be sure to include the package name as well, for example `value="org.apache.cordova"`

## RELEASE NOTES ##

###20120219 ###
* Fix for deprecations in PhoneGap 1.4.x
* Added PhoneGap.plist instructions in README.md

### 201101112 ###
* Initial release
* Adds SMS text message composition in-app.
* Requires iOS 4.0 or higher. 
  Attempts to compose SMS text without running 4.0+ fails gracefully with a friendly message.

## EXAMPLE USAGE ##

* All parameters are optional.
    `window.plugins.smsComposer.showSMSComposer();`


* Passing phone number and message.
    `window.plugins.smsComposer.showSMSComposer('3424221122', 'hello');`

* Multiple recipents are separated by comma(s).
    `window.plugins.smsComposer.showSMSComposer('3424221122,2134463330', 'hello');`


* `showSMSComposerWithCB` takes a callback as its first parameter.  
* 0, 1, 2, or 3 will be passed to the callback when the text message has been attempted.

```javascript
    window.plugins.smsComposer.showSMSComposerWithCB(function(result){

        if(result == 0)
            alert("Cancelled");
        else if(result == 1)
            alert("Sent");
        else if(result == 2)
            alert("Failed.");
        else if(result == 3)
            alert("Not Sent.");     

    },'3424221122,2134463330', 'hello');
````````
