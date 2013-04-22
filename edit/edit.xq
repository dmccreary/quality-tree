xquery version "1.0";

import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";

(: Document namespaces declarations :)

declare namespace xf="http://www.w3.org/2002/xforms";
declare namespace ev="http://www.w3.org/2001/xml-events";
declare namespace xhtml="http://www.w3.org/1999/xhtml";

let $new := request:get-parameter('new', '')
let $id := request:get-parameter('id', '')

return
(: check for required parameters :)
    if (not($new or $id)) then 
        <error>
            <message>Parameter "new" and "id" are both missing.  One of these two arguments is required for form.</message>
        </error>
    else

(: proceed :)

let $title := concat('Edit ', $id)
let $app-collection := $style:db-path-to-app
let $code-table-collection := concat($app-collection, '/code-tables')

(: put in the appropriate file name :)
let $file := 
    if ($new) then 
        'new-instance.xml'
    else 
        concat('get-instance.xq?id=', $id)

let $cancel :=
   if ($new)
      then '../'
      else  concat('../views/view-item.xq?id=', $id)

let $style :=
<xhtml:style language="text/css">
    <![CDATA[
        @namespace xf url("http://www.w3.org/2002/xforms");
        .block-form xf|label {
            width: 15ex;
        }
        
        /* make sure the select and select1 items don't float to the left */
        xf|select xf|item, xf|select1 xf|item {
            margin-left: 16ex;
        }

        .uri .xforms-value {width: 90ex;}
        .project-name .xforms-value {width: 80%;}
        
        .project-description textarea {
            height: 10ex;
            /* this makes the width of the project definition grow with screen size on window resize */
            width:80%;
        }
        .organization-name .xforms-value {width: 40ex;}
     
     fieldset {
        background-color: lavender;
     }
     
    legend {
       background-color: white;
       margin: 3px;
     }
     
     .qa-table-header tr {
        font-size: 14px;
     }
     
     /* table header widths and input form-value the sub quality attributes */
     .QualityAttributeDescription .xforms-value {width: 80%;}
     
      th.SubQAName {width: 25ex; border:}
     .SubQAName .xforms-value {width: 29ex;}
     /* SubQADescription2 */
     
     th.SubQAImportance {width: 11ex;}
     .SubQAImportance .xforms-value {width: 13ex;}
     
     th.SubQADifficulty {width: 12ex;}
     .SubQADifficulty .xforms-value {width: 14ex;}

    th.SubQADescription2 {width: 50ex;}
    .SubQADescription2 .xforms-value {width: 50ex;}
    ]]>
 </xhtml:style>

let $model :=
    <xf:model>
        <xf:instance id="save-data" src="{$file}"/>
        
        <xf:instance id="code-tables" src="all-codes.xq" xmlns=""/>
        
        <xf:instance xmlns="" id="quality-attribute-template">
            <quality-attribute>
                <name></name>
                <description></description>
                <quality-attribute2>
                   <name></name>
                   <importance>medium</importance>
                    <difficulty>medium</difficulty>
                    <description></description>
                </quality-attribute2>
            </quality-attribute>
        </xf:instance>
        
        <!-- this in inserted into each new row -->
         <xf:instance xmlns="" id="quality-attribute2-template">
            <quality-attribute2>
                <name></name>
                <importance>medium</importance>
                <difficulty>medium</difficulty>
                <description></description>
            </quality-attribute2>
        </xf:instance>
        
        <xf:instance xmlns="" id="views">
            <data>
               <delete-category-trigger/>
               <delete-tag-trigger/>
            </data>
        </xf:instance>
        
        <xf:bind nodeset="project-name" required="true()"/>
        <xf:bind nodeset="author/personname/firstname" required="true()"/>
        <xf:bind nodeset="author/personname/surname" required="true()"/>
        <xf:bind nodeset="quality-attributes/quality-attribute/name" required="true()"/>
        
        <!-- <xf:bind id="delete-category-trigger" nodeset="instance('views')/delete-category-trigger" 
            relevant="instance('save-data')/category[2]"/> -->
        
        <!-- If there is a second element, make the delete button visible. 
        <xf:bind id="delete-tag-trigger" nodeset="instance('views')/delete-tag-trigger" 
            relevant="instance('save-data')/nodes/node[2]"/>
            -->
        
        <xf:submission id="save" method="post" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" 
            instance="save-data" replace="all"/>
            
    </xf:model>
        
let $content :=
    <div class="content">
    
        <xf:submit submission="save">
           <xf:label>Save</xf:label>
        </xf:submit>
       
        <div class="block-form, layout-vertical">
    
            { (: only display the ID if we are not creating a new item :)
            if ($id) then 
                <xf:output ref="id" class="id">
                   <xf:label>ID:</xf:label>
                </xf:output>
            else ()}
            
           <fieldset class="layout-vertical">
              <legend>Project</legend>
                <xf:input ref="project-name" class="project-name">
                    <xf:label>Name:</xf:label>
                </xf:input>
                <xf:textarea ref="project-description" class="large project-description">
                    <xf:label>Description:</xf:label>
                </xf:textarea>
            </fieldset>
            <fieldset class="layout-vertical">
              <legend>Author</legend>
                <xf:input ref="author/personname/firstname">
                    <xf:label>First Name:</xf:label>
                </xf:input>
                
                <xf:input ref="author/personname/surname">
                    <xf:label>Last Name:</xf:label>
                </xf:input>
                
                <xf:input ref="author/email">
                    <xf:label>E-mail:</xf:label>
                </xf:input>
                
                <xf:input ref="author/orgname" class="organization-name">
                    <xf:label>Organization:</xf:label>
                </xf:input>
           </fieldset>
                
           
           <!--
           <xf:select1 ref="status"  class="status">
              <xf:label>Pub Status:</xf:label>
                 <xf:itemset nodeset="instance('code-tables')/code-table[name='publish-status-code']/items/item">
                   <xf:label ref="label"/>
                   <xf:value ref="value"/>
                </xf:itemset>
           </xf:select1>
           -->
          
       
        </div> <!-- end of block form layout -->
       
       <fieldset>
          <legend>Quality Attributes</legend>
             <xf:repeat nodeset="instance('save-data')/quality-attributes/quality-attribute" id="quality-attribute-repeat">
              <fieldset>
                 <div class="layout-vertical">
                     <xf:input ref="./name" class="QAName">
                       <xf:label>Name: </xf:label>
                     </xf:input>
                     <xf:input ref="./description" class="QualityAttributeDescription">
                        <xf:label>Description: </xf:label>
                     </xf:input>
                 </div>
                 <table class="repeat">
                    <thead class="qa-table-header">
                       <tr>
                         <th class="SubQAName">Sub Attribute Name</th>
                         <th class="SubQAImportance">Importance</th>
                         <th class="SubQADifficulty">Difficulty</th>
                         <th class="SubQADescription2">Description</th>
                       </tr>
                    </thead>
                 </table>
                 <xf:repeat nodeset="./quality-attribute2" id="quality-attribute2-repeat">

                      <xf:input ref="./name" class="SubQAName"/>
                      <xf:select1 ref="./importance" class="SubQAImportance">
                          <xf:itemset nodeset="instance('code-tables')/code-table[name='low-medium-high-code']/items/item">
                              <xf:label ref="./label"/>
                              <xf:value ref="./value"/>
                          </xf:itemset>
                      </xf:select1>
                      <xf:select1 ref="./difficulty" class="SubQADifficulty">
                          <xf:itemset nodeset="instance('code-tables')/code-table[name='low-medium-high-code']/items/item">
                              <xf:label ref="./label"/>
                              <xf:value ref="./value"/>
                          </xf:itemset>
                      </xf:select1>
                      <xf:input ref="./description" class="SubQADescription2"/>
                      
                      <xf:trigger>
                          <xf:label>X</xf:label>
                          <xf:delete nodeset="." ev:event="DOMActivate"/>
                     </xf:trigger>
                     <xf:trigger>
                          <xf:label>+</xf:label>
                          <xf:insert nodeset="." origin="instance('quality-attribute2-template')" ev:event="DOMActivate" at="index('quality-attribute2-repeat')" position="after"/>
                     </xf:trigger>
                  </xf:repeat>
                  <xf:trigger>
                          <xf:label>Delete This Quality Attribute</xf:label>
                          <xf:delete nodeset="." ev:event="DOMActivate"/>
                   </xf:trigger>
           </fieldset>
       </xf:repeat>
       
       <xf:trigger>
            <xf:label>Add Quality Attribute</xf:label>
            <xf:action ev:event="DOMActivate">
               <xf:insert context="instance('save-data')/quality-attributes" origin="instance('quality-attribute-template')" at="index('quality-attribute-repeat')" position="after"/>
            </xf:action>
       </xf:trigger>

      </fieldset>
      <br/>
       
       <xf:submit submission="save">
           <xf:label>Save</xf:label>
       </xf:submit>

    </div>
    
return style:assemble-form($title, (), $style, $model, $content, true())