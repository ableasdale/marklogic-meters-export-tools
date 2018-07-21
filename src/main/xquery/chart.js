const Plot = createPlotlyComponent(Plotly);
var request = window.location.href;
params = request.substring(request.indexOf("?"));

async function chart() {
    const data = await d3.json("/chart.sjs"+params);
    console.dir(data.layout);

    ReactDOM.render(
        React.createElement(Plot, data),
        document.getElementById('root')
      );
}

chart();