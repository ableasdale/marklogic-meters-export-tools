const width = xdmp.getRequestField("width");

let hosts = cts.elementValues(fn.QName("http://marklogic.com/manage/meters", "host-name"), null, ['ascending']);
let dateTimes = cts.elementValues(fn.QName("http://marklogic.com/manage/meters","start-time"), null, ['ascending']);

var objects = new Array();

function pushValuesFor(hostname, dateTime) {
	for (const x of cts.search(
			cts.andQuery([
				cts.elementRangeQuery(fn.QName("http://marklogic.com/manage/meters","start-time"), "=", dateTime),
				cts.elementQuery(fn.QName("http://marklogic.com/manage/meters", "host-statuses"), cts.andQuery([])),
				cts.elementValueQuery(fn.QName("http://marklogic.com/manage/meters","period"), "raw"),
				cts.elementValueQuery(fn.QName("http://marklogic.com/manage/meters","host-name"), hostname)
			])
		)
	) 
	{
		var memPageIn = x.xpath('//*:memory-system-pagein-rate');
		memProcessPageInRate.push(fn.data(memPageIn));
	}
}

for (let host of hosts) {
    var memProcessPageInRate = new Array();
    
    for (let dateTime of dateTimes) {
        pushValuesFor(host, dateTime);
    }
    var obj = {
		"data": [
			{
				"mode": "lines",
				"y": memProcessPageInRate, 
				"x": dateTimes, 
				"name": "mem page in"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Memory System Page In Rate", 
			"yaxis": {"title": "page in"}, 
			"xaxis": {"title": "Date / Time"}
        }
    };
    objects.push(obj)
}

xdmp.setResponseContentType("application/json");
xdmp.toJSON (objects);
