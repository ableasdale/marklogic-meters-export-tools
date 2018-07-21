function getIoWait(dateTime) {
  cts.search(
        cts.andQuery([
            cts.elementRangeQuery(fn.QName("http://marklogic.com/manage/meters","start-time"), "=", dateTime),
            cts.elementQuery(fn.QName("http://marklogic.com/manage/meters", "host-statuses"), cts.andQuery([])),
            cts.elementValueQuery(fn.QName("http://marklogic.com/manage/meters","period"), "raw"),
            // TODO - host is hard coded for now
            cts.elementValueQuery(fn.QName("http://marklogic.com/manage/meters","host-name"), "dbslp0872.uhc.com")
        ])
    )
	var iowait = x.xpath('//*:total-cpu-stat-iowait');
  	return fn.data(iowait);
}

xdmp.setResponseContentType("application/json"),
// [cts.elementValues(fn.QName("http://marklogic.com/manage/meters","start-time")))]
xdmp.toJSON(
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
				"x": cts.elementValues(fn.QName("http://marklogic.com/manage/meters","start-time")), 
				"line": { 
					"shape": "spline"
				}, 
				"type": "scatter", 
				"name": "iowait"
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
);

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