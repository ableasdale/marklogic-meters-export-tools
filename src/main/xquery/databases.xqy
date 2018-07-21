xquery version "1.0-ml";

import module namespace lib-view = "http://www.xmlmachines.com/lib-view" at "/lib/lib-view.xqy";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace cts = "http://marklogic.com/cts";

declare variable $doc := if (string-length($lib-view:URI) gt 0) 
then (fn:doc($lib-view:URI))
else ();
    
declare function local:back-link() {
    let $start-time := cts:element-values(xs:QName("m:start-time"), fn:data($doc/m:database-statuses/m:period-start-time), ("descending", "limit=2"))[2]
    let $prev-doc := cts:search(doc()/m:database-statuses, lib-view:and-query($start-time, $lib-view:HOST))
    return if (not(empty($start-time)))
    then(lib-view:build-href("prev-link", $lib-view:MODULE, fn:base-uri($prev-doc), fn:string($start-time), $lib-view:HOST, "<"))
    else("<")
};

declare function local:next-link() {
    let $start-time := cts:element-values(xs:QName("m:start-time"), fn:data($doc/m:database-statuses/m:period-start-time), ("ascending", "limit=2"))[2]
    let $next-doc := cts:search(doc()/m:database-statuses, lib-view:and-query($start-time, $lib-view:HOST))
    return if (not(empty($start-time)))
    then(lib-view:build-href("next-link", $lib-view:MODULE, fn:base-uri($next-doc), fn:string($start-time), $lib-view:HOST, ">"))
    else(">")
};

declare function local:process-row($i) {
(:$i//m:start-time,
  $i//m:list-cache-hits,
  $i//m:list-cache-misses :)
    element table { attribute class {"table table-striped table-bordered"},
        element thead { attribute class {"thead-dark"},
        element tr {for $i in ( "Name", <abbr title="Nonblocking Timestamp">NBT</abbr>, <abbr title="Active Fragment Count">AFC</abbr>, <abbr title="Deleted Fragment Count">DFC</abbr>, <abbr title="List Cache Hits / Rate">LCH</abbr>, <abbr title="List Cache Misses / Rate">LCM</abbr>, <abbr title="Compressed Tree Cache Hits / Rate">CTCH</abbr>, <abbr title="Compressed Tree Cache Misses / Rate">CTCM</abbr>, <abbr title="Deadlock Count / Rate">DLC</abbr>, <abbr title="Write Lock Count / Rate">WLC</abbr>, "Fragments [A/D]") return element th {$i}}
        },
(: 
        , <abbr title="User CPU Utilisation (%)">Usr</abbr>, <abbr title="System CPU Utilisation (%)">Sys</abbr>, <abbr title="System Swap-In Rate">SI</abbr>, <abbr title="System Swap-Out Rate">SO</abbr>, <abbr title="Read Lock Count">RLC</abbr>, <abbr title="Read Lock Rate">RLR</abbr>, <abbr title="Deadlock Count">DLC</abbr>, <abbr title="Deadlock Rate">DLR</abbr>
    "Start Time", "End Time", :)

        local:process-forest-status-elements($i)
    }
};

declare function local:process-forest-status-elements($i) {
    element tbody {
        for $j in $i/m:database-status
        return
            element tr {
            (: )element td {fn:data($j/m:start-time)},
        element td {fn:data($j/m:end-time)}, :)
                element td {fn:string($j/m:database-name)},
                element td {fn:string($j/m:master-aggregate/m:nonblocking-timestamp)},
                element td {fn:string($j/m:master-aggregate/m:active-fragment-count)},
                element td {fn:string($j/m:master-aggregate/m:deleted-fragment-count)},
                element td {fn:string($j/m:master-aggregate/m:list-cache-hits) || " / " || fn:string($j/m:master-aggregate/m:list-cache-hit-rate)},
                element td {fn:string($j/m:master-aggregate/m:list-cache-misses) || " / " || fn:string($j/m:master-aggregate/m:list-cache-miss-rate)},
                element td {fn:string($j/m:master-aggregate/m:compressed-tree-cache-hits) || " / " || fn:string($j/m:master-aggregate/m:compressed-tree-cache-hit-rate)},
                element td {fn:string($j/m:master-aggregate/m:compressed-tree-cache-misses) || " / " || fn:string($j/m:master-aggregate/m:compressed-tree-cache-miss-rate)},
                element td {fn:string($j/m:master-aggregate/m:deadlock-count) || " / " || fn:string($j/m:master-aggregate/m:deadlock-rate)},
                element td {fn:string($j/m:master-aggregate/m:write-lock-count) || " / " || fn:string($j/m:master-aggregate/m:write-lock-rate)}
                (: || " / " || fn:string($j/m:memory-process-rss)} :)
                (:
                element td {fn:string($j/m:list-cache-misses) },
                element td {fn:string($j/m:compressed-tree-cache-hits) || " / " || fn:string($j/m:compressed-tree-cache-hit-rate)},
                element td {fn:string($j/m:compressed-tree-cache-misses) || " / " || fn:string($j/m:compressed-tree-cache-miss-rate)},
                element td {fn:string($j/m:write-lock-count)},
                element td {fn:string($j/m:deadlock-count)},
                element td {fn:string($j/m:active-fragment-count) || " / " || fn:string($j/m:deleted-fragment-count)} :)
            }
    }
}; 

lib-bootstrap:create-starter-template("Database status for host: "|| fn:string($doc//m:host-name),
    lib-bootstrap:bootstrap-container(
        (
            lib-view:nav(),
            lib-view:top-page-summary($lib-view:URI, $doc),

            lib-bootstrap:four-column-row(1,5,5,1, 
                local:back-link(), 
                lib-bootstrap:display-with-muted-text(5, " Start Time: ",  fn:string(($doc//m:start-time)[1])), 
                lib-bootstrap:display-with-muted-text(5, "End Time: ",  fn:string(($doc//m:end-time)[1])), 
                local:next-link()
            ),
            for $i in $doc/m:database-statuses
            return local:process-row($i),
            lib-view:render-xml-doc($doc)
        )
    ), <script src="/js.js">{" "}</script>
)