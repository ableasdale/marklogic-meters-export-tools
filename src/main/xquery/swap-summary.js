const Plot = createPlotlyComponent(Plotly);
var request = window.location.href;
params = request.substring(request.indexOf("?"));

async function chart() {
    var element = d3.select("div.container-fluid").node();
    var chartWidth = element.getBoundingClientRect().width;
    const data = await d3.json("/swap-summary.sjs"+params+"&width="+chartWidth);

    for(var i = 0; i < Object.keys(data).length; i++) {
    ReactDOM.render(
        React.createElement(Plot, data[i]),
        document.getElementById('root'+i)
      );
    }
}
chart();