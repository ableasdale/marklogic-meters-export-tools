xquery version "1.0-ml";

module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap";

declare namespace xdmp = "http://marklogic.com/xdmp";

declare function lib-bootstrap:create-starter-template($title as xs:string, $content as item()*) as item()* {
    lib-bootstrap:create-starter-template($title, $content, ())
};

declare function lib-bootstrap:create-starter-template($title as xs:string, $content as item()*, $javascript as item()*) as item()* {
    (xdmp:set-response-content-type("text/html; charset=utf-8"),
    "<!doctype html>",
    <html lang="en">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            <!-- Bootstrap CSS -->
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous"/>
            <title>{$title}</title>
        </head>
        <body>
            {$content}
            <!-- Optional JavaScript -->
            {if(fn:empty($javascript)) then "" else $javascript}
            <!-- jQuery first, then Popper.js, then Bootstrap JS -->
            <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous">{" "}</script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous">{" "}</script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js" integrity="sha384-a5N7Y/aK3qNeh15eJKGWxsqtnX/wWdSZSKp+81YjTmS15nvnvxKHuzaWwXHDli+4" crossorigin="anonymous">{" "}</script>
        </body>
    </html>)
};

declare function lib-bootstrap:bootstrap-container($content as item()*) {
element div { attribute class {"container"}, $content }
};

declare function lib-bootstrap:display-with-muted-text($size as xs:int, $main as xs:string, $sub as xs:string) as element() {
element {"h"||$size} {$main || " ", element small { attribute class {"text-muted"}, $sub}}
};

declare function lib-bootstrap:lead-paragraph($text) as element(p){
element p {attribute class {"lead"}, $text}
};

(: Display headers :)

declare function lib-bootstrap:display-header($size as xs:int, $heading as xs:string, $subheading as xs:string) as element() {
element {"h"||$size} {attribute class {"display-"||$size}, $heading|| " ", element small { attribute class {"text-muted"}, $subheading}}
};

declare function lib-bootstrap:display-header($size as xs:int, $heading as xs:string) as element() {
element {"h"||$size} {attribute class {"display-"||$size}, $heading}
};

(: Blockquote :)

declare function lib-bootstrap:blockquote($quote as xs:string, $footer-text as xs:string, $citation-title as xs:string, $justification as xs:string) as element(blockquote) {
<blockquote class="blockquote {$justification}">
<p class="mb-0">{$quote}</p>
<footer class="blockquote-footer">{$footer-text||" "} <cite title="{$citation-title}">{$citation-title}</cite></footer>
</blockquote>
};


(: Card :)
declare function lib-bootstrap:card-with-header($title as xs:string, $body as item()*) as element(div) {
<div class="card">
<h5 class="card-header">{$title}</h5>
<div class="card-body">{$body}</div>
</div>
};

(: Figure :)
declare function lib-bootstrap:figure($img-src as xs:string, $alt as xs:string, $caption as xs:string) as element(figure) {
<figure class="figure">
<img src="{$img-src}" class="figure-img img-fluid rounded" alt="{$alt}" />
<figcaption class="figure-caption">{$caption}</figcaption>
</figure>
};


(: Layout :)
declare function lib-bootstrap:two-column-row($left as xs:int, $right as xs:int, $content-left as item(), $content-right as item()) as element(div) {
element div {attribute class {"row"},
element div {attribute class {"col-"||$left}, $content-left},
element div {attribute class {"col-"||$right}, $content-right}
}
};

declare function lib-bootstrap:three-column-row($left as xs:int, $centre as xs:int, $right as xs:int, $content-left as item(), $content-centre as item(), $content-right as item()) as element(div) {
element div {attribute class {"row"},
element div {attribute class {"col-"||$left}, $content-left},
element div {attribute class {"col-"||$centre}, $content-centre},
element div {attribute class {"col-"||$right}, $content-right}
}
};