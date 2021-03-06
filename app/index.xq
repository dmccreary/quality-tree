import module namespace style = "http://danmccreary.com/style" at "modules/style.xqm";
let $title := 'Quality Attribute Utility Tree'

let $content :=
<div class="content">
     <p>This application creates and manages quality tree diagrams used in the architectural tradeoff modeling process.
     These structures are sometimes referred to as a utility tree.</p>
     <a href="views/list-quality-trees.xq">List Quality Trees</a><br/><br/>
     
     <a href="edit/edit.xq?new=true">New Tree</a>
     
     <h3>References</h3>
     <a href="http://example.com/link">Link Name</a> Link description<br/>

     
     <p>Please contact Dan McCreary (dan@danmccreary.com) if you have any feedback on this app.</p>
</div>

return style:assemble-page($title, $content)