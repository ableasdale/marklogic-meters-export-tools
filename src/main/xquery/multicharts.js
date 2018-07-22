const Plot = createPlotlyComponent(Plotly);
var request = window.location.href;
params = request.substring(request.indexOf("?"));

async function chart() {
    const data = await d3.json("/multicharts.sjs"+params);
    //console.dir(data.layout);

    ReactDOM.render(
        React.createElement(Plot, data[0]),
        document.getElementById('root0')
      );

    ReactDOM.render(
        React.createElement(Plot, data[1]),
        document.getElementById('root1')
    );
}

chart();