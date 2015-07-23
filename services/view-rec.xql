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

declare variable $path {request:get-parameter('path', '')}; 

let $data-root := '/db/apps/srophe-data/data/'
let $cache := 'change value to force refresh: 344' 
let $id :=
   if (exists($path))
      then $path
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
return doc($path-name)