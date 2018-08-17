var PREFIX = '/samples/';
var EXTENSION = '.wav';

function loadClips(context, urlList, cb) {
  var length = 0;
  var complete = 0;
  var buffers = {};
  var errors = [];
  if (urlList && urlList.length) {
    length = urlList.length;
  }
  if (!length) {
    cb([new Error('Empty url list')]);
    return;
  }
  for (var i = 0; i < length; i++) {
    var url = urlList[i];
    loadSingleClip(context, buffers, url, function (err) {
      if (err) {
        errors.push(err);
      }
      complete++;
      if (complete === length) {
        if (errors.length) {
          cb(errors);
          return;
        }
        cb(null, buffers);
      }
    });
  }
}

function loadSingleClip(context, buffers, url, cb) {
  var request = new XMLHttpRequest();
  console.log(PREFIX + url + EXTENSION);
  request.open("GET", PREFIX + url + EXTENSION, true);
  request.responseType = "arraybuffer";

  request.onload = function () {
    context.decodeAudioData(
      request.response,
      function (buffer) {
        if (!buffer) {
          cb(new Error('Error decoding file data: ' + url));
          return;
        }
        buffers[url] = buffer;
        cb(null);
      },
      cb
    );
  }

  request.onerror = function() {
    cb(new Error('Error loading file: ' + url));
  }

  request.send();
}

function createSource(context, output, buffer) {
  var source = context.createBufferSource();
  var gain = context.createGain();
  gain.gain.value = 0.5;
  source.buffer = buffer;
  source.loop = false;
  source.connect(gain);
  gain.connect(output);
  return source;
}

module.exports = function sampler(context) {
  var buffers = {};
  var samples = ['hihat', 'snare', 'kick', 'bottle', 'wood', 'hey', 'rattle', 'pipe', 'clap', 'doo'];
  loadClips(context, samples, function (errs, bufs) {
    if (errs) {
      for (var i = 0; i < errs.length; i++) {
        console.log(errs[i]);
      }
      return;
    }
    buffers = bufs;
  });

  const pan = context.createStereoPanner();
  pan.pan.setValueAtTime(0, context.currentTime);
  pan.connect(context.destination);

  return {
    trigger: function trigger(sample) {
      if (buffers[sample]) {
        createSource(context, pan, buffers[sample])
          .start(context.currentTime);
      }
    },
    setPanCenter: function setPanCenter() {
      pan.pan.setValueAtTime(0, context.currentTime);
    },
    setPanLeft: function setPanCenter() {
      pan.pan.setValueAtTime(-1, context.currentTime);
    },
    setPanRight: function setPanCenter() {
      pan.pan.setValueAtTime(1, context.currentTime);
    }
  };
}