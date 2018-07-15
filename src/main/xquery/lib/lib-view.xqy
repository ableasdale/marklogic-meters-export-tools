xquery version "1.0-ml";

module namespace lib-view = "http://www.xmlmachines.com/lib-view";
import module namespace lib-bootstrap = "http://www.xmlmachines.com/lib-bootstrap" at "/lib/lib-bootstrap.xqy";

declare namespace m = "http://marklogic.com/manage/meters";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare function lib-view:output-td-if-available($node as node()?){
    if(exists($node))
    then element td {fn:string($node)}
    else element td {attribute class {"text-muted"}, "N/A"}
};

declare function lib-view:nav() {
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">ML-LOGO</a>
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
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          By Host
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          {for $i in cts:element-values(xs:QName("m:host-name"))
            return element a {attribute class {"dropdown-item"}, attribute href {"/host-summary.xqy?hostname="||$i}, $i}
          }  
        </div>
      </li>
      <!-- li class="nav-item">
        <a class="nav-link disabled" href="#">Disabled</a>
      </li -->
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
