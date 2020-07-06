public class SMSTwilioApexController {
     /**
      * Author: Umesh Beti
      * Blog : https://salesforcecody.com/
      * Portfolio: http://umeshbeti.com/
      * Date: 20/04/2020
      */
    //Twilio API service is free, on the singup you will get $15, from this you can purchase number freely to develope your own SMS product.
    //@Description: This Credential could be placed in you are custom Settings, and you can pull from there to secure this credentials.
    
    //@Description: Twilio AccountSID, copy from twilio console dashboard from your project.
    static String AccountSID = '####29##802c#######e5f57';
    //@Description: AuthToken: Get this auto token from twilio console dashboard from your project, default it will be hidden need to click to copy.
    static string AuthToken = 'c03b####################';
    //@Description: The Twilio number: you can get this number from Phone number section or at the time account creation it would ask you to get trial number.
    static String fromTwilioNumber = '############';
    /* @Description: To Catch the Twilio API errors. */
    public class TwilioErrorResponseWrapper{
        String Errorcode;
        String Errormessage;
        String moreInfo;
        String statusCode;    
    }
    /*Wrapper Class End */
    /**
* @description: This method is used to send the message to the End User,
* If it's Twilio Trial Account only Verified Numbers you can send, If Non-trial You can send to anyone.
*/
    @AuraEnabled
    public static String SendSMS(String MobileNumber,String CountryCode,String MessageBody){
        HttpRequest RestRequest = new HttpRequest();
        //Set's the Account SID in the Twilio Message JSON
        RestRequest.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+AccountSID+'/SMS/Messages.json');
        RestRequest.setMethod('POST');
        //Version's of the Salesforce-Twilio
        String TwilioVersionControll  = '3.2.0';
        RestRequest.setHeader('X-Twilio-Client', 'salesforce-' + TwilioVersionControll);
        RestRequest.setHeader('User-Agent', 'twilio-salesforce/' + TwilioVersionControll);
        RestRequest.setHeader('Accept', 'application/json');
        RestRequest.setHeader('Accept-Charset', 'utf-8');
        //Set Authorization to call the Twilio API with AccountSID and AUTH Token
        RestRequest.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(AccountSID+':' +AuthToken)));
        RestRequest.setBody('To='+EncodingUtil.urlEncode(CountryCode+MobileNumber,'UTF-8')+'&From='+EncodingUtil.urlEncode(fromTwilioNumber,'UTF-8')+'&Body='+MessageBody);
        Http http = new Http();
        HTTPResponse RestResponse = http.send(RestRequest);
        if(RestResponse.getStatusCode()==201){
            return 'We Have Sent Message Successfully To '+CountryCode + '-' + MobileNumber;
        }else{
            TwilioErrorResponseWrapper ErrorWrapper =(TwilioErrorResponseWrapper)json.deserialize(RestResponse.getBody(),TwilioErrorResponseWrapper.class);
            return ErrorWrapper.Errormessage+', For This Number'+CountryCode+ '-' + MobileNumber;
        }
    }
}