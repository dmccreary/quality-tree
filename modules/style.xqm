xquery version "3.0";

module namespace style = "http://danmccreary.com/style";
(:
import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";
:)

declare namespace request="http://exist-db.org/xquery/request";
declare namespace xf="http://www.w3.org/2002/xforms";
declare namespace xrx="http://code.google.com/p/xrx";
declare namespace repo="http://exist-db.org/xquery/repo";

declare variable $style:context := request:get-context-path();
declare variable $style:app-home := '/db/apps/quality-tree';
declare variable $style:repo-file-path := concat($style:app-home, '/repo.xml');
declare variable $style:repo-doc := doc($style:repo-file-path)/repo:meta;

declare variable $style:web-path-to-site := $style:app-home;
declare variable $style:rest-path-to-site := concat($style:context, '/rest', $style:web-path-to-site);
declare variable $style:web-path-to-app := style:substring-before-last-slash(style:substring-before-last-slash(substring-after(request:get-uri(), '/rest')));
declare variable $style:rest-path-to-app := concat($style:context, '/rest', $style:web-path-to-app);

declare variable $style:db-path-to-site  := concat('xmldb:exist://',  $style:web-path-to-site);
declare variable $style:db-path-to-app  := concat('xmldb:exist://', $style:web-path-to-app) ;
declare variable $style:db-path-to-app-data := concat($style:app-home, '/data');

declare variable $style:app-id := $style:repo-doc//repo:target/text();
declare variable $style:app-name := 'Quality Tree';

declare variable $style:site-resources := concat($style:app-home, '/resources');
declare variable $style:rest-path-to-style-resources := concat($style:context, '/rest', $style:site-resources);
declare variable $style:site-images := concat($style:site-resources, '/images');
declare variable $style:site-scripts := concat($style:site-resources, '/js');
declare variable $style:rest-path-to-images := concat($style:context, '/rest', $style:site-images);

 (: home = 1, apps = 2 :)
 declare function style:web-depth-in-site() as xs:integer {
(: if the context adds '/exist' then the offset is six levels.  If the context is '/' then we only need to subtract 5 :)
let $offset := 
   if ($style:context)
then 4 else 3
    return count(tokenize(request:get-uri(), '/')) - $offset
};

declare function style:header()  as node()*  {
    <div id="header">
        <div id="banner-login"> {
            let $current-user := xmldb:get-current-user()
            return
               if ($current-user eq 'guest')
                  then ()
                  else
                     <a href="{$style:web-path-to-app}/admin/user-prefs.xq">{concat("Logged in as user: ", $current-user)}</a>
        } </div>
       
        <div id="banner">
            <span id="logo"><a href="{$style:rest-path-to-site}/index.xq">
            <img src="{$style:rest-path-to-images}/univ-richmond-logo.png" alt="Boatwright Memoria Library"/></a></span>   
            
            <span id="banner-header-text">Kelly-McCreary &amp; Associates Quality Tree</span>
            
            <!--
            <div id="banner-search">
                <form method="GET" action="{$style:rest-path-to-site}/apps/search/search.xq">
                    <strong>Search:</strong>
                    <input name="q" type="text"/>
                    <input type="submit" value="Search"/>
                </form>
            </div>
            -->
        </div>
        <div class="banner-seperator-bar"/>
    </div>   
};

declare function style:footer()  as node()*  {
<div id="footer">
   <div class="banner-seperator-bar"/>
   
   <div id="footer-text">Copyright 2013 Kelly-McCreary &amp; Associates. All rights reserved.
      <a href="mailto:dan@danmccreary.com">Feedback</a>
   </div>
</div>
};

declare function style:breadcrumbs($suffix as node()*) as node() {
   <div class="breadcrumbs">
      <a href="{$style:rest-path-to-site}/index.xq">Home</a>
      
      &gt; <a href="{$style:rest-path-to-site}/apps/index.xq">Apps</a>
      
      {if (style:web-depth-in-site() > 2) then
      (' &gt; ',
      <a href="{$style:rest-path-to-site}/apps/{$style:app-id}/index.xq">Quality Tree</a>
      )
      else ()}
      
      {if ($suffix) then (' &gt; ', $suffix) else ()}
   </div>
};

declare function style:css($page-type as xs:string) 
as node()+ {
    if ($page-type eq 'xhtml') then 
        (
            <link rel="stylesheet" href="{$style:rest-path-to-style-resources}/blueprint/screen.css" type="text/css" media="screen, projection" />,
            <link rel="stylesheet" href="{$style:rest-path-to-style-resources}/blueprint/print.css" type="text/css" media="print" />,<!--[if IE ]><link rel="stylesheet" href="{$style:site-css}/blueprint/ie.css" type="text/css" media="screen, projection" /><![endif]-->,
            <link rel="stylesheet" href="{$style:rest-path-to-style-resources}/style.css" type="text/css" media="screen, projection" />
        )
    else if ($page-type eq 'xforms') then 
        <link rel="stylesheet" href="{$style:rest-path-to-style-resources}/xforms.css.xq" type="text/css" />
    else ()
};

declare function style:assemble-page($title as xs:string*, $breadcrumbs as node()*, 
                                     $style as element()*, $content as node()+) as element() {
    (
    util:declare-option('exist:serialize', 'method=xhtml media-type=text/html indent=yes')
    ,
    <html 
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xf="http://www.w3.org/2002/xforms" 
        xmlns:ev="http://www.w3.org/2001/xml-events" 
        xmlns:bf="http://betterform.sourceforge.net/xforms" 
        xmlns:bfc="http://betterform.sourceforge.net/xforms/controls"
    >
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <link rel="shortcut icon" href="{$style:site-images}/favicon.ico"/>
            <title>{ $title }</title>
        </head>
        <body>
            { style:css('xhtml') }
            { $style }
            <div class="container">
                { style:header() } 
                { style:breadcrumbs($breadcrumbs) }
                <div class="inner" style="line-height: 1.5em;">
                    <div class="pageTitle">
                        <table class="pageTitle">
                            <thead>
                                <tr>
                                    <th class="pageTitle"><h4>{$title}</h4></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    { $content }
                </div>
                { style:footer() }
            </div>
        </body>
     </html>
     )
};

(: Just pass title and content.  Put in the default breadcrumb and null for style :)
declare function style:assemble-page($title as xs:string, $content as node()+) as element() {
    style:assemble-page($title, (), (), $content)
};

declare function style:substring-before-last-slash($arg as xs:string?)  as xs:string {
       
   if (matches($arg, '/'))
   then replace($arg,
            concat('^(.*)', '/','.*'),
            '$1')
   else ''
 } ;