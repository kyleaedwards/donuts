module Routine.Sequencer.Types exposing (..)

import Array exposing (Array)


type alias Clip =
    String


type StepEnabled
    = StepOn
    | StepOff


type alias Step =
    { enabled : StepEnabled
    , chance : Float
    }


type alias Track =
    { name : String
    , clip : Clip
    , sequence : Array Step
    , steps : Int
    , lastSteps : Int
    , currentIndex : Int
    }


type alias Sequencer =
    { trackResizing : Maybe Int
    , sequencerIndex : Int
    , sequencerStepSize : Int
    , tracks : Array Track
    }


type SequencerMsg
    = ToggleSequencerStep Int Int
