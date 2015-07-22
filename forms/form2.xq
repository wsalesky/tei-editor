xquery version "1.0";

declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace xf="http://www.w3.org/2002/xforms";

(:~
 : Note need to add app:dir var, and use in configuring css
:)

(:~
: Here $node is the document or XML fragment to work on,
: $new-node is the new element to insert,
: $element-name-to-check is which other element to use as a reference for inserting $new-node,
: and $location gives the option of inserting $new-node before, after, or as the first or last child of $element-name-to-check.
: $location accepts four values: 'before', 'after', 'first-child', and 'last-child'
: (if another value is given, $element-name-to-check is removed).
:
: @author Jens Østergaard Petersen
: @param $node The XML document or fragment that one wishes to insert elements into.
: @param $new-node The element to insert.
: @param $element-name-to-check The element in $node in relation to which to insert $new-node.
: @param $location The location one wishes to insert $new-node in relation to $element-name-to-check.
    The options are "before", "after", "first-child" and "last-child".
: @return $node with $new-node inserted in the $location in relation to $element-name-to-check
:
: Adapted for use with teian and syriaca.org tei records
: @author Winona Salesky
:)

let $form-name := request:get-parameter("form", "")
let $form-path := $form-name
let $form-doc := doc($form-path)
let $params :=
    <parameters>
       <param name="omit-xml-declaration" value="yes"/>
       <param name="indent" value="no"/>
       <param name="media-type" value="text/html"/>
       <param name="method" value="xhtml"/>
       <param name="baseuri" value="/exist/rest/db/apps/xsltforms/"/>
    </parameters>

let $serialization-options := 'method=xml media-type=text/html omit-xml-declaration=yes indent=no'

let $xslt-pi := processing-instruction xml-stylesheet {'type="text/xsl" href="/db/apps/xsltforms/xsltforms.xsl"'}
let $css := processing-instruction css-conversion {'no'}
return ($xslt-pi,$css,'<!DOCTYPE html>',$form-doc)
   (:transform:transform($form-doc, doc('/db/apps/xsltforms/xsltforms.xsl'), $params,(),$serialization-options):)

(:($xslt-pi,$css-pi, $debug, $form-doc):)