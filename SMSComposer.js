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
 * Temporary Scope to contain the plugin.
 */
(function() {
     
     /* Get local ref to global PhoneGap/Cordova/cordova object for exec function.
      - This increases the compatibility of the plugin. */
     var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks
     
     function SMSComposer(){
        this.resultCallback = null;
     }
     
     SMSComposer.ComposeResultType = {
         Cancelled:0,
         Sent:1,
         Failed:2,
         NotSent:3
     }
     
     SMSComposer.prototype.showSMSComposer = function(toRecipients, body) {
         
         var args = {};
         
         /* if(toRecipients)
          args.toRecipients = toRecipients;
          
          if(body)
          args.body = body;
          */
         args.body = body ? body : "";
         args.toRecipients = toRecipients ? toRecipients : [""];
         console.log(args.length);
         console.log(args);
         //cordovaRef.exec("SMSComposer.showSMSComposer",[args]);
         cordovaRef.exec(null, null, "SMSComposer", "showSMSComposer", [args]);
     }
     
     SMSComposer.prototype.showSMSComposerWithCB = function(cbFunction,toRecipients,body) {
        this.resultCallback = cbFunction;
        this.showSMSComposer.apply(this,[toRecipients,body]);
     }
     
     SMSComposer.prototype._didFinishWithResult = function(res) {
        this.resultCallback(res);
     }
     
     cordovaRef.addConstructor(function() {
       
       if(!window.plugins) {
            window.plugins = {};
       }
       
       if (!window.plugins.smsComposer){
            window.plugins.smsComposer = new SMSComposer();
            console.log("**************************** SMS Composer ready *************************");
       }
    });
 })();/* End of Temporary Scope. */