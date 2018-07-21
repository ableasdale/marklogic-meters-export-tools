xquery version "1.0-ml";

(: TODO: UNTESTED from clean install
    create range indexes
    m:host-name (string/codepoint)
    meters:start-time (dateTime)
    m:database-name (string/codepoint)
:)

import module namespace admin = "http://marklogic.com/xdmp/admin"  at "/MarkLogic/admin.xqy";

declare namespace m = "http://marklogic.com/manage/meters";

declare variable $CONFIG := admin:get-configuration();
declare variable $DATABASE := xdmp:database("20423");

let $CONFIG := admin:database-add-range-element-index($CONFIG, $DATABASE,
    (
        admin:database-range-element-index("string", "http://marklogic.com/manage/meters", "host-name", "http://marklogic.com/collation/codepoint", fn:false() ),
        admin:database-range-element-index("string", "http://marklogic.com/manage/meters", "database-name", "http://marklogic.com/collation/codepoint", fn:false() ),
        admin:database-range-element-index("dateTime", "http://marklogic.com/manage/meters", "start-time", (), fn:false() )
    )
)

return admin:save-configuration($CONFIG)