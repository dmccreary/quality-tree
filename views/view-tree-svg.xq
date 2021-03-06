import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
import module namespace qt = "http://danmccreary.com/quality-tree" at "../modules/quality-tree.xqm";


let $id := request:get-parameter('id', '')
let $debug := xs:boolean(request:get-parameter('debug', 'true'))

let $trees := $qt:all-trees
let $tree := $trees[id=$id]

(: TODO detect duplicates here - there should only be one tree :)
let $level-one-nodes := $tree//quality-attribute
let $author := concat($tree//personname/firstname/text(), ' ', $tree//personname/surname/text()) 

let $node-count := count($level-one-nodes)
let $code-table-path := concat($qt:code-table-collection, '/10-color-codes.xml')
let $default-config := $qt:default-config

let $level-one-font-size := $default-config/*:level-1/*:font-size/text()
let $level-one-box-height := $default-config/*:level-1/*:box-height/text()

(: count the max characters and assume 10 pixals per characer average :)
let $level-one-box-width :=
    max(
       for $name in $level-one-nodes/name
       return string-length($name)
       ) * 10

let $level-two-font-size := $default-config/*:level-2/*:font-size/text()
let $level-two-box-height := $default-config/*:level-2/*:box-height/text()
let $level-two-box-width := $default-config/*:level-2/*:box-width/text()

let $color-codes :=
  if ($node-count le 10)
     then doc($code-table-path)//item
  else
     ()

let $title := $tree/*:project-name/text()

return
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>{$title}</title>
    <defs>
        <g id="fork-right" stroke="black" stroke-width="3">
            <path d="M0 0 L20 20"/>
            <path d="M0 0 L20 -20"/>
        </g>
    </defs>
    <g id="page-header" transform="translate(0, 10)">
       <text x="10" y="20" colo ="black" font-family="{$qt:default-config/*:font-family/text()}" font-weight="bold" font-size="{$level-one-font-size}">Quality Attribute Utility Tree</text>
       <text x="10" y="35" color="black" font-family="Arial,Helvetica,sans-serif" font-weight="bold" font-size="{$level-one-font-size}">Project: {$title}</text>
    </g>
    {if ($debug) then
    <g id="debug" transform="translate(0, 30)">
       <text x="10" y="35" color="gray" font-family="Arial,Helvetica,sans-serif" font-weight="bold" font-size="10pt">Author: {$author}</text>
       <text x="10" y="50" color="gray" font-family="Arial,Helvetica,sans-serif" font-weight="bold" font-size="10pt">Description: {$tree//*:project-description/text()}</text>
    </g>
    else ()}
    
    <g id="quality-tree" font-family="Arial,Helvetica,sans-serif" font-weight="bold" transform="translate(0, 15)">
    
    {for $node at $count in $level-one-nodes
     let $label := $node/*:name/text()
        return 
        <g transform="translate(10,{$count * 80})">        
            <rect rx="10" x="0" y="10" height="{$level-one-box-height}" width="{$level-one-box-width}" stroke="black" stroke-width="2" fill="{$color-codes[$count]/*:value/text()}"/>
            <!-- text-anchor can be middle -->
            <text x="{$level-one-box-width div 2}" y="30" style="text-anchor: middle" font-size="{$level-one-font-size}">{$label}</text>
            
            <!-- black lines connecting boxes -->
            <use x="{$level-one-box-width}" y="{$level-one-box-height}" xlink:href="#fork-right"/>
            
            <!-- right boxes -->
            {for $attribute at $att-count in $node/*:quality-attribute2
               let $vertical-offset := $att-count * 40 -45
               return
                <g transform="translate(0, {$vertical-offset})">
                    <g transform="translate({$level-one-box-width + 20}, -10)">
                      <rect rx="10" x="0" y="10" height="{$level-two-box-height}" width="{$level-two-box-width}" stroke="black" stroke-width="2" fill="{$color-codes[$count]/*:value/text()}"/>
                      <text x="{$level-two-box-width div 2}" y="{$level-two-box-height + 4}" style="text-anchor: middle" font-size="{$level-two-font-size}">{$attribute/*:name/text()}</text>
                    </g>
                    <g transform="translate({$level-one-box-width + $level-two-box-width + 30}, -15)">
                         {qt:importance-difficulty-svg-text($attribute)}
                    </g>
                </g>
            }
            
        </g>
     }
    </g>
</svg>