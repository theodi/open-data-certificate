//= require lib/d3.v3
//= require lib/queue.v1
//= require lib/topojson

$(function(){


    // homepage map visualisation
  $('#international-reach').each(function(){

    var autochange = true;

    var $panel = $(this);

    $panel.hover(function(){
      autochange = false;
    }, function(){
      autochange = true;
    });

    $map = $('.map', this);
    $jurisdictions = $('select', this);
    $actions = $('.actions', this);
    $statuses = $('.statuses', this);

    var access_code;
    $actions.on('click', '.create-certificate', function(){
      // use the related certificate to populate the dialog form
      
      var $hidden = $('<input>', {type: 'hidden', name:'survey_access_code', value:access_code});
      $hidden.appendTo('form.start-survey');

      // remove on close
      $(document).one('hidden', '.modal', function () {
        $hidden.remove();
      });
    });


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
    var dropdown = d3.select($jurisdictions.get(0));

   queue()
    .defer(d3.json, "/assets/data/world-110m.json")
    .defer(d3.tsv, "/assets/data/world-country-names.tsv")
    .defer(d3.json, "/surveys/jurisdictions.json")
    .await(ready);

    function ready(error, world, names, jurisdictions) {
      var globe = {type: "Sphere"},
          land = topojson.feature(world, world.objects.land),
          countries = topojson.feature(world, world.objects.countries).features,
          borders = topojson.mesh(world, world.objects.countries, function(a, b) { return a !== b; }),
          i = -1,
          n = countries.length;

      countries = countries.filter(function(d) {
        return names.some(function(n) {
          if (d.id == n.id) return (d.name = n.name);
        }) && jurisdictions.some(function(n) {
          if (d.name == n.title) return $.extend(d, n);
        });
      }).sort(function(a, b) {
        return a.full_title.localeCompare(b.full_title);
      });

      dropdown
        .on('change', function(d){
          setJurisdiction(this.options[this.selectedIndex].__data__);
          autochange = false;
        })
        .selectAll('option')
        .data(countries).enter().append("option")
        .text(function(d){ return d.full_title; });


      function setJurisdiction(country){
          d3.transition()
            .duration(1250)
            .each("start", function() {
              $actions.find('.badge').text(country.name);
              $actions.find('.status').text(country.status);
              $actions.show();

              $statuses.children('.' + country.status).show()
                        .siblings().hide();

              access_code = country.access_code;

              dropdown.selectAll('option')
                .property('selected', function(d){return d.id == country.id ? 'selected' : '';});


            })
            .tween("rotate", function() {
              var p = d3.geo.centroid(country),
                  r = d3.interpolate(projection.rotate(), [-p[0], -p[1]]);
              return function(t) {
                projection.rotate(r(t));
                c.clearRect(0, 0, width, height);
                c.fillStyle = "#000", c.beginPath(), path(land), c.fill();
                c.fillStyle = "#00b7ff", c.beginPath(), path(country), c.fill();
                c.strokeStyle = "#fff", c.lineWidth = .5, c.beginPath(), path(borders), c.stroke();
                // c.strokeStyle = "#000", c.lineWidth = 1, c.beginPath(), path(globe), c.stroke();
              };
            });
      }


      function randomJurisdiction(){
        var country = countries[Math.floor(Math.random()*countries.length)];
        setJurisdiction(country);
      }


      setInterval(function(){
        if(autochange) randomJurisdiction();
      }, 2500);

      // start now
      randomJurisdiction();

      // display the panel
      $panel.css({visibility:'visible',height:''});

    }


  });


})