xquery version "3.0";

module namespace qt = "http://danmccreary.com/quality-tree";
(:
import module namespace qt = "http://danmccreary.com/quality-tree" at "../modules/quality-tree.xqm";
:)

declare variable $qt:app-collection := '/db/apps/quality-tree';
declare variable $qt:data-collection := concat($qt:app-collection, '/data');
declare variable $qt:code-table-collection := concat($qt:app-collection, '/code-tables');

declare variable $qt:all-trees := collection($qt:data-collection)/quality-tree;

declare function qt:tree($id as xs:string) {
$qt:all-trees[id=$id]
};

