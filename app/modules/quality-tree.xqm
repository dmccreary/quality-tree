xquery version "3.0";

module namespace qt = "http://danmccreary.com/quality-tree";
(:
import module namespace qt = "http://danmccreary.com/quality-tree" at "../modules/quality-tree.xqm";
:)
declare namespace svg="http://www.w3.org/2000/svg";

declare variable $qt:app-collection := '/db/apps/quality-tree';
declare variable $qt:data-collection := concat($qt:app-collection, '/data');
declare variable $qt:code-table-collection := concat($qt:app-collection, '/code-tables');
declare variable $qt:config-collection := concat($qt:app-collection, '/config');
declare variable $qt:default-config-path := concat($qt:config-collection, '/default.xml');
declare variable $qt:default-config := doc($qt:default-config-path)/config;

declare variable $qt:all-trees := collection($qt:data-collection)/quality-tree;

declare function qt:tree($id as xs:string) {
$qt:all-trees[id=$id]
};

(: ({$attribute/*:importance/text()} 
                         {$attribute/*:difficulty/text()}){', '}
 <text x="0" y="33" font-size="10pt" font-weight="normal">
:)
declare function qt:importance-difficulty-svg-text($quality-attribute2 as node()) as node()* {
let $importance := $quality-attribute2/*:importance/text()
let $difficulty := $quality-attribute2/difficulty/text()
let $description := $quality-attribute2/description/text()
let $imp-def := concat('(', qt:value-to-letter-lookup($importance), ',', qt:value-to-letter-lookup($difficulty), ')')
let $imp-def-text :=
if ($importance = 'high' and $difficulty = 'high')
   then <svg:text x="0" y="33" font-size="10pt" font-weight="normal" fill="red" stroke="red">{$imp-def}</svg:text>
   else if ($importance = 'high' and $difficulty = 'medium')
   then <svg:text x="0" y="33" font-size="10pt" font-weight="normal"  fill="orange"  stroke="orange">{$imp-def}</svg:text>
   else <svg:text x="0" y="33" font-size="10pt" font-weight="normal"  fill="green">{$imp-def}</svg:text>
return
  ($imp-def-text,
  <svg:text x="35" y="33" font-size="10pt" font-weight="normal" fill="black">{$description}</svg:text>)
};

declare function qt:value-to-letter-lookup($value as xs:string) as xs:string {
     if ($value = 'low') then 'L'
else if ($value = 'medium') then 'M'
else if ($value = 'high') then 'H'
else 'unknown'
};
