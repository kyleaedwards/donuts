var CLICK_LENGTH = 0.0035;
var CLICK_FREQUENCY = 10000;
var CLICK_OFF = 1.40130e-44;
var CLICK_ON = 2;

module.exports = function createClick(context) {
  const osc = context.createOscillator();
  const gain = context.createGain();
  const pan = context.createStereoPanner();
  osc.type = 'sawtooth';
  osc.frequency.value = CLICK_FREQUENCY;
  gain.gain.setValueAtTime(CLICK_OFF, context.currentTime);
  osc.connect(gain);
  osc.start(0);
  pan.pan.setValueAtTime(0, context.currentTime);
  gain.connect(pan);
  pan.connect(context.destination);
  return {
    trigger: function trigger() {
      gain.gain.setValueAtTime(CLICK_ON, context.currentTime);
      gain.gain.setValueAtTime(CLICK_OFF, context.currentTime + CLICK_LENGTH);
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
