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
            cts:element-value-query(xs:QName("m:database-name"), $lib-view:DATABASE)
        ))
    )[1]
};

lib-bootstrap:create-starter-template("Database Summary: "||$lib-view:HOST,
    lib-bootstrap:bootstrap-container(
        (   
            lib-view:nav(),
            element h3 {$lib-view:DATABASE}            
        )
    )
)
