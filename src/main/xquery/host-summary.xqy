xquery version "1.0-ml";

import module namespace lib-view = "http://www.xmlmachines.com/lib-view" at "/lib/lib-view.xqy";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace cts = "http://marklogic.com/cts";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare function local:get-doc-for-time($start-time){
    cts:search(doc()/m:host-statuses,
        cts:and-query((
            cts:element-range-query(xs:QName("m:start-time"), "=", $start-time),
            cts:element-value-query(xs:QName("m:host-name"), $lib-view:HOST)
        ))
    )[1]
};

declare function local:process-start-times($start-times) {
    element tbody {
        for $start-time in $start-times
        let $k := local:get-doc-for-time($start-time)
        return
            element tr {
                element td {element a {attribute href {"/host.xqy?uri="||fn:base-uri($k)},$start-time}},
                lib-view:output-td-if-available($k/m:host-status/m:total-cpu-stat-iowait),
                lib-view:output-td-if-available($k/m:host-status/m:memory-process-size),
                lib-view:output-td-if-available($k/m:host-status/m:memory-process-rss),
                lib-view:output-td-if-available($k/m:host-status/m:memory-process-rss-hwm),
                lib-view:output-td-if-available($k/m:host-status/m:memory-process-anon),
                lib-view:output-td-if-available($k/m:host-status/m:write-lock-rate),
                lib-view:output-td-if-available($k/m:host-status/m:total-cpu-stat-user),
                lib-view:output-td-if-available($k/m:host-status/m:total-cpu-stat-system),
                lib-view:output-td-if-available($k/m:host-status/m:memory-system-swapin-rate),
                lib-view:output-td-if-available($k/m:host-status/m:memory-system-swapout-rate),
                lib-view:output-td-if-available($k/m:host-status/m:read-lock-count),
                lib-view:output-td-if-available($k/m:host-status/m:read-lock-rate),
                lib-view:output-td-if-available($k/m:host-status/m:deadlock-count),
                lib-view:output-td-if-available($k/m:host-status/m:deadlock-rate)
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
            element tr {for $i in ( "Time", "IOWait", "MPS", "RSS", "RSS-HWM", "Anon", <abbr title="Write Lock Rate">WLR</abbr>, <abbr title="User CPU Utilisation (%)">Usr</abbr>, <abbr title="System CPU Utilisation (%)">Sys</abbr>, <abbr title="System Swap-In Rate">SI</abbr>, <abbr title="System Swap-Out Rate">SO</abbr>, <abbr title="Read Lock Count">RLC</abbr>, <abbr title="Read Lock Rate">RLR</abbr>, <abbr title="Deadlock Count">DLC</abbr>, <abbr title="Deadlock Rate">DLR</abbr>) return element th {$i}}
        },
    (: "Start Time", "End Time", :)

        local:process-start-times($start-times)
    }
};


lib-bootstrap:create-starter-template("Host Summary: "||$lib-view:HOST,
    lib-bootstrap:bootstrap-container(
        (   
            lib-view:nav(),
            element h3 {$lib-view:HOST},
            <div id="root" style="width:700px;height:450px;">{" "}</div>,
            <div id="like_button_container">{" "}</div>,
            local:table(cts:element-values(xs:QName("m:start-time")))
        )),    
        (<script src="/chart.js">{"  "}</script>,<script src="like_button.js">{" "}</script>)
    )

    (: <script>
    <![CDATA[
	TESTER = document.getElementById('tester');
	Plotly.plot( TESTER, [{
	x: [1, 2, 3, 4, 5],
	y: [1, 2, 4, 8, 16] }], {
	margin: { t: 0 } } );
    ]]>
    </script> :)
 