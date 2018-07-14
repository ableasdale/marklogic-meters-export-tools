xquery version "1.0-ml";

import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare variable $hostname := xdmp:get-request-field("hostname"); 

declare function local:get-doc-for-time($start-time){
    cts:search(doc()/m:host-statuses,
        cts:and-query((
            cts:element-range-query(xs:QName("m:start-time"), "=", $start-time),
            cts:element-value-query(xs:QName("m:host-name"), $hostname)
        ))
    )
};

declare function local:output-if-available($node){
    if(exists($node))
    then element td {$node}
    else element td {"N/A"}
};

declare function local:process-start-times($start-times) {
    element tbody {
        for $start-time in $start-times
        let $k := local:get-doc-for-time($start-time)
        return
            element tr {
                element td {$start-time},
                element td {fn:data($k/m:host-status/m:total-cpu-stat-iowait)},
                local:output-if-available($k/m:host-status/m:memory-process-size),
                local:output-if-available($k/m:host-status/m:memory-process-rss),
                local:output-if-available($k/m:host-status/m:memory-process-anon),
                local:output-if-available($k/m:host-status/m:write-lock-rate)
                (: element td {fn:string($k/m:host-status/m:memory-process-size) || " / " || fn:string($k//m:host-statuses/m:host-status/m:memory-process-rss)}:)
            }
    }
}; 
declare function local:table($start-times) {
(:$i//m:start-time,
  $i//m:list-cache-hits,
  $i//m:list-cache-misses :)
    element table { attribute class {"table table-striped table-bordered"},
        element thead { attribute class {"thead-dark"},
            element tr {for $i in ( "Time", "IOWait", "MPS", "RSS", "Anon", "Write Lock Rate", "Deadlock Count", "Fragments [A/D]") return element th {$i}}
        },
    (: "Start Time", "End Time", :)

        local:process-start-times($start-times)
    }
};


lib-bootstrap:create-starter-template("test",
    lib-bootstrap:bootstrap-container(
        (element h3 {$hostname},
            local:table(cts:element-values(xs:QName("m:start-time"))
        ))
    )
)