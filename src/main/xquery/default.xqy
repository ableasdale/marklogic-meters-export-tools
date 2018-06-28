xquery version "1.0-ml";

import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";


(:
range indexes needed:

meters:start-time (dateTime) :)
lib-bootstrap:create-starter-template("test",
    lib-bootstrap:bootstrap-container(
        (element h3 {"Start Times"},
        element ul {
            for $i in cts:element-values(xs:QName("m:start-time"))
            return element li {element a {attribute href {"/detail.xqy?st="||$i}, $i}}
        })
    )
)