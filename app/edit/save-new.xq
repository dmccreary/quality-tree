xquery version "1.0";

(: Save New Item :)

import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";

(: we get these from the stype module :)
let $app-collection := $style:app-collection
let $data-collection := $style:data-collection
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $item := request:get-data()


(: get the next ID from the POST :)

(: get the next ID from the next-id.xml file :)
let $next-id-file-path := concat($app-collection,'/edit/next-id.xml')
let $id := doc($next-id-file-path)/data/next-id/text() 
let $title := concat('Save Item ', $id)
let $file := concat($id, '.xml')

(: this creates the new file with a still-empty id element :)
let $store := xmldb:store($data-collection, $file, $item)


(: this adds the correct ID to the new document we just saved :)
let $update-id := update replace doc(concat($data-collection, '/', $file))/item/id with <id>{$id}</id>

let $doc := collection($data-collection)/item[./id/text() = $id]
let $update := update value $doc/created-by with xmldb:get-current-user()
let $update := update value $doc/created-datetime with current-dateTime()
let $update := update value $doc/last-modified-by with xmldb:get-current-user()
let $update := update value $doc/last-modified-datetime with current-dateTime()

(: this updates the next-id.xml file :)
let $new-next-id := update replace doc($next-id-file-path)/data/next-id/text() with ($id + 1)

(: we need to return the original ID number in our results, but $id has already been increased by 1 :)
let $original-id := string($id - 1)

let $content := 
    <div>
        <p>Item {$original-id} has been saved.</p>
       {style:edit-controls($original-id, 'evpx')}
    </div>

return style:assemble-page($title, $content)