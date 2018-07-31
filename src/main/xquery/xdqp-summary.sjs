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
		var clientSend = x.xpath('//*:xdqp-client-send-rate');
		xdqpClientSendRates.push(fn.data(clientSend));
		var serverSend = x.xpath('//*:xdqp-server-send-rate');
		xdqpServerSendRates.push(fn.data(serverSend));
	}
}

for (let host of hosts) {
    var xdqpServerSendRates = new Array();
    var xdqpClientSendRates = new Array();
    
    for (let dateTime of dateTimes) {
        pushValuesFor(host, dateTime);
    }
    // clear the array and push to bigger array?
    var obj = {
		"data": [
			{
				"mode": "lines", 
				"y": xdqpClientSendRates, 
				"x": dateTimes, 
				"name": "XDQP C Send"
			},
			{
				"mode": "lines", 
				"y": xdqpServerSendRates, 
				"x": dateTimes, 
				"name": "XDQP S Send"
			}
		], 
		"layout": {
			"width" : width,
			"title": "XDQP Client and Server Send Rates", 
			"yaxis": {"title": "XDQP rates"}, 
			"xaxis": {"title": "Date / Time"}
        }
    };
    objects.push(obj)
}

xdmp.setResponseContentType("application/json");
xdmp.toJSON (objects);
