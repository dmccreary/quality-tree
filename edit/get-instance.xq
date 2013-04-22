xquery version "1.0";
import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
(: an XQuery to make sure the result is not cached :)
let $id := request:get-parameter('id', '')
return collection($style:data-collection)/quality-tree[id=$id]