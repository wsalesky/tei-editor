xquery version "3.0";
(:~
 : Increments the latest available uri (syr-id.xml) for syriaca.org data types
 : Used by forms/initialize.xhtml
:)

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace request="http://exist-db.org/xquery/request";
import module namespace functx="http://www.functx.com";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

(: Get new id node passed from xform, insert new values into syr-id.xml :)
(: Run with elevated privileges :)
let $results := request:get-data()
let $current := doc('syr-ids.xml')
return 
<data>
    <message>
    {
        try {
            (
            update value $current/descendant::*[@type = $results//id/@type]/@uri with $results//id/@uri,
            update value $current/descendant::*[@type = $results//id/@type]/@num with $results//id/@num
            )
         }
        catch * {
             concat($err:code, ": ", $err:description)
         }
    }
    </message>
</data>