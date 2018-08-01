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
		var cpuUser = x.xpath('//*:total-cpu-stat-user');
        cpuUserStats.push(fn.data(cpuUser));
        
		var cpuSys = x.xpath('//*:total-cpu-stat-system');
        cpuSysStats.push(fn.data(cpuSys));
        
        var cpuIdle = x.xpath('//*:total-cpu-stat-idle');
		cpuIdleStats.push(fn.data(cpuIdle));
	}
}

for (let host of hosts) {
    var cpuUserStats = new Array();
    var cpuSysStats = new Array();
    var cpuIdleStats = new Array();
    
    for (let dateTime of dateTimes) {
        pushValuesFor(host, dateTime);
    }
    var obj = {
		"data": [
			{
				"mode": "lines", 
				"y": cpuUserStats, 
				"x": dateTimes, 
				"name": "CPU %User"
			},
			{
				"mode": "lines", 
				"y": cpuSysStats, 
				"x": dateTimes, 
				"name": "CPU %Sys"
            },
            {
				"mode": "lines", 
				"y": cpuIdleStats, 
				"x": dateTimes, 
				"name": "CPU Idle"
            }
		], 
		"layout": {
			"width" : width,
			"title": "CPU Statistics", 
			"yaxis": {"title": "CPU activity"}, 
			"xaxis": {"title": "Date / Time"}
        }
    };
    objects.push(obj)
}

xdmp.setResponseContentType("application/json");
xdmp.toJSON (objects);
