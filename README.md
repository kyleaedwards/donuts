# Donuts <small>[Alpha]</small>
Orchestrating Audio/MIDI in the Browser

## Overview

**Donuts** is a web-based environment for orchestrating audio, MIDI, and click-synched devices. It was initially envisioned to sync a [Teenage Engineering Pocket Operator](https://www.teenageengineering.com/products/po) and a MIDI-to-CV converter (in my case the [Korg SQ-1](https://www.korg.com/us/products/dj/sq_1/)) to a common tempo, and provide some additional functionality to get as much as possible out of a handful of entry-level musicmaking devices.

## Features

### Click Track

The **Click** track defaults to a high-pitched 15ms burst triggered on every eighth note, which I have had luck in using to sync a Pocket Operator. However, click-synching can prove somewhat tricky, and depending on which device you're synching, it may be necessary to configure the waveform, frequency, duration, amplitude, and PPQN (pulses-per-quarter note) of the clicks.

#### PO-Sync Mode

The calculator icon to the right of the click toggle activates **PO-Sync** mode, which pans any audio hard left and pans the click track right. This is particularly useful when using a [Teenage Engineering Pocket Operator](https://www.teenageengineering.com/products/po). On the correct PO-Sync mode, this will allow the audio to pass through into the PO chain while the clicks will sync the tempo.

### Outputs

Outputs are limited to either an internal audio output (starting with a simple WebAudio synth or sample bank) or an external MIDI channel.

### Inputs

Some programs may accept user input, doing anything from recording to a piano roll from the keyboard, to passing MIDI events through to the output, to allowing a gamepad to trigger chord changes.

## Programs

The core functionality of Donuts is organized into the following programs:

- Step Sequencer

#### Planned

- Melody Generator *[Not Implemented]*
- Chord + Bassline Generator *[Not Implemented]*
- MIDI-Thru/Key Mapper *[Not Implemented]*
- Piano Roll *[Not Implemented]*
- Euclidean Motion Sequencer *[Not Implemented]*
- MIDI-CC Sequencer *[Not Implemented]*

### Step Sequencer

The step sequencer is a looping polyrhythmic/probabilistic sequencer where each of its tracks has an independent length that can be set between 1 to 24 steps. The sequencer's step size can be adjusted between sixteenth, eighth, quarter, half, and whole step intervals. Every step has an adjustable probability of triggering an event, which can be set between 1% and 100%.

In sampler mode, each track corresponds to a given entry in a sampler bank. In MIDI/synth mode, each track corresponds to a note in an adjustable scale. Note that if your MIDI device is monophonic, only one note will get triggered simultaneously.