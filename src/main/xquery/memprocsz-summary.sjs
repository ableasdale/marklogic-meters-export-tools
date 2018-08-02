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
        var memProcess = x.xpath('//*:memory-process-size');
        memProcessSize.push(fn.data(memProcess));
        var anonMem = x.xpath('//*:memory-process-anon');
		anonMemUsage.push(fn.data(anonMem));
		var memRss = x.xpath('//*:memory-process-rss');
		memRssSize.push(fn.data(memRss));
		var memRssHwm = x.xpath('//*:memory-process-rss-hwm');
		memRssHwmSize.push(fn.data(memRssHwm));
	}
}

for (let host of hosts) {
    var memProcessSize = new Array();
    var anonMemUsage = new Array();
	var memRssSize = new Array();
	var memRssHwmSize = new Array();
    
    for (let dateTime of dateTimes) {
        pushValuesFor(host, dateTime);
    }
    // clear the array and push to bigger array?
    var obj = {
		"data": [
			{
				"mode": "lines", 
				"y": memProcessSize, 
				"x": dateTimes, 
				"name": "mem process size"
			},
			{
				"mode": "lines", 
				"y": anonMemUsage, 
				"x": dateTimes, 
				"name": "anon mem"
			},
			{
				"mode": "lines", 
				"y": memRssSize, 
				"x": dateTimes, 
				"name": "Mem RSS size"
			},
			{
				"mode": "lines", 
				"y": memRssHwmSize, 
				"x": dateTimes, 
				"name": "Mem RSS HWM"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Memory Process Size", 
			"yaxis": {"title": "mps"}, 
			"xaxis": {"title": "Date / Time"}
		}
    };
    objects.push(obj)
}

xdmp.setResponseContentType("application/json");
xdmp.toJSON (objects);
