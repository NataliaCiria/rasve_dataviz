
var drawGraph = function(){
  
  //var file = FileAttachment("mc_results.csv");
  //d3.csvParse(await file.text());
  // Specify the path to the CSV file
  const csvFilePath = 'mc_results.csv';
  
   
  
  // Use d3.csv() to load the CSV file
  d3.csv(csvFilePath)
    .then(function(data) {
      // Process the loaded CSV data
      console.log(data);
      // Perform any desired data manipulation or visualization using D3
    })
    .catch(function(error) {
      // Handle any errors that occur during the loading process
      console.log('Error loading CSV file:', error);
    });
    
    //data[0]['mean']

	//number of circles to color in to visualize percent
	var percentNumber = 98;

	//variables for the font family, and some colors
	var fontFamily = "helvetica";
	var FillFalse = "#BAD3D3";
	var FillTrue = "#F28F3B";
	var svgBackgroundColor = '#F8F8F8';

	//width and height of the SVG
	const width = 500;
	const height = 500;

	//create an svg with width and height
	var svg = d3.select('#grid-chart')
		.append('svg')
		.attr("width", width)
		.attr("height", height)
    	.style('background-color', svgBackgroundColor);

	//10 rows and 10 columns 
	var numRows = 10;
	var numCols = 10;

	//x and y axis scales
	var y = d3.scaleBand()
		.range([0,250])
		.domain(d3.range(numRows));

	var x = d3.scaleBand()
		.range([0, 250])
		.domain(d3.range(numCols));

	//the data is just an array of numbers for each cell in the grid
	var data = d3.range(numCols*numRows);

	//container to hold the grid
	var container = svg.append("g")
		.attr("transform", "translate(135,130)");
	

	container.selectAll("circle")
			.data(data)
			.enter().append("circle")
			.attr("id", function(d){return "id"+d;})
			.attr('cx', function(d){return x(d%numCols);})
			.attr('cy', function(d){return y(Math.floor(d/numCols));})
			.attr('r', 12)
			.attr('fill', function(d){return d < percentNumber ? FillTrue : FillFalse;})

}

	//call function to draw the graph
	drawGraph();