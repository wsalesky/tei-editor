xquery version "3.0";
(:~
 : Submit new data to data folder for review
 : Send email alert to appropriate editor?
:)
declare namespace request="http://exist-db.org/xquery/request";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
import module namespace http="http://expath.org/ns/http-client";
declare namespace httpclient="http://exist-db.org/xquery/httpclient";


(: Parse xml strings in text nodes into xml elements :)
declare function local:parse-text($nodes as node()*) as item()* {
    for $node in $nodes
    return
    typeswitch($node)
        case text() return 
            parse-xml-fragment($node)
        default return local:passthru($node)
};

declare function local:passthru($node as node()*) as item()* {
    element {name($node)} {($node/@*, local:parse-text($node/node()))}
};

let $data-root := '/db/apps/srophe-data/data/'
let $cache := 'change value to force refresh: 344' 
let $results := request:get-data()
return <div>
        <div>Testing note parsing having lots of issues.</div>
        {local:parse-text($results/*)}
        </div>(:local:parse-text($results):)