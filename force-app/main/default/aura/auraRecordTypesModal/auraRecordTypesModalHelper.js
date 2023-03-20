({
    createComponent : function(component, event, componentName, attributes){
        
        var modalBody;
        $A.createComponent(componentName, attributes,
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       body: modalBody,
                       showCloseButton: true
                   })
               }
           });

    }
})
