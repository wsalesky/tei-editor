xquery version "3.0";
(:~
 : Build editor interface
 : Combination of teian and xforms
 : This version of the editor outputs an xform. 
 : Calls services as modules
:)

import module namespace desc="http://syriaca.org/tei-editor/desc" at "../services/get-desc.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xhtml media-type=text/html";
(:~
 : Builds xform and populates working instance from build-place-instance.xqm
 : @param $id passed to form for adding data to existing place, if no id new place will be created
 : NOTE need to add 'generate new id function for new records'
:)

(:<html xmlns:teian="http://kuberam.ro/ns/teian" xmlns="http://www.w3.org/1999/xhtml">:)
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:teian="http://kuberam.ro/ns/teian" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xf="http://www.w3.org/2002/xforms">
    <head>
        <title data-template="config:app-title">App Title</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta data-template="config:app-meta"/>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="../resources/css/teibp.css"/>
        <link rel="stylesheet" type="text/css" href="../resources/css/tei.css"/>
        
	<!-- jquery -->
        <script type="text/javascript" charset="utf-8" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js">/**/</script>
        
	<!--dependencies for dialog plugin-->
        <link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" charset="utf-8" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js">/**/</script>
        
        <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
		<!-- dependencies for the context menu -->
        <script type="text/javascript" charset="utf-8" src="http://medialize.github.com/jQuery-contextMenu/src/jquery.contextMenu.js">/**/</script>
        <link rel="stylesheet" type="text/css" href="http://medialize.github.com/jQuery-contextMenu/src/jquery.contextMenu.css"/>
		      
	<!--dependencies for teian-->
	   <script type="text/javascript" charset="utf-8" src="../resources/scripts/teian.js">/**/</script>
    <!--    <script type="text/javascript" charset="utf-8" src="teian.js">/**/</script>-->
        
	<!--dependencies for kyer-->
        <link rel="stylesheet" type="text/css" href="http://kyer.sourceforge.net/latest/core/kyer.css"/>
        <script type="text/javascript" charset="utf-8" src="http://kyer.sourceforge.net/latest/core/kyer.js">/**/</script>
		
	<!--dependencies for simpath-->
        <script type="text/javascript" charset="utf-8" src="http://simpath.sourceforge.net/latest/core/simpath.js">/**/</script>
        
	<!--dependencies for rangy-->
        <script type="text/javascript" charset="utf-8" src="http://rangy.googlecode.com/svn/trunk/currentrelease/rangy-core.js">/**/</script>
        <script type="text/javascript" charset="utf-8" src="http://rangy.googlecode.com/svn/trunk/currentrelease/rangy-selectionsaverestore.js">/**/</script>

    </head>
    <body id="grey-top">
    <div class="section" style="margin:2em;">
       <h1>Test: Batch Edit Descriptions</h1>
        <div id="element-menu" style="width:250px; position:fixed; background-color:white; padding:0; margin:2em 0;">
        <h3><a href="#" id="btnRange">Display Range</a> | <a href="#" id="btnMark">Mark Range</a></h3>
            <ul class="list-group">
                <li class="list-group-item"><a href="#" id="persName" class="annotation-type">persName</a></li>
                <li class="list-group-item"><a href="#" id="placeName" class="annotation-type">placeName</a></li>
                <li class="list-group-item"><a href="#" id="bibl" class="annotation-type">bibl</a></li>
                <li class="list-group-item"><a href="#" id="keyword" class="annotation-type">keyword</a></li>
            </ul>
        </div>
       <div style="background-color:white; margin:2em; margin-left: 275px; padding:2em;">
           {desc:build-list-tei()}
        </div>
     </div>
     <div class="modal fade" id="vocabModal" tabindex="-1" role="dialog" aria-labelledby="vocabLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span aria-hidden="true">x</span>
                            <span class="sr-only">Close</span>  
                        </button>
                        <h3 class="modal-title" id="vocabLabel">Search Controlled Vocabularies</h3>
                    </div>
                    <div class="modal-body" id="modal-body">
                        <iframe id="vocab-lookup" src="../forms/form.xq?form=controlled-vocab-search.xhtml" width="100%" frameborder="0"/>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" data-dismiss="modal">Close</button>
                        <input id="email-submit" type="submit" value="Send e-mail" class="btn"/>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>