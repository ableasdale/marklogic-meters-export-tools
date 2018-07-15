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
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.css" />
            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous"/>
            <title>{$title}</title>
        </head>
        <body>
            {$content}
            <!-- jQuery first, then Popper.js, then Bootstrap JS -->
            <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">{" "}</script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous">{" "}</script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous">{" "}</script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.js">{" "}</script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/mode/xml/xml.min.js">{" "}</script>
            <!-- Optional JavaScript -->
            {if(fn:empty($javascript)) then "" else $javascript}
        </body>
    </html>)
};

declare function lib-bootstrap:bootstrap-container($content as item()*) {
element div { attribute class {"container-fluid"}, $content }
};

declare function lib-bootstrap:display-with-muted-text($size as xs:int, $main as item()*, $sub as xs:string) as element() {
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
declare function lib-bootstrap:card-with-header($title as item(), $body as item()*) as element(div) {
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

declare function lib-bootstrap:four-column-row($one as xs:int, $two as xs:int, $three as xs:int, $four as xs:int, $content-one as item(), $content-two as item(), $content-three as item(), $content-four as item()) as element(div) {
    element div {attribute class {"row"},
        element div {attribute class {"col-"||$one}, $content-one},
        element div {attribute class {"col-"||$two}, $content-two},
        element div {attribute class {"col-"||$three}, $content-three},
        element div {attribute class {"col-"||$four}, $content-four}
    }
};