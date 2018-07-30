xquery version "1.0-ml";

import module namespace lib-view = "http://www.xmlmachines.com/lib-view" at "/lib/lib-view.xqy";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace cts = "http://marklogic.com/cts";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare function local:process-times-for-host($i, $pos) {
    element h5 {$i},
    element div {attribute class {"row"}, attribute id {"root"||$pos}, " "}
    
};

lib-bootstrap:create-starter-template("XDQP Client / Server Send/Receive Details",
    lib-bootstrap:bootstrap-container(
        (   
            lib-view:nav(),
            element h3 {"XDQP Client / Server Send / Receive Details"},
            (:lib-view:create-chart-containers("root",6) :)
            for $i at $pos in cts:element-values(xs:QName("m:host-name"))
            return local:process-times-for-host($i, ($pos - 1))

            (: local:table(cts:element-values(xs:QName("m:start-time")):)
        )
    ), <script src="/summary.js?item=xdqp">{"  "}</script>
)
 