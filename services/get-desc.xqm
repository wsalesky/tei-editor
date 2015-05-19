xquery version "3.0";
(:~
 : Build dropdown list of available resources for citation
:)

module namespace desc="http://syriaca.org/tei-editor/desc";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xhtml media-type=text/html";
(:~
 : NOTE, these params are not currently used 
 : Builds xform and populates working instance from build-place-instance.xqm
 : @param $id passed to form for adding data to existing place, if no id new place will be created
 : NOTE need to add 'generate new id function for new records'
:)
(:forms:build-instance($id):)
declare variable $desc:id {request:get-parameter('id', '')};
declare variable $desc:action {request:get-parameter('action', '')};

(:~
 : Transform tei to html
 : @param $node data passed to transform
 : Uses srophe-app xslt for conversion. 
:)
declare function desc:tei2html($nodes as node()*) {
    let $data-root := '/db/apps/srophe-data/'
    let $app-root := '/db/apps/srophe/'
    return 
    transform:transform($nodes, doc('/db/apps/srophe/resources/xsl/tei2html.xsl'), 
    <parameters>
        <param name="data-root" value="{$data-root}"/>
        <param name="app-root" value="{$app-root}"/>
    </parameters>
    )
};

declare function desc:build-list-html(){
<div xmlns="http://www.w3.org/1999/xhtml" style="margin: 1em;">
    {
    for $desc in collection('/db/apps/srophe-data/data/persons/tei/')//tei:note[parent::tei:person][not(empty(child::*))]
    let $id := string($desc/parent::tei:person/tei:idno[starts-with(.,'http://syriaca.org')]) (:substring-after(substring-before($desc/parent::tei:person/@xml:id,'-'),'person'):)
    let $title := string($desc/ancestor::tei:TEI/descendant::tei:title[1])
    return 
        <div style="margin: 1em; border-bottom:1px solid #ccc;">
            <h3>{$title}</h3>
            <p style="margin-top:-.5em;"><em>{$id}</em></p>
            {desc:tei2html($desc)}
        </div>
    }
</div>
};

declare function desc:build-list-tei(){
<div xmlns="http://www.w3.org/1999/xhtml" style="margin: 1em;">
    {
    for $desc in collection('/db/apps/srophe-data/data/persons/tei/')//tei:note[parent::tei:person][not(empty(child::*))]
    let $id := $desc/parent::tei:person/tei:idno[starts-with(.,'http://syriaca.org')] (:substring-after(substring-before($desc/parent::tei:person/@xml:id,'-'),'person'):)
    let $title := $desc/ancestor::tei:TEI/descendant::tei:title[1]
    order by $title
    return 
    <div class="section">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
            {($title,$id,$desc)}
        </TEI>
    </div>    
    }
</div>
};
