xquery version "3.0";
(:~
 : Submit new data to data folder for review
 : Send email alert to appropriate editor?
:)
declare namespace request="http://exist-db.org/xquery/request";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:media-type "text/xml";

(:~
let $data-root := xs:anyURI('/db/apps/srophe-forms/forms/data/')
let $cache := 'change value to force refresh: 344'
let $results := request:get-data()
let $file-name := concat('new', '.xml')
let $path-name := concat($data-root, $file-name)
'/db/apps/srophe-data/data/'
:)

let $data-root := '/db/apps/srophe-data/data/'
let $cache := 'change value to force refresh: 344' 
let $results := request:get-data()
let $id := replace($results/descendant::tei:idno[@type='URI'][starts-with(.,'http://syriaca.org')][1],'/tei','')
let $id :=
   if (exists($id))
      then $id
   else 'data/new.xml'
let $file-name := concat(tokenize($id,'/')[last()], '.xml')
let $collection := substring-before(substring-after($id,'http://syriaca.org/'),'/')
let $collection :=
    if($collection = 'place') then concat($data-root,'places/tei')
    else if($collection = 'person') then concat($data-root,'persons/tei')
    else if($collection = 'bibl') then concat($data-root,'bibl/tei')
    else if($collection = 'manuscript') then concat($data-root,'manuscripts/tei')
    else if($collection = 'work') then concat($data-root,'works/tei')
    else 'data'
let $path-name :=
    if(contains($collection, 'place')) then concat($data-root, 'persons/tei/', $file-name)
    else if(contains($collection, 'person')) then concat($data-root, 'places/tei/', $file-name)
    else if(contains($collection, 'bibl')) then concat($data-root, 'bibl/tei/', $file-name)
    else if(contains($collection,'manuscript')) then concat($data-root, 'manuscripts/tei/', $file-name)
    else if(contains($collection,'work')) then concat($data-root, 'works/tei/', $file-name)
    else concat('data/', $file-name)
return
        try {
        <data code="200">
            <message path="{$path-name}">New document saved: {(xmldb:login('/db/apps','admin',''), xmldb:store($collection, $file-name, $results))}</message>
        </data>
        } catch * {
        <data code="500">
            <message path="{$path-name}">Caught error {$err:code}: {$err:description}</message>
        </data>
        }