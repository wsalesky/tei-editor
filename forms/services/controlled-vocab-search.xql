xquery version "3.0";

(:~
 : NOTE: Handle all lookups for controlled vocab. change name
 : Build dropdown list of available resources for citation
:)

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace request="http://exist-db.org/xquery/request";


(:forms:build-instance($id):)
declare variable $id {request:get-parameter('id', '')};
declare variable $q {request:get-parameter('q', '')};
declare variable $element {request:get-parameter('element', 'person')};
declare variable $action {request:get-parameter('action', '')};

declare variable $data-root := '/db/apps/srophe-data/' ;

(:
 : Build xpath for search
 concat("collection('",$config:data-root,$collection,"')//tei:body",
    places:keyword(),
    places:place-name(),
    persons:name()
    )
    [ft:query(.,'",common:clean-string($persons:q),"',common:options())]
:)
declare function local:build-path() as xs:string*{
if($element = 'persName') then concat("collection('",$data-root,"data/persons/tei')//tei:persName[parent::tei:person][ft:query(.,'",$q,"',local:options())]") 
else if($element = 'placeName') then concat("collection('",$data-root,"data/places/tei')//tei:placeName[parent::tei:place][ft:query(.,'",$q,"',local:options())]")
else if($element = 'bibl') then concat("collection('",$data-root,"data/bibl/tei')//tei:title[parent::tei:titleStmt][ft:query(.,'",$q,"',local:options())]")
else if($element != '') then concat("collection('",$data-root,"data')//tei:",$element,"[ft:query(.,'",$q,"',local:options())]")
else concat("collection('",$data-root,"data')//child::*",$element,"[ft:query(.,'",$q,"',local:options())]")
};

(:
 : Evaluate path, build results 
 element { $key } { map:get($map, $key) }
 element { xs:QName("blog:example") } {
  if ($condition) then attribute simple { "true" } else (),
  element { xs:QName("blog:pointless") } { }
}
<persName ref="{$id}">{$name-string}</persName>
:)
declare function local:search-name(){
<results xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
{
let $hits := util:eval(local:build-path())
for $hit in $hits
let $id := replace($hit/ancestor-or-self::tei:TEI/descendant::tei:publicationStmt/descendant::tei:idno[starts-with(.,'http://syriaca.org')],'/tei','')
let $name-string := if($hit/child::*) then string-join($hit/child::*/text(),' ') else $hit/text() 
return 
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
            {
             element { $element } { 
                attribute ref { $id }, 
                $name-string
                }
            }
        </TEI>
        }
</results>        
};

(:~
 : Search options passed to ft:query functions
:)
declare function local:options(){
    <options>
        <default-operator>and</default-operator>
        <phrase-slop>1</phrase-slop>
        <leading-wildcard>no</leading-wildcard>
        <filter-rewrite>yes</filter-rewrite>
    </options>
};

if($q != '') then local:search-name()
else ()
