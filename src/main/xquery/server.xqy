xquery version "1.0-ml";

import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";

declare variable $uri := xdmp:get-request-field("uri"); (: TODO :)
declare variable $doc := fn:doc($uri);


declare function local:table($i) {
(:$i//m:start-time,
  $i//m:list-cache-hits,
  $i//m:list-cache-misses :)
    element table { attribute class {"table table-striped table-bordered"},
        element thead { attribute class {"thead-dark"},
        element tr {for $i in ( "Name", "Rate", "ETC Hits", "ETC Misses", "Threads", "Req. Time", "Queue Size", "Fragments [A/D]") return element th {$i}}
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
                (
                    lib-bootstrap:display-with-muted-text(5, "Meters File URI: ", $uri),
                    
                    lib-bootstrap:two-column-row(6,6,lib-bootstrap:display-with-muted-text(5, "Host Name: ", fn:string($doc//m:host-name)), lib-bootstrap:display-with-muted-text(5, "Group: ",  fn:string(($doc//m:group-name)[1]))),
                    lib-bootstrap:two-column-row(6,6,lib-bootstrap:display-with-muted-text(5, "Start Time: ",  fn:string(($doc//m:start-time)[1])), lib-bootstrap:display-with-muted-text(5, "End Time: ",  fn:string(($doc//m:end-time)[1]))),
                    local:table($doc),
                    element h5 {"Debug:"},
                    element textarea {attribute class {"form-control"}, attribute rows {"25"}, $doc}
                )
        ), <script src="/js.js">{" "}</script>
)