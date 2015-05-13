
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
    
}

/* XSLTForms dispatch event*/
function call_xform_event(xfevent, xfpayload) {
    var model = document.getElementById("m-search")
    XsltForms_xmlevents.dispatch(model, xfevent, null, null, null, null, xfpayload);
}