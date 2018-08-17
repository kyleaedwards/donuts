module Routine.Views exposing (renderRoutines)

import Html exposing (Html, button, div, text, h3, span)
import Html.Attributes exposing (class, id)
import Types exposing (..)
import Array
import Routine.Sequencer.Views exposing (renderSequencer)


renderRoutines : Model -> Html Msg
renderRoutines model =
    div [ id "routines" ]
        (Array.toList <| Array.indexedMap (renderRoutine model) model.routines)


renderRoutine : Model -> Int -> Routine -> Html Msg
renderRoutine model index program =
    case program of
        Sequencer sequencerInfo ->
            renderSequencer index model
