//= require lib/d3.v3
//= require lib/queue.v1
//= require lib/topojson

console.log(">>> MAPS !!!")

$(function(){


    // homepage map visualisation
  $('#international-reach').each(function(){

    $map = $('.map', this);

    // var width = 500,
    //     height = 500;

    // var projection = d3.geo.orthographic()
    //     .scale(250)
    //     .translate([width / 2, height/2])
    //     .clipAngle(90);

    // var path = d3.geo.path()
    //     .projection(projection);

    // var λ = d3.scale.linear()
    //     .domain([0, width])
    //     .range([-180, 180]);

    // var φ = d3.scale.linear()
    //     .domain([0, height])
    //     .range([90, -90]);

    // var svg = d3.select($map.get(0)).append("svg")
    //     .attr("width", width)
    //     .attr("height", height);

    // svg.on("mousemove", function() {
    //   var p = d3.mouse(this);
    //   projection.rotate([λ(p[0]), φ(p[1])]);
    //   svg.selectAll("path").attr("d", path);
    // });

    // d3.json("/assets/data/world-110m.json", function(error, world) {
    //   svg.append("path")
    //       .datum(topojson.feature(world, world.objects.land))
    //       .attr("class", "land")
    //       .attr("d", path);
    // });


    var width = 500,
        height = 500;

    var projection = d3.geo.orthographic()
        .translate([width / 2, height/2])
        .scale(248)
        .clipAngle(90);

    var canvas = d3.select($map.get(0)).append("canvas")
        .attr("width", width)
        .attr("height", height);

    var c = canvas.node().getContext("2d");

    var path = d3.geo.path()
        .projection(projection)
        .context(c);

    var title = d3.select("h1");

    queue()
    .defer(d3.json, "/assets/data/world-110m.json")
    .defer(d3.tsv, "/assets/data/world-country-names.tsv")
    .await(ready);

    function ready(error, world, names) {
      console.log(error, world, names)
      var globe = {type: "Sphere"},
          land = topojson.feature(world, world.objects.land),
          countries = topojson.feature(world, world.objects.countries).features,
          borders = topojson.mesh(world, world.objects.countries, function(a, b) { return a !== b; }),
          i = -1,
          n = countries.length;

      countries = countries.filter(function(d) {
        return names.some(function(n) {
          if (d.id == n.id) return d.name = n.name;
        });
      }).sort(function(a, b) {
        return a.name.localeCompare(b.name);
      });

      (function transition() {
        d3.transition()
            .duration(1250)
            .each("start", function() {
              title.text(countries[i = (i + 1) % n].name);
            })
            .tween("rotate", function() {
              var p = d3.geo.centroid(countries[i]),
                  r = d3.interpolate(projection.rotate(), [-p[0], -p[1]]);
              return function(t) {
                projection.rotate(r(t));
                c.clearRect(0, 0, width, height);
                c.fillStyle = "#000", c.beginPath(), path(land), c.fill();
                c.fillStyle = "#f00", c.beginPath(), path(countries[i]), c.fill();
                c.strokeStyle = "#fff", c.lineWidth = .5, c.beginPath(), path(borders), c.stroke();
                // c.strokeStyle = "#000", c.lineWidth = 1, c.beginPath(), path(globe), c.stroke();
              };
            })
          .transition()
            .each("end", transition);
      })();
    }


  });


})