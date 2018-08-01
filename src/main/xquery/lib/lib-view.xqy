xquery version "1.0-ml";

module namespace lib-view = "http://www.xmlmachines.com/lib-view";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace cts = "http://marklogic.com/cts";

declare variable $URI := xdmp:get-request-field("uri");
declare variable $DATABASE := xdmp:get-request-field("db", fn:string(cts:element-values(xs:QName("m:database-name"), (), ("ascending", "limit=1"))));
declare variable $HOST := xdmp:get-request-field("host", fn:string(cts:element-values(xs:QName("m:host-name"), (), ("ascending", "limit=1"))));
declare variable $START-TIME := xdmp:get-request-field("st", fn:string(cts:element-values(xs:QName("m:start-time"), (), ("ascending", "limit=1"))));
declare variable $MODULE := fn:tokenize(fn:substring-before(xdmp:get-request-url(), "?"),"/")[last()];

declare function lib-view:exec-query-get-uri($root-node-name, $start-time, $hostname) {
  fn:base-uri(lib-view:exec-query($root-node-name, $start-time, $hostname))
};

declare function lib-view:exec-query-get-uri($start-time, $hostname) {
  fn:base-uri(lib-view:exec-query($start-time, $hostname))
};

declare function lib-view:exec-query($root-node-name, $start-time, $hostname) {
  xdmp:log($MODULE,"debug"),
  xdmp:log($root-node-name,"debug"),
  if ($root-node-name eq "database-statuses")
    then (cts:search(doc()/m:database-statuses, lib-view:and-query($start-time, $hostname)))
  else if ($root-node-name eq "forest-statuses")
    then (cts:search(doc()/m:forest-statuses, lib-view:and-query($start-time, $hostname)))
  else if ($root-node-name eq "server-statuses")
    then (cts:search(doc()/m:server-statuses, lib-view:and-query($start-time, $hostname)))
  (:else if ($root-node-name eq "host-statuses")
    then (cts:search(doc()/m:host-statuses, lib-view:and-query($start-time, $hostname))) :)    
  (: TODO - seems to work! :)
  else (cts:search(doc()/m:host-statuses, lib-view:and-query($start-time, $hostname)))
};


declare function lib-view:exec-query($start-time, $hostname) {
  lib-view:exec-query(name(doc($URI)/*), $start-time, $hostname)
};


declare function lib-view:and-query($start-time, $hostname) {
  cts:and-query((
    cts:element-range-query(xs:QName("m:start-time"), "=", xs:dateTime($start-time)),
    cts:element-value-query(xs:QName("m:period"), "raw"),
    cts:element-value-query(xs:QName("m:host-name"), $hostname)
  ))
};

declare function lib-view:output-td-if-available($node as node()?){
    if(exists($node))
    then element td {fn:string($node)}
    else element td {attribute class {"text-muted"}, "N/A"}
};

declare function lib-view:build-href($classname as xs:string, $module as xs:string, $uri as xs:string, $start-time as xs:string, $host as xs:string, $db as xs:string, $linktext as xs:string) as element(a) {
  xdmp:log("build-href: "||$classname||" | "||$module||" | "||$uri,"debug"),
  element a {attribute class {$classname}, attribute href{"/"||$module||"?uri="||$uri||"&amp;st="||$start-time||"&amp;host="||$host||"&amp;db="||$db}, $linktext}
};

declare function lib-view:build-href-subitem($classname as xs:string, $module as xs:string, $uri as xs:string, $start-time as xs:string, $host as xs:string, $db as xs:string, $linktext as xs:string) as element(a) {
  xdmp:log("build-href: "||$classname||" | "||$module||" | "||$uri,"debug"),
  element a {attribute class {$classname}, attribute href{"/"||$module||"?uri="||$uri||"&amp;st="||$start-time||"&amp;host="||$host||"&amp;db="||$db}, element i {attribute class {"fas fa-angle-right text-muted"}, " "}," "||$linktext}
};

declare function lib-view:create-chart-containers($rootname, $num) {
    for $i in 0 to $num
    return element div {attribute class {"row"}, attribute id {$rootname||$i}, " "}
};

declare function lib-view:render-xml-doc($doc as document-node()){
  element h5 {"XML Content:"},
  element textarea {attribute id {"xml"}, attribute class {"form-control"}, attribute rows {"25"}, $doc}
};

declare function lib-view:is-active($item1 as xs:string, $item2 as xs:string) as xs:string {
  xdmp:log("is-active: "||$item1||" | "||$item2,"debug"),
  if ($item1 eq $item2)
  then ("dropdown-item active")
  else ("dropdown-item")
};

declare function lib-view:nav() {
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="https://www.marklogic.com"><img style="max-width:150px;" id="nav-logo" src="/assets/images/marklogic.png"/></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <a class="nav-link" href="/">Home <span class="sr-only">(current)</span></a>
      </li>
      <!-- li class="nav-item">
        <a class="nav-link" href="#">Link</a>
      </li -->
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarHostDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          By Host
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarHostDropdown">
          {for $i in cts:element-values(xs:QName("m:host-name"))
            return lib-view:build-href(lib-view:is-active($i, $HOST), $MODULE, lib-view:exec-query-get-uri($START-TIME, $i), $START-TIME, $i, $DATABASE, $i)
          }
        </div>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Raw Type
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          {
            lib-view:build-href(lib-view:is-active("databases.xqy", $MODULE), "databases.xqy", lib-view:exec-query-get-uri("database-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Databases"),
            lib-view:build-href(lib-view:is-active("forest.xqy", $MODULE), "forest.xqy", lib-view:exec-query-get-uri("forest-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Forests"),
            lib-view:build-href(lib-view:is-active("server.xqy", $MODULE), "server.xqy", lib-view:exec-query-get-uri("server-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Servers"),
            lib-view:build-href(lib-view:is-active("host.xqy", $MODULE), "host.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Hosts")
          }
        </div>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarSummaryDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Summaries
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarSummaryDropdown">
          {
            <h6 class="dropdown-header">Database Level Items</h6>,
            lib-view:build-href(lib-view:is-active("database-summary.xqy", $MODULE), "database-summary.xqy", lib-view:exec-query-get-uri("database-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "By Database"),
            (: lib-view:build-href(lib-view:is-active("forest.xqy", $MODULE), "forest.xqy", lib-view:exec-query-get-uri("forest-statuses", $START-TIME, $HOST), $START-TIME, $HOST, "Forests"),
            lib-view:build-href(lib-view:is-active("server.xqy", $MODULE), "server.xqy", lib-view:exec-query-get-uri("server-statuses", $START-TIME, $HOST), $START-TIME, $HOST, "Servers"), :)
            <div class="dropdown-divider">{" "}</div>,
            <h6 class="dropdown-header">Host Level Items</h6>,
            lib-view:build-href(lib-view:is-active("host-summary.xqy", $MODULE), "host-summary.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "By Host"),
            <h6 class="dropdown-header">Across the cluster</h6>,
            lib-view:build-href-subitem(lib-view:is-active("xdqp-summary.xqy", $MODULE), "xdqp-summary.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "XDQP Client / Server Send / Receive Metrics"),
            lib-view:build-href-subitem(lib-view:is-active("memrss-summary.xqy", $MODULE), "memrss-summary.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Memory Resident Set Size (RSS) Metrics"),
            lib-view:build-href-subitem(lib-view:is-active("swap-summary.xqy", $MODULE), "swap-summary.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Memory Process Swap Size Metrics"),
            lib-view:build-href-subitem(lib-view:is-active("swap-in-summary.xqy", $MODULE), "swap-in-summary.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Memory System Swap In Metrics"),
            lib-view:build-href-subitem(lib-view:is-active("writelock-summary.xqy", $MODULE), "writelock-summary.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Write Lock Metrics"),
            lib-view:build-href-subitem(lib-view:is-active("readlock-summary.xqy", $MODULE), "readlock-summary.xqy", lib-view:exec-query-get-uri("host-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $DATABASE, "Read Lock Metrics")
          }
        </div>
      </li>
      {lib-view:contextual-menu()}
    </ul>
    <form class="form-inline my-2 my-lg-0">
      <input class="form-control mr-sm-2" type="search" placeholder="TODO: Search" aria-label="Search"/>
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">GO</button>
    </form>
  </div>
</nav>
};

declare function lib-view:top-page-summary($uri, $doc) {
    lib-bootstrap:display-with-muted-text(5, "Meters File URI: ", $uri),
    lib-bootstrap:two-column-row(6,6,lib-bootstrap:display-with-muted-text(5, "Host Name: ", fn:string($doc//m:host-name)), lib-bootstrap:display-with-muted-text(5, "Group: ",  fn:string(($doc//m:group-name)[1])))
};

declare function lib-view:contextual-menu(){
  xdmp:log("contextual","debug"),
  if ($MODULE eq "database-summary.xqy")
  then (
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" href="#" id="navbarContextualDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        Databases
      </a>
      <div class="dropdown-menu" aria-labelledby="navbarContextualDropdown">
        {for $i in cts:element-values(xs:QName("m:database-name"))
          return lib-view:build-href(lib-view:is-active($i, $DATABASE), $MODULE, lib-view:exec-query-get-uri("database-statuses", $START-TIME, $HOST), $START-TIME, $HOST, $i, $i)
        }
      </div>
    </li>)
  else ()
};