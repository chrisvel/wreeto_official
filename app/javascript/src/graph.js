var ready = function(){
  console.log($.inPage("notes", "show"));
  if ($.inPage("notes", "show")) {
    (function (d3$1) {
      'use strict';
    
      const svg = d3$1.select('#note-graph svg');
      const width = +svg.attr('width'); 
      const height = +svg.attr('height');
      const centre_x = width / 2;
      const centre_y = height / 2;
      const colorScale = ["grey","purple","pink", "gold", "orange"];
    
      svg.attr("preserveAspectRatio", "xMidYMid meet")
        .attr("viewBox", [0, 0, width * 2, height * 2]);
    
      const defs = svg.append("defs");
          defs.selectAll("marker")
            .data(["node"])
            .enter()
            .append("marker")
            .attr("id", d => d)
            .attr("viewBox", "0 -2.5 5 5")
            .attr("refX", 16)
            .attr("refY", 0)
            .attr("markerWidth", 5)
            .attr("markerHeight", 5)
            .attr("orient", "auto")
            .append("path")
            .attr("d", "M0,-2.5L5,0L0,2.5")
            .attr("fill", "#999");
      
      var url = window.location.pathname;
      var guid = url.substring(url.lastIndexOf('/') + 1);
      
      d3.json("/notes/"+ guid + "/network_data.json")
        .then(data => {
        
        const links = data.links.map(d => Object.create(d));
        links.forEach((d, i) => {
          d.srcType = data.links[i].srcType;
          d.tgtType = data.links[i].tgtType;
          d.relationship = data.links[i].relationship;
          d.value = data.links[i].value;
        });
        const nodes = data.nodes.map(d => Object.create(d));
        nodes.forEach((d, i) => {
          d.group = data.nodes[i].group;
        });
    
        const simulation = d3.forceSimulation(nodes)
            .force("link", d3.forceLink(links)
                  .id(d => d.id)
                  .distance(150))
            .force("charge", d3.forceManyBody()
                  .strength(-500)
                  // .distanceMax(200)
                  )
      // 		.force("x", d3.forceX())
      // 		.force("y", d3.forceY())
            .force("collision", d3.forceCollide()
                    .radius(25)
                  )
            .force("center", d3.forceCenter(width, height))
        ;
    
        const drag = simulation => {
          function dragstarted(event) {
            if (!event.active) simulation.alphaTarget(0.5).restart();
            event.subject.fx = event.subject.x;
            event.subject.fy = event.subject.y;
      //      d3.select(this).classed("fixed", true);
        //   console.log(d);
          }
          function dragged(event) {
            event.subject.fx = event.x;
            event.subject.fy = event.y;
          }
          function dragended(event, d) {
            if (!event.active) simulation.alphaTarget(0);
            event.subject.fx = null;
            event.subject.fy = null;
          }
          return d3.drag()
            .on("start", dragstarted)
            .on("drag", dragged)
            .on("end", dragended);
        };
    
        const link = svg.append("g")
          .selectAll("line")
          .data(links)
          .join("line")
          .attr("marker-end", "url(#node)");
        
        const node = svg.append("g")
          .attr("class", "node")
          .selectAll("g")
          .data(nodes)
          .enter()
          .append("g")
          .attr("transform", d => "translate(" + centre_x + ", " + centre_y + ")");
        
        const circles = node.append("circle")
            .attr("r", 30)
            .attr("fill", d => colorScale[d.group])
            .on("mouseover", focusNode)
            .on("mouseout", blurNode)
            .on("dblclick", d3.select(this).classed("fixed", false))
            .call(drag(simulation));
        
        const nodeLbl = node.append("text")
            .text(d => d.label)
            .style("font-size", "24px")
            .attr("dy", "2.8em");
        
        simulation.on("tick", () => {
          link
            .attr("x1", d => d.source.x)
            .attr("y1", d => d.source.y)
            .attr("x2", d => d.target.x)
            .attr("y2", d => d.target.y);
          node
            .attr("transform", d => "translate(" + d.x + ", " + d.y + ")");
        });
        
        function focusNode() {
          d3.select(this).classed("nodeHover", true);
        }
    
        function blurNode() {
          d3.select(this).classed("nodeHover", false);
        }
    
      });
    
    }(d3));
  };
};

$(document).ready(ready);
$(document).on('page:load', ready);