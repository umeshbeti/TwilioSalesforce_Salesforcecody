({
    SendSMShelperMethod : function(component, event) {
        var action = component.get("c.SendSMS");
        action.setParams({'MobileNumber':component.get("v.MobileNumber"),
                          'CountryCode':component.get("v.CountryCode"),
                          'MessageBody':component.get("v.MessageBody")
                         });
        action.setCallback(this, function(data){
            if(data.getState() == 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'pester',
                    "title": "SMS Sent successfully!",
                    "message": data.getReturnValue(),
                    "type": "success"
                });
                toastEvent.fire();
            }
            else if(data.getState() == 'ERROR'){
                var errors = data.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'pester',
                    "title": "Error while Sending SMS.",
                    "message": "There are errors while Sending SMS.",
                    "type": "error "
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action); 
    }
})