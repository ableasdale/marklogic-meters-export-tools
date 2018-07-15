xquery version "1.0-ml";

import module namespace lib-view = "http://www.xmlmachines.com/lib-view" at "/lib/lib-view.xqy";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";

declare variable $uri := xdmp:get-request-field("uri"); (: TODO :)
declare variable $doc := fn:doc($uri);


declare function local:process-row($i) {
(:$i//m:start-time,
  $i//m:list-cache-hits,
  $i//m:list-cache-misses :)
    element table { attribute class {"table table-striped table-bordered"},
        element thead { attribute class {"thead-dark"},
        element tr {for $i in ( "Name", "LC Hits", "LC Misses", "CTC Hits", "CTC Misses", "Write Lock Count", "Deadlock Count", "Fragments [A/D]") return element th {$i}}
        },
    (: "Start Time", "End Time", :)

        local:process-forest-status-elements($i)
    }
};

declare function local:process-forest-status-elements($i) {
    element tbody {
        for $j in $i/m:host-status
        return
            element tr {
            (: )element td {fn:data($j/m:start-time)},
        element td {fn:data($j/m:end-time)}, :)
                element td {fn:data($j/m:total-cpu-stat-iowait)},
                element td {fn:string($j/m:memory-process-size) || " / " || fn:string($j/m:memory-process-rss)}
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

lib-bootstrap:create-starter-template("Host status for host: "|| fn:string($doc//m:host-name),
        lib-bootstrap:bootstrap-container(
                (
                    lib-view:nav(),
                    lib-bootstrap:display-with-muted-text(4, "Meters File URI: ", $uri),
                    lib-bootstrap:display-with-muted-text(5, "Host Name: ", fn:string($doc//m:host-name)),
                    lib-bootstrap:display-with-muted-text(5, "Start Time: ",  fn:string(($doc//m:start-time)[1])   ),
                    lib-bootstrap:display-with-muted-text(5, "End Time: ",  fn:string(($doc//m:end-time)[1])   ),(:order by xs:dateTime($i) descending return $i),:)
                    lib-bootstrap:display-with-muted-text(5, "Group: ",  fn:string(($doc//m:group-name)[1])   ),
                    for $i in $doc/m:host-statuses
                    return local:process-row($i),
                    element h5 {"Debug:"},
                    element textarea {attribute class {"form-control"}, attribute rows {"25"}, $doc}
                )
        )
)