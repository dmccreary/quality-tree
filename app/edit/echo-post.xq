xquery version "1.0";
import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
import module namespace util2 = "http://danmccreary.com/util2" at "../modules/util2.xqm";

(: get-data() returns the document node.  We want the root node :)
let $results := request:get-data()/*


let $content :=
<div class="content">
  <style><![CDATA[
  /* Begin and end tag Delimiter */
.t {color: blue;}
/* Attribute Name and equal sign */
.an {color: orange;}
/* Attribute Values and equal sign */
.av {color: red;}
/* Element Data Content */
.d {color: black;}
  ]]></style>
   Nodes: { count($results//node()) }
   {util2:xml-to-html($results, 1)}
</div>

return style:assemble-page('result of post', $content)