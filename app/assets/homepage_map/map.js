//= require lib/d3.v3
//= require lib/topojson

console.log(">>> MAPS !!!")

$(function(){


    // homepage map visualisation
  $('#international-reach').each(function(){

    $map = $('.map', this);

    var width = 500,
        height = 500;

    var projection = d3.geo.orthographic()
        .scale(250)
        .translate([width / 2, height/2])
        .clipAngle(90);

    var path = d3.geo.path()
        .projection(projection);

    var λ = d3.scale.linear()
        .domain([0, width])
        .range([-180, 180]);

    var φ = d3.scale.linear()
        .domain([0, height])
        .range([90, -90]);

    var svg = d3.select($map.get(0)).append("svg")
        .attr("width", width)
        .attr("height", height);

    svg.on("mousemove", function() {
      var p = d3.mouse(this);
      projection.rotate([λ(p[0]), φ(p[1])]);
      svg.selectAll("path").attr("d", path);
    });

    d3.json("/assets/data/world-110m.json", function(error, world) {
      svg.append("path")
          .datum(topojson.feature(world, world.objects.land))
          .attr("class", "land")
          .attr("d", path);
    });

  });


})