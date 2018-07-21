const Plot = createPlotlyComponent(Plotly);

async function chart() {
    const data = await d3.json("/chart.sjs");
    console.dir(data.layout);

    ReactDOM.render(
        React.createElement(Plot, data),
        document.getElementById('root')
      );
}

chart();