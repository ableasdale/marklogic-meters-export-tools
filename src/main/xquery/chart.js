const Plot = createPlotlyComponent(Plotly);

ReactDOM.render(
  React.createElement(Plot, {
    data: [{x: [1, 2, 3], y: [2, 1, 3]}],
  }),
  document.getElementById('root')
);