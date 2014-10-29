xquery version "1.0";

import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";

(: all-codes.xq - get all the code tables for an XForms edit form :)

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $code-tables-collection := concat($style:app-home, '/code-tables')

(:
<code-tables-collection>{$code-tables-collection}</code-tables-collection>
 <!-- Code Tables used in the Template Edit XForms Application -->
:)
return
<code-tables>
   {doc(concat($code-tables-collection, '/low-medium-high-codes.xml'))}
</code-tables>
