// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require turbolinks
//= require rails-ujs
//= require turbolinks
//= require_tree .

var label = [];
var value = [];

function myFunction(bIndex) {
  label.splice(bIndex, 1);
  value.splice(bIndex, 1);
  
  window.sessionStorage.setItem("label", JSON.stringify(label));
  window.sessionStorage.setItem("value", JSON.stringify(value));
  location.reload();
}

$( document ).ready(function(){

  if(JSON.parse(sessionStorage.getItem("label")) != null){
    label = JSON.parse(sessionStorage.getItem("label"));
    labelOutput();
  }

  if(JSON.parse(sessionStorage.getItem("value")) != null){
    value = JSON.parse(sessionStorage.getItem("value"));
    valueOutput();
  }
  
var target;
var height;
var width;
var x;
var y;

function dragMoveListener (event) {
  target = event.target,
      // keep the dragged position in the data-x/data-y attributes
      x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx,
      y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

  // translate the element
  target.style.webkitTransform =
  target.style.transform =
    'translate(' + x + 'px, ' + y + 'px)';

  // update the posiion attributes
  target.setAttribute('data-x', x);
  target.setAttribute('data-y', y);

  boxPosition(x,y);
}

// this is used later for resizing
window.dragMoveListener = dragMoveListener;

interact('.resize-drag')
  .draggable({
    onmove: window.dragMoveListener,
    restrict: {
      restriction: 'parent',
      elementRect: { top: 0, left: 0, bottom: 1, right: 1 }
    },
  })
  .resizable({
    // resize for only right and bottom
    edges: { left: false, right: true, bottom: true, top: false },

    // keep the edges inside the parent
    restrictEdges: {
      outer: 'parent',
      endOnly: true,
    },

    // minimum size
    restrictSize: {
      min: { width: 1, height: 1 },
      max: { width: 700, height: 1000 },
    }

  })
  
  .on('resizemove', function (event) {
    target = event.target,
        xResize = (parseFloat(target.getAttribute('data-x')) || 0),
        yResize = (parseFloat(target.getAttribute('data-y')) || 0);
        
    // update the element's style
    width = target.style.width  = event.rect.width + 'px';
    height = target.style.height = event.rect.height + 'px';

    target.textContent = '' ;
    
    boxDimensions(height, width);
  });

//Get the start position of the box
function boxPosition(x, y){
  x = parseInt(x);
  y = parseInt(y);
  var startPoint = [x, y];
  //console.log(startPoint);
  return startPoint;
}

//Get the height and width of the box
function boxDimensions(height, width){
  height = parseInt(height.replace(/\D/g,''));
  width = parseInt(width.replace(/\D/g,''));
  var bDimensions = [height, width]
  //console.log(bDimensions);
  return bDimensions;
}

$("#textOutput1").html('Please select a label');
let counter = 0;
var valueCheck = 0;

$("#target").click(function(){

  let topLeft = [boxPosition(x,y)[0], boxPosition(x,y)[1]]
  let topRight = [boxPosition(x,y)[0] + boxDimensions(height, width)[1], boxPosition(x,y)[1]]
  let bottomRight = [topRight[0], boxPosition(x,y)[1] + boxDimensions(height, width)[0]];
  let bottomLeft = [topLeft[0], topLeft[1] + boxDimensions(height,width)[0]];

  let keyBox = [topLeft, topRight, bottomRight, bottomLeft];
  let valueBox = [topLeft, topRight, bottomRight, bottomLeft];

  //Print out Label box in document
  if(counter == 0){
    $("#textOutput1").html('Please select a value');
    label.push(keyBox);
    counter = 1;
    
    labelOutput();

  }else{ //Print out Value box in document
    $("#textOutput1").html('Please select a label');
    value.push(valueBox);
    counter = 0;

    valueOutput()
    
  }
});

})


function labelOutput(){
  var canvas = document.getElementById('canvas');
  var ctx = canvas.getContext('2d');
  ctx.beginPath();

  //Draw label canvas in document
  for(let i=0; i<label.length; i++){
    canvasX = label[i][0][0];
    canvasY = label[i][0][1];
    canvasWidth = label[i][1][0] - canvasX;
    canvasHeight = label[i][3][1] - canvasY;
  
    ctx.rect(canvasX, canvasY, canvasWidth, canvasHeight); // x, y, width, height
    ctx.strokeStyle="blue";
    ctx.stroke();

  }

    //Print out selected label co-ordinates
    $("#selectedLabels").empty();
    $.each(label, function(boxIndex, boxValue){
      $("#selectedLabels").append(
        "Box Position for Label: " + boxIndex + "</br>" +
        "<b>T Left: </b>" + boxValue[0] + " | <b>T Right: </b>" + boxValue[1] + "</br>" +
        "<b>B Left: </b>" + boxValue[3] + " | <b>B Right: </b>" + boxValue[2] + "</br></br>"
      );
   });
}

function valueOutput(){
  var canvas = document.getElementById('canvas');
  var ctx = canvas.getContext('2d');
  ctx.beginPath();

  //Draw value canvas in document
  for(let i=0; i<value.length; i++){
    canvasX = value[i][0][0];
    canvasY = value[i][0][1];
    canvasWidth = value[i][1][0] - canvasX;
    canvasHeight = value[i][3][1] - canvasY;
  
    ctx.rect(canvasX, canvasY, canvasWidth, canvasHeight); // x, y, width, height
    ctx.strokeStyle="#03C03C";
    ctx.stroke();

  }

  //Print out select value co-ordinates
  $("#selectedRows").empty();
  $("#selectedValues").empty();
  $.each(value, function(boxIndex, boxValue){
    
    $("#selectedValues").append(
      "Box Position for Value: " + boxIndex + "</br>" +
      "<b>T Left: </b>" + boxValue[0] + " | <b>T Right: </b>" + boxValue[1] + "</br>" +
      "<b>B Left: </b>" + boxValue[3] + " | <b>B Right: </b>" + boxValue[2] + "</br></br>"
    );
    
    $("#selectedRows").append('<button onclick="myFunction('+boxIndex+')">Delete Row</button></br>');
    
  });
}