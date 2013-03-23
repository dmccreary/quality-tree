import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
import module namespace qt = "http://danmccreary.com/quality-tree" at "../modules/quality-tree.xqm";

let $title := 'List Quality Trees'

let $trees := $qt:all-trees

let $content :=
<div class="content">
   <table>
      <thead>
         <tr>
            <th>Name</th>
            <th>Last Modified</th>
         </tr>
      </thead>
      <tbody>
        {for $tree in $trees
         let $id := $tree/id/text()
         let $document-name := util:document-name($tree)
         let $last-modified := xmldb:last-modified($style:db-path-to-app-data, $document-name)
         return
            <tr>
               <th><a href="view-tree.xq?id={$id}">{$tree/project-name/text()}</a></th>
               <th><a href="view-tree-svg.xq?id={$id}">SVG</a></th>
               <td>{$last-modified}</td>
            </tr>
         }
       </tbody>
    </table>
</div>

return style:assemble-page($title, $content)