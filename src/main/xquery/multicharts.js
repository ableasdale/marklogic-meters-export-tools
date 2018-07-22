const Plot = createPlotlyComponent(Plotly);
var request = window.location.href;
params = request.substring(request.indexOf("?"));

async function chart() {
    const data = await d3.json("/multicharts.sjs"+params);
    //console.dir(data.layout);

    // TODO - ultimately do these in a loop rather than hard code them
    ReactDOM.render(
        React.createElement(Plot, data[0]),
        document.getElementById('root0')
      );

    ReactDOM.render(
        React.createElement(Plot, data[1]),
        document.getElementById('root1')
    );

    ReactDOM.render(
        React.createElement(Plot, data[2]),
        document.getElementById('root2')
    );

    ReactDOM.render(
        React.createElement(Plot, data[3]),
        document.getElementById('root3')
    );
}

chart();