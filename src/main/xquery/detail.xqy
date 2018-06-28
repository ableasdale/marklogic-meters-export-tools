xquery version "1.0-ml";

import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";

declare variable $start-time := xdmp:get-request-field("st", xs:string(cts:element-values(xs:QName("m:start-time"), (), ("limit=1"))));
declare variable $range-query := cts:element-range-query(xs:QName("m:start-time"), "=", xs:dateTime($start-time));
(:

range indexes needed:


meters:start-time (dateTime) :)


declare function local:process-link($i) {
    let $uri := xdmp:node-uri($i)
        return if(fn:contains($uri, "host-raw.xml"))
            then ("raw host info")
        else if (fn:contains($uri, "forest-raw.xml"))
            then (element li {element a {attribute href {"/forest.xqy?uri="||$uri}, $uri}})
        else (element li {$uri})
};

lib-bootstrap:create-starter-template("test",
        lib-bootstrap:bootstrap-container(
                (
                    lib-bootstrap:display-with-muted-text(4, "Start Time: ", $start-time),
                    lib-bootstrap:display-with-muted-text(5, "Matches for this Start time: ", xs:string(xdmp:estimate(cts:search(doc(), $range-query)))),
                (:)element h3 {"Start Time:", element small {$start-time}} :)

                    element ul {
                        for $i in cts:search(doc(), $range-query)
                        return local:process-link ($i)
                    }

                )
        )
)


