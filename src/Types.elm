module Types exposing (..)

import Array exposing (..)
import Routine.Types as Routine
import Mouse


type alias Model =
    -- Mouse Events
    { mouseX : Maybe Int
    , dragEvent : DragEvent

    -- Tempo
    , tempo : Tempo
    , position : Position
    , lastPosition : Position
    , swing : Float
    , playback : Playback

    -- Click Track
    , poSyncEnabled : Enabled
    , isClicking : Bool
    , ppqn : Int
    , nextClick : Position
    , clickEnabled : Enabled

    -- Sequencer
    , routines : Array Routine.Routine
    , trackResizing : Maybe Int
    , routineResizing : Maybe Int
    }


type alias Flags =
    {}


type Playback
    = Playing
    | Paused
    | Stopped


type alias Position =
    Float


type Enabled
    = On
    | Off


type DragEvent
    = NoDrag
    | TempoDrag


type alias Tempo =
    { bpms : Float
    , bpm : Int
    , newBpm : Int
    }


type Msg
    = NoOp
      -- PLAYBACK
    | Play
    | Stop
    | SetTempo
    | ChangeTempo
      -- CONTROLS
    | ToggleClick
    | ToggleSync
      -- MOUSE EVENTS
    | MouseUp Mouse.Position
    | MouseMove Mouse.Position
      -- SUBMODULES
    | RoutineMsg Routine.Msg
      -- MAIN LOOP
    | Tick Float
