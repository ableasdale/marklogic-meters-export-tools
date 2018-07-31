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
		var memSwap = x.xpath('//*:memory-process-swap-size');
		memProcessSwapSize.push(fn.data(memSwap));
	}
}

for (let host of hosts) {
    var memProcessSwapSize = new Array();
    
    for (let dateTime of dateTimes) {
        pushValuesFor(host, dateTime);
    }
    // clear the array and push to bigger array?
    var obj = {
		"data": [
			{
				"mode": "lines",
				"y": memProcessSwapSize, 
				"x": dateTimes, 
				"name": "mem swap size"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Memory Process Swap Size", 
			"yaxis": {"title": "swap"}, 
			"xaxis": {"title": "Date / Time"}
        }
    };
    objects.push(obj)
}

xdmp.setResponseContentType("application/json");
xdmp.toJSON (objects);
