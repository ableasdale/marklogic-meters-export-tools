const hostname = xdmp.getRequestField("host");
const width = xdmp.getRequestField("width");

let dateTimes = cts.elementValues(fn.QName("http://marklogic.com/manage/meters","start-time"), null, ['ascending']);
var iowaitTimes = new Array();
var writeLockRates = new Array();
var anonMemUsage = new Array();
var memProcessSize = new Array();
var memRssSize = new Array();
var memRssHwmSize = new Array();
var memProcessSwapSize = new Array();
var memProcessSwapInRates = new Array();
var xdqpClientSendRates = new Array();
var xdqpServerSendRates = new Array();
var cpuUserStats = new Array();
var cpuSysStats = new Array();
var cpuIdleStats = new Array();
var queryReadRates = new Array();
var mergeReadRates = new Array();
var mergeWriteRates = new Array();
var memPageInRates = new Array();
var memPageOutRates = new Array();

function pushValuesFor(dateTime) {
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
		var iowait = x.xpath('//*:total-cpu-stat-iowait');
		iowaitTimes.push(fn.data(iowait));
		var writeLockRate = x.xpath('//*:write-lock-rate');
		writeLockRates.push(fn.data(writeLockRate));
		var anonMem = x.xpath('//*:memory-process-anon');
		anonMemUsage.push(fn.data(anonMem));
		var memProcess = x.xpath('//*:memory-process-size');
		memProcessSize.push(fn.data(memProcess));
		var memRss = x.xpath('//*:memory-process-rss');
		memRssSize.push(fn.data(memRss));
		var memRssHwm = x.xpath('//*:memory-process-rss-hwm');
		memRssHwmSize.push(fn.data(memRssHwm));
		var memSwap = x.xpath('//*:memory-process-swap-size');
		memProcessSwapSize.push(fn.data(memSwap));
		var memSwapIn = x.xpath('//*:memory-system-swapin-rate');
		memProcessSwapInRates.push(fn.data(memSwapIn));
		var clientSend = x.xpath('//*:xdqp-client-send-rate');
		xdqpClientSendRates.push(fn.data(clientSend));
		var serverSend = x.xpath('//*:xdqp-server-send-rate');
		xdqpServerSendRates.push(fn.data(serverSend));
		var cpuUser = x.xpath('//*:total-cpu-stat-user');
        cpuUserStats.push(fn.data(cpuUser));
		var cpuSys = x.xpath('//*:total-cpu-stat-system');
        cpuSysStats.push(fn.data(cpuSys));
        var cpuIdle = x.xpath('//*:total-cpu-stat-idle');
		cpuIdleStats.push(fn.data(cpuIdle));

		var queryReadRate = x.xpath('//*:query-read-rate');
		queryReadRates.push(fn.data(queryReadRate));
		var mergeReadRate = x.xpath('//*:merge-read-rate');
		mergeReadRates.push(fn.data(mergeReadRate));
		var mergeWriteRate = x.xpath('//*:merge-write-rate');
		mergeWriteRates.push(fn.data(mergeWriteRate));

		var memPageInRate = x.xpath('//*:memory-system-pagein-rate');
		memPageInRates.push(fn.data(memPageInRate));
		var memPageOutRate = x.xpath('//*:memory-system-pageout-rate'); 
		memPageOutRates.push(fn.data(memPageOutRate));
	}
}

for (let dateTime of dateTimes) {
  pushValuesFor(dateTime);
}

xdmp.setResponseContentType("application/json"),
xdmp.toJSON(
{
	"0" : {
		"data": [
			{
				"mode": "lines", 
				"y": iowaitTimes, 
				"x": dateTimes, 
				"name": "iowait"
			}
		], 
		"layout": {
			"width" : width,
			"title": "CPU % iowait times for host "+hostname, 
			"yaxis": {"title": "% iowait"}, 
			"xaxis": {"title": "Date / Time"}
		},
		"config" : {staticPlot: true}//{displayModeBar: false, scrollZoom: true}
	},
	"1" : {
		"data": [
			{
				"mode": "lines", 
				"y": writeLockRates, 
				"x": dateTimes, 
				"name": "write lock rate"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Write Lock Rates for host "+hostname, 
			"yaxis": {"title": "WLR"}, 
			"xaxis": {"title": "Date / Time"}
		},
		"config" : {staticPlot: true}//{displayModeBar: false, scrollZoom: true}
	},
	"2" : {
		"data": [
			{
				"mode": "lines", 
				"y": anonMemUsage, 
				"x": dateTimes, 
				"name": "anon mem"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Anonymous Memory Utilisation for host "+hostname,
			"yaxis": {"title": "anon"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"3" : {
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
			"title": "Memory Process Size for host "+hostname, 
			"yaxis": {"title": "mps"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"4" : {
		"data": [
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
			"title": "Memory Resident Set Size (RSS) for host "+hostname, 
			"yaxis": {"title": "rss"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"5" : {
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
			"title": "Memory Process Swap Size for host "+hostname, 
			"yaxis": {"title": "swap"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"6" : {
		"data": [
			{
				"mode": "lines", 
				"y": memProcessSwapInRates, 
				"x": dateTimes, 
				"name": "mem swap-in rate"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Memory Process Swap-In Rate for host "+hostname, 
			"yaxis": {"title": "swap-in"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"7" : {
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
			"title": "XDQP Client and Server Send Rates for host "+hostname, 
			"yaxis": {"title": "xdqp rates"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"8" : {
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
			"title": "CPU Statistics for host "+hostname, 
			"yaxis": {"title": "CPU activity"}, 
			"xaxis": {"title": "Date / Time"}
        }
	},
	"9" : {
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
			"title": "Query Read / Merge Read/Write Rates for host "+hostname, 
			"yaxis": {"title": "i/o rates"}, 
			"xaxis": {"title": "Date / Time"}
        }
	},
	"10" : {
		"data": [
			{
				"mode": "lines", 
				"y": memPageInRates, 
				"x": dateTimes, 
				"name": "Memory Page In Rate"
			},
			{
				"mode": "lines", 
				"y": memPageOutRates, 
				"x": dateTimes, 
				"name": "Memory Page Out Rate"
            }
		], 
		"layout": {
			"width" : width,
			"title": "Memory Page In/Out Rates for host "+hostname, 
			"yaxis": {"title": "mem i/o rates"}, 
			"xaxis": {"title": "Date / Time"}
        }

	}
});


// --- IGNORE BELOW

/*
{
		"data": [
			{
				"mode": "lines", 
				"y": [
					"0", 
					"45560506.663365364", 
					"91145081.21192169", 
					"232447635.15836716", 
					"580348915.5698586", 
					"1182888421.2842617", 
					"1928559640.2194986", 
					"2578825762.2643065", 
					"3022276546.8773637"
				], 
				"x": [
					"2007-12-01", 
					"2008-12-01", 
					"2009-12-01", 
					"2010-12-01", 
					"2011-12-01", 
					"2012-12-01", 
					"2013-12-01", 
					"2014-12-01", 
					"2015-12-01"
				], 
				"line": {
					"color": "rgb(255, 127, 14)", 
					"width": 3, 
					"shape": "spline"
				}, 
				"type": "scatter", 
				"name": "iowait"
			}, 
			{
				
				"mode": "lines", 
				"y": [
					"970368995.0626459", 
					"1095570133.817442", 
					"1236607941.026805", 
					"1346092750.7529802", 
					"1471269821.6225882", 
					"1517022871.3674688", 
					"1546770777.4614573", 
					"1512907263.0000963", 
					"1463183012.1989794"
				], 
				"x": [
					"2007-12-01", 
					"2008-12-01", 
					"2009-12-01", 
					"2010-12-01", 
					"2011-12-01", 
					"2012-12-01", 
					"2013-12-01", 
					"2014-12-01", 
					"2015-12-01"
				], 
				"line": {
					"color": "rgb(102, 102, 102)", 
					"width": 3, 
					"shape": "spline"
				}, 
				"type": "scatter", 
				"name": "PCs"
			}
		], 
		"layout": {
			"autosize": true, 
			"title": "title here", 
		
		
			"yaxis": {
				"title": "Y AXIS TITLE"
			}, 
			"height": 450, 
			"width": 1000, 
			"xaxis": {
				"title": "X AXIS TITLE" 
			}
		}
	}
*/


/*
	{
		"data": [
			{
				"mode": "lines", 
				"y": [
					"0", 
					"45560506.663365364", 
					"91145081.21192169", 
					"232447635.15836716", 
					"580348915.5698586", 
					"1182888421.2842617", 
					"1928559640.2194986", 
					"2578825762.2643065", 
					"3022276546.8773637"
				], 
				"x": [
					"2007-12-01", 
					"2008-12-01", 
					"2009-12-01", 
					"2010-12-01", 
					"2011-12-01", 
					"2012-12-01", 
					"2013-12-01", 
					"2014-12-01", 
					"2015-12-01"
				], 
				"line": {
					"color": "rgb(255, 127, 14)", 
					"width": 3, 
					"shape": "spline"
				}, 
				"type": "scatter", 
				"name": "iOS & Android"
			}, 
			{
				
				"mode": "lines", 
				"y": [
					"970368995.0626459", 
					"1095570133.817442", 
					"1236607941.026805", 
					"1346092750.7529802", 
					"1471269821.6225882", 
					"1517022871.3674688", 
					"1546770777.4614573", 
					"1512907263.0000963", 
					"1463183012.1989794"
				], 
				"x": [
					"2007-12-01", 
					"2008-12-01", 
					"2009-12-01", 
					"2010-12-01", 
					"2011-12-01", 
					"2012-12-01", 
					"2013-12-01", 
					"2014-12-01", 
					"2015-12-01"
				], 
				"line": {
					"color": "rgb(102, 102, 102)", 
					"width": 3, 
					"shape": "spline"
				}, 
				"type": "scatter", 
				"name": "PCs"
			}
		], 
		"layout": {
			"autosize": true, 
			"title": "title here", 
		
		
			"yaxis": {
				"title": "Y AXIS TITLE", 
				"range": [
					-100000000, 
					3600000000
				], 
				"gridcolor": "rgb(208, 208, 208)", 
				"ticksuffix": "  ", 
				"type": "linear", 
				"autorange": false
			}, 
			"height": 450, 
			"width": 1000, 
			"annotations": [
				{
					"ay": -164, 
					"text": "<b>Estimated global install base (bn)</b>", 
					"font": {
						"color": "rgb(129, 129, 126)", 
						"size": 14
					}, 
					"arrowcolor": "rgba(68, 68, 68, 0)", 
					"ax": -246
				}
			], 
			"xaxis": {
				"tickformat": "", 
				"title": "X AXIS TITLE", 
				"showgrid": false, 
				"range": [
					1193687871762.1562, 
					1448946000000
				], 
				"type": "date", 
				"autorange": true
			}, 
			
			"legend": {
				"y": 0.9713068181818182, 
				"x": -0.24796901053454015, 
				"traceorder": "reversed", 
				"bgcolor": "rgba(242, 242, 242, 0)"
			}
		}
	}
*/

/* NodeBuilder nb = new NodeBuilder(); nb.startDocument().endDocument(); nb.toNode().xpath("collection()/whatever");
 

  cts.search( cts.andQuery([ cts.collectionQuery("TRIP"), cts.elementValueQuery( fn.QName("http://marklogic.com/edl","Report"), "*","wildcarded")]))

Iterating through a sequence notes:
let list = cts.elementValues(fn.QName("http://marklogic.com/manage/meters","start-time"), null, ['limit=3']);
var value2

for (let value of list) {
  value2+= value;
}

value2;


for (const x of fn.doc()) {
  var ssn = x.xpath('//Position')
  if(ssn.toString().length) {
      ssns.push(xdmp.nodeUri(x) + " || " + ssn.toString() + " || " + (typeof(ssn)))
  }
}

  */