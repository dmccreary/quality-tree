xquery version "1.0";

(: Update Item :)

import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
 
(: we get these from the stype module :)
let $app-collection := $style:app-collection
let $data-collection := $style:data-collection
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $item := request:get-data()/*

(: get the id out of the posted document :)
let $id := string($item/id)
let $title := concat('Update Confirmation for item ', $id)
let $old-doc := collection($data-collection)/quality-tree[id = $id]
let $file-name := util:document-name($old-doc) 
 
(: this saves the new file and overwrites the old one :)
let $store := xmldb:store($data-collection, $file-name, $item)
let $doc := collection($data-collection)/quality-tree[id = $id]
let $update := update value $doc/last-modified-by with xmldb:get-current-user()
let $update := update value $doc/last-modified-datetime with current-dateTime()
let $content := 
    <div>
        <p>Item {$id} has been updated.</p>
        
        
        <br/>
        {style:edit-controls($id, 'evpx')}
    </div>
    
return style:assemble-page($title, $content)