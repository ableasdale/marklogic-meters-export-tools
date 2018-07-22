xquery version "1.0-ml";

import module namespace lib-view = "http://www.xmlmachines.com/lib-view" at "/lib/lib-view.xqy";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace cts = "http://marklogic.com/cts";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare function local:get-doc-for-time($start-time){
    cts:search(doc()/m:database-statuses,
        cts:and-query((
            cts:element-range-query(xs:QName("m:start-time"), "=", $start-time),
            cts:element-value-query(xs:QName("m:period"), "raw"),
            cts:element-value-query(xs:QName("m:host-name"), $lib-view:HOST),
            cts:element-value-query(xs:QName("m:database-name"), $lib-view:DATABASE)
        ))
    )[1]
};

declare function local:process-start-times($start-times) {
    element tbody {
        for $start-time in $start-times
        let $j := local:get-doc-for-time($start-time)//m:database-status[m:database-name eq $lib-view:DATABASE]
        let $_ := xdmp:log($j)
        return
            element tr {
                element td {element a {attribute href {"/databases.xqy?uri="||fn:base-uri($j)},$start-time}},
                lib-view:output-td-if-available($j/m:master-aggregate/m:nonblocking-timestamp),
                lib-view:output-td-if-available($j/m:master-aggregate/m:active-fragment-count),
                lib-view:output-td-if-available($j/m:master-aggregate/m:deleted-fragment-count),               
                element td {fn:string($j/m:master-aggregate/m:list-cache-hits) || " / " || fn:string($j/m:master-aggregate/m:list-cache-hit-rate)},
                element td {fn:string($j/m:master-aggregate/m:list-cache-misses) || " / " || fn:string($j/m:master-aggregate/m:list-cache-miss-rate)},
                element td {fn:string($j/m:master-aggregate/m:compressed-tree-cache-hits) || " / " || fn:string($j/m:master-aggregate/m:compressed-tree-cache-hit-rate)},
                element td {fn:string($j/m:master-aggregate/m:compressed-tree-cache-misses) || " / " || fn:string($j/m:master-aggregate/m:compressed-tree-cache-miss-rate)},
                element td {fn:string($j/m:master-aggregate/m:deadlock-count) || " / " || fn:string($j/m:master-aggregate/m:deadlock-rate)},
                element td {fn:string($j/m:master-aggregate/m:write-lock-count) || " / " || fn:string($j/m:master-aggregate/m:write-lock-rate)}
            }
    }
}; 

declare function local:table($start-times) {
    element table { attribute class {"table table-striped table-bordered"},
        element thead { attribute class {"thead-dark"},
            element tr {for $i in ( "Name", <abbr title="Nonblocking Timestamp">NBT</abbr>, <abbr title="Active Fragment Count">AFC</abbr>, <abbr title="Deleted Fragment Count">DFC</abbr>, <abbr title="List Cache Hits / Rate">LCH</abbr>, <abbr title="List Cache Misses / Rate">LCM</abbr>, <abbr title="Compressed Tree Cache Hits / Rate">CTCH</abbr>, <abbr title="Compressed Tree Cache Misses / Rate">CTCM</abbr>, <abbr title="Deadlock Count / Rate">DLC</abbr>, <abbr title="Write Lock Count / Rate">WLC</abbr>) return element th {$i}}
        },
        local:process-start-times($start-times)
    }
};


lib-bootstrap:create-starter-template("Database Summary: "||$lib-view:HOST,
    lib-bootstrap:bootstrap-container(
        (   
            lib-view:nav(),
            element h3 {$lib-view:DATABASE},
            local:table(cts:element-values(xs:QName("m:start-time")))           
        )
    )
)
