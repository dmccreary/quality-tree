import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
import module namespace qt = "http://danmccreary.com/quality-tree" at "../modules/quality-tree.xqm";

let $title := 'View Quality Tree'
let $id := request:get-parameter('id', '')

let $trees := $qt:all-trees
let $tree := $trees[id=$id]
let $level-1-nodes := $tree/nodes/node

let $content :=
<div class="content">
   <table>
      <tbody>
        <tr>
           <th>Project Name:</th>
           <td>{$tree/project-name/text()}</td>
        </tr>
        <tr>
           <th>Author Name:</th>
           <td>{$tree/author/personname/firstname/text()} {' '} {$tree/author/personname/surname/text()}</td>
        </tr>
        <tr>
           <th>Description:</th>
           <td>{$tree/description/text()}</td>
        </tr>
       </tbody>
    </table>
    
    <table>
      <thead>
         <tr>
           <th>Name</th>
           <th>Importance</th>
           <th>Difficulty</th>
         </tr>
      </thead>
      <tbody>
        { for $node in $level-1-nodes
            return
            <tr>
               <th>{$node/node-name/text()}</th>
               { for $node2 in $node/node
              return
              <tr>
                <td>{$node2/node-name/text()}</td>
                <td>{$node2/importance/text()}</td>
                <td>{$node2/difficulty/text()}</td>
              </tr>
            }
            </tr>
            

        }
       </tbody>
    </table>
</div>

return style:assemble-page($title, $content)