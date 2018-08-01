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

lib-bootstrap:create-starter-template("Query Read Rate Metrics",
    lib-bootstrap:bootstrap-container(
        (   
            lib-view:nav(),
            element h3 {"Query Read Rate Metrics"},
            for $i at $pos in cts:element-values(xs:QName("m:host-name"))
            return local:process-times-for-host($i, ($pos - 1))
        )
    ), <script src="/query-readrate-summary.js">{"  "}</script>
)
