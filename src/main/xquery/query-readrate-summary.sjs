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
		var queryReadRate = x.xpath('//*:query-read-rate');
		queryReadRates.push(fn.data(queryReadRate));
		var mergeReadRate = x.xpath('//*:merge-read-rate');
		mergeReadRates.push(fn.data(mergeReadRate));
		var mergeWriteRate = x.xpath('//*:merge-write-rate');
		mergeWriteRates.push(fn.data(mergeWriteRate));
	}
}

for (let host of hosts) {
	var queryReadRates = new Array();
	var mergeReadRates = new Array();
	var mergeWriteRates = new Array();
    
    for (let dateTime of dateTimes) {
        pushValuesFor(host, dateTime);
    }
    // clear the array and push to bigger array?
    var obj = {
		"data": [
			{
				"mode": "lines", 
				"y": queryReadRates, 
				"x": dateTimes, 
				"name": "Query Read Rate"
			},
			{
				"mode": "lines", 
				"y": mergeReadRates, 
				"x": dateTimes, 
				"name": "Merge Read Rate"
            },
            {
				"mode": "lines", 
				"y": mergeWriteRates, 
				"x": dateTimes, 
				"name": "Merge Write Rate"
            }
		], 
		"layout": {
			"width" : width,
			"title": "Query Read / Merge Read/Write Rates", 
			"yaxis": {"title": "i/o rates"}, 
			"xaxis": {"title": "Date / Time"}
        }
    };
    objects.push(obj)
}

xdmp.setResponseContentType("application/json");
xdmp.toJSON (objects);
