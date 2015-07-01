
/*
 * Notes
 * Use jquery to popup incremental form... in frame?
 * Or in modal?
 * Or modal frame
 * Pass selected name into search.
 * Pass search element back to teian to be inserted into record,
 * Pass new version of the xml to xupdate for saving.
 *
 *
 */
function teiFormsJS() {
    /* Initialize rangy library */
    rangy.init();
    var selection = rangy.getSelection().toString();
    var savedSel = rangy.saveSelection();
    
    /* Call the XForm Dispatch mechanism for annotations clicks */
    $(".annotation-type").on("click", function (e) {
        /* Annotation type, passed by element class */
        var element = e.target.id
        /* Get selection with rangy */
        var selection = rangy.getSelection().toString();
        
        call_xform_event("update-search", {
            q: selection,
            element: element
        });
        $('#vocabModal').modal('show');
        e.preventDefault();
    });
    
    $("#save-selected").on("click", function (e) {
        var el = xf_getInstance('m-search', 'i-search');
        el = xf_getNode(el, 'root/element').textContent;
        
        var contentNew = xf_getInstance('m-search', 'i-selected');
        contentNew = xf_getNode(contentNew, 'tei:results/tei:TEI/tei:persName').cloneNode(true);
        
        var sel = rangy.getSelection();
        var savedSel = rangy.saveSelection();
        
        if (sel.rangeCount > 0) {
            sel.deleteFromDocument();
            var range = sel.getRangeAt(0);
            range.insertNode(contentNew);
            sel.setSingleRange(range);
        }
        /*alert(JSON.stringify(ins.documentElement, null, 4));*/
        $('#vocabModal').modal('hide');
        xf_resetInstance('m-search', 'i-search');
        xf_resetInstance('m-search', 'i-selected');
        xf_resetInstance('m-search', 'i-results');
        /* also need to clear form, reset */
        console.log(el);
        console.log(contentNew);
        
        /*console.log(XsltForms_browser.selectSingleNode(path, context));*/
    });
}



/** XSLTForms functions  **/
/* Get instance by id */
function xf_getInstance(modelId, instanceId) {
    var model = window.document.getElementById(modelId);
    var doc = model.getInstanceDocument(instanceId);
    return doc;
}

/* Get Node */
function xf_getNode(context, path) {
    return XsltForms_browser.selectSingleNode(path, context);
}

/* Change Node dynamically : Note used currently */
function xf_changeNode(node, value) {
    XsltForms_globals.openAction("XsltForms_change");
    XsltForms_browser.setValue(node, value || "");
    document.getElementById(XsltForms_browser.getMeta(node.ownerDocument.documentElement, "model")).xfElement.addChange(node);
    XsltForms_browser.debugConsole.write("Setvalue " + node.nodeName + " = " + value);
    XsltForms_globals.closeAction("XsltForms_change");
}

function xf_resetInstance(modelId, instanceId){
   var model = window.document.getElementById(modelId);
   var doc = model.getInstanceDocument(instanceId);
   // Update XForms instance using XSLTForms methods
   XsltForms_globals.openAction();
   //Reset instance     
   model.reset(doc); 
   // Must refresh the form
   XsltForms_globals.refresh();
   XsltForms_globals.closeAction(); 
}

/* XSLTForms dispatch event - user defined events */
function call_xform_event(xfevent, xfpayload) {
    var model = document.getElementById("m-search")
    XsltForms_xmlevents.dispatch(model, xfevent, null, null, null, null, xfpayload);
}