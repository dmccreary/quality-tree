import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
import module namespace qt = "http://danmccreary.com/quality-tree" at "../modules/quality-tree.xqm";

let $title := 'View Quality Tree'
let $id := request:get-parameter('id', '')

let $trees := $qt:all-trees
let $tree := $trees[id=$id]
let $level-one-nodes := $tree/nodes/node
let $node-count := count($level-one-nodes)
let $code-table-path := concat($qt:code-table-collection, '/10-color-codes.xml')
let $color-codes :=
  if ($node-count le 10)
     then doc($code-table-path)//item
  else
     ()

return
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Static SVG Mockup</title>
    <defs>
        <g id="fork-right" stroke="black" stroke-width="3">
            <path d="M0 0 L20 20"/>
            <path d="M0 0 L20 -20"/>

        </g>
    </defs>
    <text x="10" y="20" colo ="black" font-family="Arial,Helvetica,sans-serif" font-weight="bold" font-size="16pt">Quality Attribute Utility Tree</text>
    <!-- for debugging 
    <text x="10" y="35" color="gray" font-family="Arial,Helvetica,sans-serif" font-weight="bold" font-size="10pt">{$code-table-path}</text>
    -->
    <text x="10" y="55" color="black" font-family="Arial,Helvetica,sans-serif" font-weight="bold" font-size="14pt">Project: {$tree/*:project-name/text()}</text>
    <g id="quality-attributes" font-family="Arial,Helvetica,sans-serif" font-weight="bold" >
    {for $node at $count in $level-one-nodes
     let $label := $node/*:node-name/text()
        return 
        <g transform="translate(10,{$count * 80})">        
            <rect rx="10" x="0" y="10" height="40" width="180" stroke="black" stroke-width="2" fill="{$color-codes[$count]/*:value/text()}"/>
            <!-- text-anchor can be middle -->
            <text x="90" y="37" style="text-anchor: middle" font-size="16pt">{$label}</text>
             <!-- black lines connecting boxes -->
            <use x="180" y="30" xlink:href="#fork-right"/>
            <!-- right boxes -->
            <g transform="translate(200, -10)">
              <rect rx="10" x="0" y="10" height="30" width="230" stroke="black" stroke-width="2" fill="{$color-codes[$count]/*:value/text()}"/>
              <text x="115" y="33" style="text-anchor: middle" font-size="12pt">{$node/*:node[1]/*:node-name/text()}</text>
            </g>
            <g transform="translate(450, -10)">
              <text x="0" y="33" style="text-anchor: left" font-size="12pt" font-weight="normal">
                 {$node/*:node[1]/*:description/text()} {' '}
                 ({$node/*:node[1]/*:importance/text()} {', '}
                 {$node/*:node[1]/*:difficulty/text()})
              </text>
            </g>
            
            <!-- lower box -->
            <g transform="translate(200, 25)">
              <rect rx="10" x="0" y="10" height="30" width="230" stroke="black" stroke-width="2" fill="{$color-codes[$count]/*:value/text()}"/>
              <text x="115" y="33" style="text-anchor: middle" font-size="12pt">{$node/*:node[2]/*:node-name/text()}</text>
            </g>
            <g transform="translate(450, 25)">
              <text x="0" y="33" style="text-anchor: left" font-size="12pt" font-weight="normal">
                 {$node/*:node[2]/*:description/text()} {' '}
                 ({$node/*:node[2]/*:importance/text()} {', '}
                 {$node/*:node[2]/*:difficulty/text()})
              </text>
            </g>
            
        </g>
     }
    </g>
</svg>