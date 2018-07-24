
const hostname = xdmp.getRequestField("host");
const database = xdmp.getRequestField("db");
const width = xdmp.getRequestField("width");

let dateTimes = cts.elementValues(fn.QName("http://marklogic.com/manage/meters","start-time"), null, ['ascending']);
var listCacheMisses = new Array();
var compressedTreeCacheMisses = new Array();
var activeFragmentCounts = new Array();
var activeFragmentCountsReplica = new Array();
var writeLockCounts = new Array();
var deletedFragmentCounts = new Array();
var deletedFragmentCountsReplica = new Array();
var queryReadBytesCounts = new Array();
var mergeReadTimeCounts = new Array();
var mergeWriteTimeCounts = new Array();

function pushValuesFor(dateTime) {
	xdmp.log("top of push vals for: "+dateTime+" | "+hostname+" | "+database, "debug");
	for (const x of cts.search(
			cts.andQuery([
				cts.elementRangeQuery(fn.QName("http://marklogic.com/manage/meters","start-time"), "=", dateTime),
				cts.elementQuery(fn.QName("http://marklogic.com/manage/meters", "database-statuses"), cts.andQuery([])),
				cts.elementValueQuery(fn.QName("http://marklogic.com/manage/meters","period"), "raw"),
				cts.elementValueQuery(fn.QName("http://marklogic.com/manage/meters","host-name"), hostname),
				cts.elementValueQuery(fn.QName("http://marklogic.com/manage/meters","database-name"), database)
			])
		)
	)
	{	
		var listCacheMissRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:list-cache-misses');
		listCacheMisses.push(fn.data(listCacheMissRecord));

		var compressedTreeCacheMissRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:compressed-tree-cache-misses');
		compressedTreeCacheMisses.push(fn.data(compressedTreeCacheMissRecord));

		var activeFragmentRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:active-fragment-count');
		activeFragmentCounts.push(fn.data(activeFragmentRecord));

		var activeFragmentRecordReplica = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:replica-aggregate/*:active-fragment-count');
		activeFragmentCountsReplica.push(fn.data(activeFragmentRecordReplica));

		var writeLockRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:write-lock-count');
		writeLockCounts.push(fn.data(writeLockRecord));

		var deletedFragmentRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:deleted-fragment-count');
		deletedFragmentCounts.push(fn.data(deletedFragmentRecord));

		var deletedFragmentRecordReplica = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:replica-aggregate/*:deleted-fragment-count');
		deletedFragmentCountsReplica.push(fn.data(deletedFragmentRecordReplica));

		var queryReadBytesRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:query-read-bytes');
		queryReadBytesCounts.push(fn.data(queryReadBytesRecord));

		var mergeReadTimeRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:merge-read-time');
		mergeReadTimeCounts.push(fn.data(mergeReadTimeRecord));

		var mergeWriteTimeRecord = x.xpath('//*:database-status[*:database-name eq "'+database+'"]/*:master-aggregate/*:merge-write-time');
		mergeWriteTimeCounts.push(fn.data(mergeWriteTimeRecord));
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
				"y": listCacheMisses, 
				"x": dateTimes,
				"name": "List Cache Misses"
			}
		], 
		"layout": {
			"width" : width,
			"title": "List Cache Misses for "+database + " on "+hostname, 
			"yaxis": {"title": "LC Misses"}, 
			"xaxis": {"title": "Date / Time"}
		}	
	},
	"1" : {
		"data": [
			{
				"mode": "lines", 
				"y": compressedTreeCacheMisses, 
				"x": dateTimes, 
				"name": "Compressed Tree Cache Misses"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Compressed Tree Cache Misses for "+database + " on "+hostname, 
			"yaxis": {"title": "CTC Misses"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"2" : {
		"data": [
			{
				"mode": "lines", 
				"y": activeFragmentCounts, 
				"x": dateTimes, 
				"name": "AFC (master)"
			},
			{
				"mode": "lines", 
				"y": activeFragmentCountsReplica, 
				"x": dateTimes, 
				"name": "AFC (replica)"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Active Fragment Counts (Master/Replica) for "+database + " on "+hostname, 
			"yaxis": {"title": "AFC (Master/Replica)"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"3" : {
		"data": [
			{
				"mode": "lines", 
				"y": writeLockCounts, 
				"x": dateTimes, 
				"name": "Write Lock Count"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Write Lock Counts for "+database, 
			"yaxis": {"title": "Write Lock Counts"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"4" : {
		"data": [
			{
				"mode": "lines", 
				"y": deletedFragmentCounts, 
				"x": dateTimes, 
				"name": "DFC (master)"
			},
			{
				"mode": "lines", 
				"y": deletedFragmentCountsReplica, 
				"x": dateTimes,
				"name": "DFC (replica)"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Deleted Fragment Counts (Master/Replica) for "+database + " on "+hostname, 
			"yaxis": {"title": "DFC (Master/Replica)"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"5" : {
		"data": [
			{
				"mode": "lines", 
				"y": queryReadBytesCounts, 
				"x": dateTimes, 
				"name": "Query Read Bytes"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Query Read Bytes Counts for "+database + " on "+hostname, 
			"yaxis": {"title": "Query Read Bytes"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
	"6" : {
		"data": [
			{
				"mode": "lines", 
				"y": mergeReadTimeCounts, 
				"x": dateTimes, 
				"name": "Merge Read Time"
			},
			{
				"mode": "lines", 
				"y": mergeWriteTimeCounts, 
				"x": dateTimes, 
				"name": "Merge Write Time"
			}
		], 
		"layout": {
			"width" : width,
			"title": "Merge Read/Write times on the Master forests for "+database + " on "+hostname, 
			"yaxis": {"title": "Merge (R/W) Time"}, 
			"xaxis": {"title": "Date / Time"}
		}
	},
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
				"title": "Date / Time" 
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
				"title": "Date / Time", 
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