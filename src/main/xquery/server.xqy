xquery version "1.0-ml";

import module namespace lib-view = "http://www.xmlmachines.com/lib-view" at "/lib/lib-view.xqy";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace cts = "http://marklogic.com/cts";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare variable $doc := if (string-length($lib-view:URI) gt 0) 
then (fn:doc($lib-view:URI))
else ();

declare function local:back-link() {
    let $start-time := cts:element-values(xs:QName("m:start-time"), fn:data($doc/m:server-statuses/m:period-start-time), ("descending", "limit=2"))[2]
    let $prev-doc := cts:search(doc()/m:server-statuses, lib-view:and-query($start-time, $lib-view:HOST))
    return if (not(empty($start-time)))
    then (lib-view:build-href("prev-link", $lib-view:MODULE, fn:base-uri($prev-doc), fn:string($start-time), $lib-view:HOST, $lib-view:DATABASE, "<"))
    else("<")
};

declare function local:next-link() {
  let $start-time := cts:element-values(xs:QName("m:start-time"), fn:data($doc/m:server-statuses/m:period-start-time), ("ascending", "limit=2"))[2]
  let $next-doc := cts:search(doc()/m:server-statuses, lib-view:and-query($start-time, $lib-view:HOST))
  return if (not(empty($start-time)))
  then (lib-view:build-href("next-link", $lib-view:MODULE, fn:base-uri($next-doc), fn:string($start-time), $lib-view:HOST, $lib-view:DATABASE, ">"))
  else(">")
};


declare function local:table($i) {
(: <abbr title="Fragments (Active / Deleted)">F (A/D)</abbr> :)
    element table { attribute class {"table table-striped table-bordered"},
        element thead { attribute class {"thead-dark"},
        element tr {for $i in ( "Name", "Rate", "ETC Hits", "ETC Misses", "Threads", "Req. Time", "Queue Size") return element th {$i}}
        },
    (: "Start Time", "End Time", :)

        local:process-server-status-elements($i)
    }
};

declare function local:process-server-status-elements($i) {
    element tbody {
        for $j in $i//m:server-status
        return
            element tr {
            (: )element td {fn:data($j/m:start-time)},
        element td {fn:data($j/m:end-time)}, :)
                element td {fn:string($j/m:server-name)},
                element td {fn:string($j/m:request-rate)},
                element td {fn:string($j/m:expanded-tree-cache-hits) || " / " || fn:string($j/m:expanded-tree-cache-hit-rate)},
                element td {fn:string($j/m:expanded-tree-cache-misses) || " / " || fn:string($j/m:expanded-tree-cache-miss-rate)},
                element td {fn:string($j/m:threads)},
                element td {fn:data($j/m:request-time)},
                element td {fn:data($j/m:queue-size)}
                (:
                element td {fn:string($j/m:list-cache-misses) || " / " || fn:string($j/m:list-cache-miss-rate)},
                element td {fn:string($j/m:compressed-tree-cache-hits) || " / " || fn:string($j/m:compressed-tree-cache-hit-rate)},
                element td {fn:string($j/m:compressed-tree-cache-misses) || " / " || fn:string($j/m:compressed-tree-cache-miss-rate)},
                element td {fn:string($j/m:write-lock-count)},
                element td {fn:string($j/m:deadlock-count)},
                element td {fn:string($j/m:active-fragment-count) || " / " || fn:string($j/m:deleted-fragment-count)} :)
            }
    }
}; 

lib-bootstrap:create-starter-template("Server status for host: "|| fn:string($doc//m:host-name),
        lib-bootstrap:bootstrap-container(
                (   lib-view:nav(),
                    lib-view:top-page-summary($lib-view:URI, $doc),
                    lib-bootstrap:four-column-row(1,5,5,1, 
                        local:back-link(), 
                        lib-bootstrap:display-with-muted-text(5, " Start Time: ",  fn:string(($doc//m:start-time)[1])), 
                        lib-bootstrap:display-with-muted-text(5, "End Time: ",  fn:string(($doc//m:end-time)[1])), 
                        local:next-link()),
                    local:table($doc),
                    lib-view:render-xml-doc($doc)
                )
        ), <script src="/js.js">{" "}</script>
)