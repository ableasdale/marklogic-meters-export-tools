xquery version "1.0-ml";

import module namespace lib-view = "http://www.xmlmachines.com/lib-view" at "/lib/lib-view.xqy";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace cts = "http://marklogic.com/cts";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare variable $first-start-datetime := cts:element-values(xs:QName("m:start-time"), (), ("ascending", "limit=1"));
declare variable $last-start-datetime := cts:element-values(xs:QName("m:start-time"), (), ("descending", "limit=1"));

declare function local:hourly-reports(){
    for $i in cts:element-values(xs:QName("m:start-time"), (), (), cts:element-value-query(xs:QName("m:period"), "hour"))
    return element a {attribute href {"/hourly-reports.xqy?st="||$i}, $i}
};

declare function local:create-groups() {
    for $i in 1 to fn:hours-from-duration($last-start-datetime - $first-start-datetime) + 1
    (: let $step := "PT"||$i||"H" :)
    return element div { 
        attribute class {"col"}, 
        element h6 {fn:substring-before(fn:string($first-start-datetime + xs:dayTimeDuration("PT"||$i - 1||"H")), "T")},
        element ul { 
            for $j in cts:element-values(xs:QName("m:start-time"), (), (),
                cts:and-query((
                    cts:element-range-query(xs:QName("m:start-time"), ">=", $first-start-datetime + xs:dayTimeDuration("PT"||$i - 1||"H")),
                    cts:element-range-query(xs:QName("m:start-time"), "<", xs:dateTime($first-start-datetime + xs:dayTimeDuration("PT"||$i||"H")))
                ))
            )
            return element li {element a {attribute href {"/detail.xqy?st="||$j}, fn:substring-after(fn:string($j), "T")}}
        }
    }
};

lib-bootstrap:create-starter-template("Start times",
    lib-bootstrap:bootstrap-container(
        (   lib-view:nav(),
            element h3 {"Hourly Reports"},
            local:hourly-reports(),
            element h3 {"Start Times"},
            element div {
                attribute class {"row"},
                local:create-groups()
            }
        (: element ul {
            for $i in cts:element-values(xs:QName("m:start-time"))
            return element li {element a {attribute href {"/detail.xqy?st="||$i}, $i}}
        }:)
        )
    )
)