// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

const applicationInstaller = require('application-installer');

const pkg = require(__dirname + '/package.json')
const EventEmitter = require('events');

const process = require('process');

const fs = require('fs');
const path = require('path');
const url = require('url')

const envPaths = require('env-paths');


const messages = [];
const log = function(message){
  messages.push(message);
  console.log(message)
}

class MyEmitter extends EventEmitter {}
const emitter = new MyEmitter();


/* * *
  BODY DROP INIT
* * */

document.ondragover = document.ondrop = (ev) => {
  ev.preventDefault();
}
document.body.ondrop = (ev) => {
  ev.preventDefault()
  const file = ev.dataTransfer.files[0].path;
  emitter.emit('document-drop', {file})
}

emitter.on('background-color', (data) => {
  $("body").css({background: data.color})
});

emitter.on('foreground-color', (data) => {
  $("body").css({color: data.color})
});



/* * *
  VUE COMPONENT EXAMPLE
* * */

var appConfiguration = new Vue({
  el: '#app-configuration',
  data: {package:pkg, configuration:{}},
  created: function () {
    emitter.on('application-installer-configuration', (configuration) => {
      this.configuration = configuration;
    });
  }
});

var appProgress = new Vue({
  el: '#app-progress',
  data: {
    progress: 0,
  },
  created: function () {
    emitter.on('application-installer-progress', (data) => {
      this.progress = data.progress;
    });
  }

});




/* * *
  JQUERY EXAMPLE
* * */

$(function(){
    $('title').text(__dirname);
});




/* * *
  INTERNAL API EXAMPLE
* * */

emitter.on('document-drop', (data) => {
  alert('Dropped ' + data.file);
});



let configurationFile = "";
if(fs.existsSync( path.join(__dirname, 'configuration.json') )) configurationFile = path.join(__dirname, 'configuration.json');
if(fs.existsSync( path.join( path.dirname(__dirname), 'configuration.json') )) configurationFile = path.join( path.dirname(__dirname), 'configuration.json');

const configuration = require(configurationFile);

const paths = envPaths( [configuration.application, pkg.name].join("-") );

// console.log(require('electron').remote.process.chdir)

applicationInstaller(Object.assign({

  // cwd: require('electron').remote.process.chdir,

  emitter,
  log,

  configurationFile,

  location: path.join( paths.cache, 'core' ),

  open: true,

}, configuration));
