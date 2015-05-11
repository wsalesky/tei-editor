/*
 * Teian - Web adnotator
 * By Claudius Teodorescu
 * Licensed under LGPL.
 */
 
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
window.onload = function() {


$(".annotation-type").on("click", function (e) {
    getBefore(e.target.id);
});

function getBefore(id) {   
    var element = id;
    var query = rangy.getSelection().toString();
    var url = '../services/controlled-vocab-search.xql?' + 'element=' + element + '&amp;q=' + query + '*';
    /*$('#vocab-lookup').attr('src', url);*/
    $('#vocabModal').modal('show');
    /*$.ajax({
        type: 'get',
        url: '../services/controlled-vocab-search.xql',
        data: { "element": element, "q": query + '*'},
        contentType: "text/xml; charset=utf-8",                
        dataType: "text",
        success: function(data) {
            alert(data);
        }
    });
    */
}

/*
 * 
 
 * http://localhost:8080/exist/apps/tei-editor/services/controlled-vocab-search.xql?element=persName&q=aba
 Notes: pass selected text into searchbox of controlled-vocab.xhtml, 
 selected node will have to be passed back. and then saved. 
 
*/
};