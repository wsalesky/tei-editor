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

:)

let $data-root := '/db/apps/srophe-data/data/'
let $cache := 'change value to force refresh: 344' 
let $results := request:get-data()
let $id :=
   if (exists($results/descendant::*[tei:idno[@type='URI'][starts-with(.,'http://syriaca.org')]]))
      then replace($results/descendant::*[tei:idno[@type='URI'][starts-with(.,'http://syriaca.org')]],'/tei','')
      else 'unknown-form-id'      
let $file-name := concat(tokenize($id,'/')[last()], '.xml')
let $collection := substring-before(substring-after($id,'http://syriaca.org/'),'/')
let $path-name := concat($data-root,$collection, 's/tei/', $file-name)

let $overwrite :=
  if (doc-available($path-name))
    then true()
    else false()
    
let $store := xmldb:store($save-data-collection, $file-name, $formdata)

return
<save-results code="200">
    {if ($overwrite)
        then <message path="{$path-name}">Document updated at {$path-name}</message>
        else <message path="{$path-name}">New document saved to {$path-name}</message>
    }
</save-results>