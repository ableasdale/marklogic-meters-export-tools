const Plot = createPlotlyComponent(Plotly);

ReactDOM.render(
  React.createElement(Plot, {
    data: [
      {
          "x": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
          "y": [1, 2, 4, 8, 16, 16, 16, 16, 16, 16, 16, 16, 16]  
          
      }

  ], margin: { t: 0 }
  }),
  document.getElementById('root')
);

/*
//var url='/chart.json';
var chartdata = {"data":[{"name":"Col2", "uid":"babced", "fillcolor":"rgb(224, 102, 102)", "y":["17087182", "29354370", "38760373", "40912332", "51611646", "64780617", "85507314", "121892559", "172338726", "238027855", "206956723", "346004403", "697089489", "672985183", "968882453", "863105652", "1068513050"], "x":["2000-01-01", "2001-01-01", "2002-01-01", "2003-01-01", "2004-01-01", "2005-01-01", "2006-01-01", "2007-01-01", "2008-01-01", "2009-01-01", "2010-01-01", "2011-01-01", "2012-01-01", "2013-01-01", "2014-01-01", "2015-01-01", "2016-01-01"], "fill":"tonexty", "type":"scatter", "mode":"none"}], "layout":{"autosize":false, "title":"Total Number of Websites", "yaxis":{"range":[0, 1124750578.94737], "type":"linear", "autorange":true, "title":""}, "height":500, "width":800, "xaxis":{"tickformat":"%Y", "title":"Source: <a href=\"http://www.scribblrs.com/\">Scribblrs</a><br>Source: <a href=\"http://www.internetlivestats.com/total-number-of-websites/\">Internet Live Stats</a>", "showgrid":false, "range":[946702800000, 1451624400000], "type":"date", "autorange":true}}};
console.log("hellohello");

/*d3.json(url, function(error, data) {
  if (error) return console.warn(error);
  //var layout = {barmode: 'group'};
  console.log("in d3");
  chartdata = data;
  
  
 //Plotly.newPlot('tester', data.data, layout);
}); 
console.dir(chartdata);
d3.json('/chart.sjs').then(function(error, data) {
  console.log("got chart data - WHY CAN'T I SEE IT?");
  //chartdata=data;
  console.dir(data);
  console.log("data should be above")
});

console.log("hello again");
*/
/*



d3.json(url, function(error, data) {
  if (error) return console.warn(error);
  var layout = {barmode: 'group'};
  
 Plotly.newPlot('tester', data.data, layout);
}); */