xquery version "1.0-ml";

import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";

declare variable $start-time := xdmp:get-request-field("st", xs:string(cts:element-values(xs:QName("m:start-time"), (), ("limit=1"))));
declare variable $range-query := cts:element-range-query(xs:QName("m:start-time"), "=", xs:dateTime($start-time));

declare function local:process-link($i) {
    let $uri := xdmp:node-uri($i)
        return if(fn:contains($uri, "host-raw.xml"))
            then (element li {element a {attribute href {"/host.xqy?uri="||$uri}, $uri}})
        else if (fn:contains($uri, "forest-raw.xml"))
            then (element li {element a {attribute href {"/forest.xqy?uri="||$uri}, $uri}})
        else (element li {$uri})
};

lib-bootstrap:create-starter-template("Details for Start Time: "||$start-time,
        lib-bootstrap:bootstrap-container(
                (
                    lib-bootstrap:display-with-muted-text(4, "Start Time: ", $start-time),
                    lib-bootstrap:display-with-muted-text(5, "Matches for this Start time: ", xs:string(xdmp:estimate(cts:search(doc(), $range-query)))),
                (:)element h3 {"Start Time:", element small {$start-time}} :)

                    for $i in cts:element-values(xs:QName("m:host-name"))
                    return lib-bootstrap:card-with-header(element a {attribute href {"/host-summary.xqy?hostname="||$i}, $i}, element ul {
                        for $j in cts:search(doc(), cts:and-query( ($range-query, cts:element-value-query(xs:QName("m:host-name"), $i))) )
                        return local:process-link ($j)
                    })

                )
        )
)


