const Plot = createPlotlyComponent(Plotly);
var request = window.location.href;
params = request.substring(request.indexOf("?"));

async function chart() {
    const data = await d3.json("/multicharts.sjs"+params);

    // console.log(Object.keys(data).length);
    for(var i = 0; i < Object.keys(data).length; i++) {
        ReactDOM.render(
            React.createElement(Plot, data[i]),
            document.getElementById('root'+i)
        );
    }
}

chart();