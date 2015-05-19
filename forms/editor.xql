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

declare option exist:serialize "method=xhtml media-type=text/xml";
(:~
 : Builds xform and populates working instance from build-place-instance.xqm
 : @param $id passed to form for adding data to existing place, if no id new place will be created
 : NOTE need to add 'generate new id function for new records'
 : Uses XSLTForms and XSLTForms javascript for annotation functions
:)

let $form-doc :=
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:teian="http://kuberam.ro/ns/teian" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xf="http://www.w3.org/2002/xforms">
    <head>
        <title data-template="config:app-title">App Title</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta data-template="config:app-meta"/>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="../resources/css/teibp.css"/>
        <link rel="stylesheet" type="text/css" href="../resources/css/tei.css"/>
        <link rel="stylesheet" type="text/css" href="../resources/css/xforms.css"/>
        
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
	   <script type="text/javascript" charset="utf-8" src="../resources/scripts/annotator.js">/**/</script>
    <!--    <script type="text/javascript" charset="utf-8" src="teian.js">/**/</script>-->
        
	<!--dependencies for kyer -->
        <link rel="stylesheet" type="text/css" href="http://kyer.sourceforge.net/latest/core/kyer.css"/>
        <script type="text/javascript" charset="utf-8" src="http://kyer.sourceforge.net/latest/core/kyer.js">/**/</script>
	<!--dependencies for simpath -->
        <script type="text/javascript" charset="utf-8" src="http://simpath.sourceforge.net/latest/core/simpath.js">/**/</script>
	<!--dependencies for rangy-->
        <script type="text/javascript" charset="utf-8" src="http://rangy.googlecode.com/svn/trunk/currentrelease/rangy-core.js">/**/</script>
        <script type="text/javascript" charset="utf-8" src="http://rangy.googlecode.com/svn/trunk/currentrelease/rangy-selectionsaverestore.js">/**/</script>

    </head>
    <body id="grey-top">
    <div class="section" style="margin:2em;">
        <xf:model id="m-search">
            <!-- Generate new in xquery, populate place-id -->
            <!-- Search parameters -->
            <xf:instance id="i-search">
                <root xmlns="">
                    <q/>
                    <element>persName</element>
                </root>
            </xf:instance>
            
            <!-- Search results are loaded into this instance -->
            <xf:instance xmlns="http://www.tei-c.org/ns/1.0" id="i-results">
                <results>
                    <TEI>
                        <persName ref="http://syriaca.org/person/">Enter search</persName>
                    </TEI>
                </results>
            </xf:instance>
            
            <!-- Final selected and edited annotation will be saved here -->
            <xf:instance xmlns="http://www.tei-c.org/ns/1.0" id="i-selected">
                <results>       
                    <TEI>
                        <persName ref=""></persName>
                    </TEI>
                </results>
            </xf:instance>
            
            <!-- -->
            <xf:submission id="search-vocab" method="get" replace="instance" instance="i-results" serialization="none" mode="synchronous">
                <xf:resource value="concat('../services/controlled-vocab-search.xql?element=',element,'&amp;','q=',q,'*')"/>
            </xf:submission>
            
            <!-- Action prepopulates search instance with user selection -->
            <!-- Note: Should add custom action to set selected element type -->
            <xf:action ev:event="update-search">
                <xf:setvalue ref="instance('i-search')/q" value="event('q')" />
                <xf:setvalue ref="instance('i-search')/element" value="event('element')" />
                <xf:send submission="search-vocab" />
            </xf:action>
            
            <!-- Initializes javascript for forms -->
            <xf:action ev:event="xforms-ready">
                <xf:load resource="javascript:teiFormsJS()"/>
            </xf:action>
            
            <!-- Binds persName/placeName to selected element -->
            <xf:bind id="ref-value" readonly="false()" nodeset="instance('i-selected')/tei:TEI/child::*" calculate="instance('i-results')/tei:TEI/child::*[@ref = instance('i-selected')/tei:TEI/child::*/@ref]/text()"></xf:bind>
        </xf:model>
        <h1>Test: Batch Edit Descriptions</h1>
        <!-- Annotations menu -->
        <div id="element-menu" style="width:250px; position:fixed; background-color:white; padding:0; margin:2em 0;">
        <h3>Annotations</h3>
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
     <!-- Controlled Vocab Search Form -->
     <div class="modal fade" id="vocabModal" tabindex="-1" role="dialog" aria-labelledby="vocabLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">x</span><span class="sr-only">Close</span>  </button>
                    <h3 class="modal-title" id="vocabLabel">Search Controlled Vocabularies</h3>
                </div>
            <div class="modal-body" id="modal-body">
            <div class="section">
            <!-- Look up -->
                <xf:group class="input-md input-group">
                    <xf:input id="search" ref="instance('i-search')/q" incremental="true">
                        <xf:label>Search: </xf:label>
                        <xf:send submission="search-vocab" ev:event="xforms-value-changed" ref="string-length(instance('i-search')/q) &gt; 2" class="input-group-btn"/>
                    </xf:input>
                    <xf:select1 ref="instance('i-search')/element" class="inline">
                        <xf:label> Element:</xf:label>
                        <xf:item>
                            <xf:label>Person</xf:label>
                            <xf:value>persName</xf:value>
                        </xf:item>
                        <xf:item>
                            <xf:label>Place</xf:label>
                            <xf:value>placeName</xf:value>
                        </xf:item>
                        <xf:item>
                            <xf:label>Bibl</xf:label>
                            <xf:value>bibl</xf:value>
                        </xf:item>
                    </xf:select1>                     
                </xf:group>
                <p class="text-muted">*Currently searches persName, placeName and bibl elements in existing records</p>
            <!-- Results -->                
                <xf:select1 ref="instance('i-selected')/tei:TEI/child::*/@ref" appearance="full" class="checkbox select-group">
                    <xf:label></xf:label>
                    <xf:itemset ref="instance('i-results')/tei:TEI">
                        <xf:label ref="child::*"/>
                        <xf:value ref="child::*/@ref"/>
                    </xf:itemset>
                </xf:select1>
            <!-- Edit Results -->                
                <xf:group class="horiz-tab-menu" ref="instance('i-selected')/tei:TEI/child::*">
                    <xf:trigger appearance="minimal" class="tabs view" >
                        <xf:label>View Selection </xf:label>
                        <xf:toggle case="view-selected" ev:event="DOMActivate"/>
                    </xf:trigger>
                    <xf:trigger appearance="minimal" class="tabs edit">
                        <xf:label>Edit Selection </xf:label>
                        <xf:toggle case="edit-selected" ev:event="DOMActivate"/>
                    </xf:trigger>
                    <!-- Add selected results to record -->
                    <!-- NOTE: need js to insert back into appropriate place -->
                    <a href="#" id="save-selected">save selected</a>
                </xf:group>
                <xf:switch id="review" class="tab-panel">
                    <xf:case id="view-selected" selected="true()">
                        <xf:group class="view">
                            <xf:output ref="instance('i-selected')/tei:TEI/child::*">
                                <xf:label>Name: </xf:label>
                            </xf:output>
                            <br/>
                            <xf:output ref="instance('i-selected')/tei:TEI/child::*/@ref">
                                <xf:label>ID: </xf:label>
                            </xf:output>
                        </xf:group>
                    </xf:case>
                    <xf:case id="edit-selected">
                        <xf:group class="edit">
                            <xf:input ref="instance('i-selected')/tei:TEI/child::*" class="input-md" incremental="true">
                                <xf:label class="inline">Name: </xf:label>
                            </xf:input>
                        </xf:group>
                    </xf:case>
                </xf:switch>
            </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
    </div>
    </body>
</html>

let $dummy := request:set-attribute("betterform.filter.ignoreResponseBody", "true")
let $xslt-pi := processing-instruction xml-stylesheet {'type="text/xsl" href="/exist/rest/db/apps/xsltforms/xsltforms.xsl"'}
let $css-pi := processing-instruction css-conversion {'no'}
let $debug := processing-instruction xsltforms-options {'debug="yes"'}
return ($xslt-pi,$css-pi, $debug, $form-doc)