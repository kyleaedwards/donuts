'use strict';

require('./css/style.css');
require('./index.html');

var Elm = require('./Main.elm');
var Click = require('./js/click');
var Sampler = require('./js/sampler');

var AudioContext = window.AudioContext || window.webkitAudioContext;
var audioCtx;

try {
  audioCtx = new AudioContext();
} catch (e) {
  console.log(e);
}

var app = Elm.Main.fullscreen({});

var click = Click(audioCtx);
app.ports.triggerClick.subscribe(function () {
  click.trigger();
});

app.ports.toggleSyncMode.subscribe(function (sync) {
  if (sync) {
    sampler.setPanRight();
    click.setPanLeft();
  } else {
    sampler.setPanCenter();
    click.setPanCenter();
  }
});

var sampler = Sampler(audioCtx);
app.ports.triggerSample.subscribe(function (sample) {
  sampler.trigger(sample);
});

app.ports.log.subscribe(function (words) {
  console.log('[INFO]:', words);
});
