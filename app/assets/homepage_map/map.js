//= require lib/d3.v3
//= require lib/queue.v1
//= require lib/topojson
$(function(){

  // hide the panel when d3 is unsupported
  if(!window.enableMap) return $('#international-reach').hide();

  var colours = {
    alpha: "#666",
    beta: "#000",
    "final": "#006e99",
    selected: "#00b7ff",
    border: "#fff"
  };


    // homepage map visualisation
  $('#international-reach').each(function(){

    var access_code,
        autoadvance = true,
        $panel = $(this),
        $map = $('.map', this),
        $jurisdictions = $('select', this),
        $actions = $('.actions', this),
        $statuses = $('.statuses', this),
        $autoadvance = $('.autoadvance', this);

    $autoadvance.on('click', function(){
      $autoadvance.fadeOut();
      autoadvance = true;
    })
    // autoadvance by default
    .hide();

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
        return (a.full_title||"").localeCompare(b.full_title);
      });

      // This isn't a very efficient way to do this, ideally we'd create 
      // seperate land regions for each status, though this will work while
      // we've only got a few
      var achieved = {
        // 'alpha' : default colour
        'beta':countries.filter(function(d){
          return d.status == 'beta';
        }),
        'final':countries.filter(function(d){
          return d.status == 'final';
        })
      };

      dropdown
        .on('focus', function(){
          autoadvance = false;
          $autoadvance.fadeIn();
        })
        .on('change', function(d){
          setJurisdiction(this.options[this.selectedIndex].__data__);
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

                // alpha (everything)
                c.fillStyle = colours.alpha, c.beginPath(), path(land), c.fill();

                // beta
                c.fillStyle = colours.beta, c.beginPath(), achieved.beta.forEach(path), c.fill();

                // final
                c.fillStyle = colours['final'], c.beginPath(), achieved['final'].forEach(path), c.fill();

                // selected
                c.fillStyle = colours.selected, c.beginPath(), path(country), c.fill();

                // borders
                c.strokeStyle = colours.border, c.lineWidth = .5, c.beginPath(), path(borders), c.stroke();

                // outline
                // c.strokeStyle = "#000", c.lineWidth = 1, c.beginPath(), path(globe), c.stroke();
              };
            });
      }


      function randomJurisdiction(){
        var country = countries[Math.floor(Math.random()*countries.length)];
        setJurisdiction(country);
      }

      function inView($element){
        var $window = $(window);
        return $element.offset().top < ($window.height() + $window.scrollTop());
      }


      setInterval(function(){
        if(autoadvance && inView($panel)) randomJurisdiction();
      }, 2500);

      // start now
      randomJurisdiction();

      // display the panel
      $panel.css({visibility:'visible',height:''});

    }


  });


})