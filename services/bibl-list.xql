xquery version "3.0";
(:~
 : Build dropdown list of available resources for citation
:)

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace request="http://exist-db.org/xquery/request";

(:~
 : Builds xform and populates working instance from build-place-instance.xqm
 : @param $id passed to form for adding data to existing place, if no id new place will be created
 : NOTE need to add 'generate new id function for new records'
:)
(:forms:build-instance($id):)
declare variable $id {request:get-parameter('id', '')};
declare variable $element {request:get-parameter('element', '')};
declare variable $action {request:get-parameter('action', '')};

declare function local:build-list(){
<div xmlns="http://www.tei-c.org/ns/1.0">
    {
    for $bibl in collection('/db/apps/srophe-data/data/bibl/tei/')//tei:fileDesc[1]
    let $id := $bibl//tei:idno[1]
    let $title := $bibl//tei:title[1]
    order by $title ascending 
    return 
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
            <idno>{if(ends-with($id,'/tei')) then substring-before($id/text(),'/tei') else if(ends-with($id,'/source')) then substring-before($id/text(),'/source') else $id/text() }</idno>
            <title>{$title/text()}</title>
        </TEI>
    }
</div>
};

declare function local:pers-list(){
<div xmlns="http://www.tei-c.org/ns/1.0">
    {
    for $persName in collection('/db/apps/srophe-data/data/persons/tei/')//tei:persName[@syriaca-tags='#syriaca-headword'][starts-with(@xml:lang,'en')]
    let $id := $persName/parent::tei:person/tei:idno[starts-with(.,'http://syriaca.org/')]
    let $name-string := if($persName/child::*) then string-join($persName/child::*/text(),' ') else $persName/text()
    order by $name-string ascending 
    return 
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
            {$id}
            <name>{$name-string}</name>
        </TEI>
    }
</div>
};

declare function local:show-bibl(){
if($id) then
    for $bibl in collection('/db/apps/srophe-data/data/bibl/tei/')//tei:idno[@type = 'URI'][. = $id]
    let $rec := $bibl/ancestor::tei:TEI//tei:text
    return 
        (
        <h4>
            {
             for $title in $rec//tei:title
             return $title/text()
            }
        </h4>,
        for $author in $rec//tei:author
        return <p>Author: {$author/descendant::text()}</p>,
        for $editor in $rec//tei:editor
        return <p>Editor:  {$editor/descendant::text()}</p>,
        for $imprint in $rec/descendant::tei:imprint
        return <p>Imprint: {string-join($imprint/descendant::text(),' ')}</p>)
else ()
};

declare function local:build-bibl(){
if($id) then
    for $bibl in collection('/db/apps/srophe-data/data/bibl/tei/')//tei:idno[@type = 'URI'][. = $id]
    let $rec := $bibl/ancestor::tei:TEI//tei:text
    return 
    <bibl xml:id="bibl" xmlns="http://www.tei-c.org/ns/1.0">
        {
            for $author in $rec//tei:author
            return 
            <author>{string-join($author/descendant::text(),' ')}</author>,
            for $editor in $rec//tei:editor
            return <editor>{string-join($editor/descendant::text(),' ')}</editor>,
            for $title in $rec//tei:title
            return $title,
            <ptr target="{$id}"/>
        }
    </bibl>
else ()
};

declare function local:build-persName(){
if($id) then
    for $person in collection('/db/apps/srophe-data/data/persons/tei/')//tei:idno[. = $id]
    let $rec := $person/ancestor::tei:person
    return 
    <person xml:id="persnum" xmlns="http://www.tei-c.org/ns/1.0">
        {$rec}
    </person>
else ()
};

if($id != '') then 
    if($element = 'persName') then local:build-persName()
    else local:build-bibl()
else if($id != '' and $action='display') then local:show-bibl()
else if ($element = 'persName') then local:pers-list()
else local:build-list()
