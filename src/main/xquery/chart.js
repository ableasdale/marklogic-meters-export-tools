const Plot = createPlotlyComponent(Plotly);
var request = window.location.href;
params = request.substring(request.indexOf("?"));

async function chart() {
    var element = d3.select("div.container-fluid").node();
    var chartWidth = element.getBoundingClientRect().width;

    const data = await d3.json("/chart.sjs"+params+"&width="+chartWidth);
    console.dir(data.layout);

    ReactDOM.render(
        React.createElement(Plot, data),
        document.getElementById('root')
      );
}

chart();