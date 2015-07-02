xquery version "3.0";
(:~
 : Submit new data to data folder for review
 : Send email alert to appropriate editor?
:)
declare namespace request="http://exist-db.org/xquery/request";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:media-type "text/xml";

(:~

:)

declare function local:update(){
let $results := request:get-data()
let $newData := $results
return <dummy>{$newData}</dummy>
};

let $cache := 'change value to force refresh: 344'
return local:update()   
