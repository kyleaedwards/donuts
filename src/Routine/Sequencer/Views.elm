module Routine.Sequencer.Views exposing (renderSequencer)

import Html exposing (Html, button, div, text, h3, span)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onMouseDown)
import Types exposing (..)
import Array exposing (Array)


renderSequencer : Int -> Model -> Html Msg
renderSequencer routineIndex model =
    div [ class "sequencer" ]
        [ div
            [ class "sequencer-tracks" ]
            (Array.toList <| Array.indexedMap (renderTrack model.playback routineIndex) model.tracks)
        ]


renderStep : Playback -> Int -> Int -> Int -> Int -> Enabled -> Html Msg
renderStep playback routineIndex trackIndex currentIndex index step =
    let
        classes =
            if step == On then
                if currentIndex == index && playback /= Stopped then
                    "step active playing"
                else
                    "step active"
            else if currentIndex == index && playback /= Stopped then
                "step playing"
            else
                "step"
    in
        button [ class classes, onClick (ToggleStep routineIndex trackIndex index) ] []


renderSequence : Playback -> Int -> Int -> Int -> Array Enabled -> List (Html Msg)
renderSequence playback routineIndex trackIndex currentIndex sequence =
    Array.toList <| Array.indexedMap (renderStep playback routineIndex trackIndex currentIndex) sequence


renderTrack : Playback -> Int -> Int -> Track -> Html Msg
renderTrack playback routineIndex trackIndex track =
    div [ class "track" ]
        [ h3 [] [ text track.name ]
        , div
            [ class "track-steps" ]
            (List.concat
                [ (renderSequence playback programIndex trackIndex track.currentIndex (Array.slice 0 track.steps track.sequence))
                , [ div [ class "track-handle", onMouseDown (ResizeTrack routineIndex trackIndex) ]
                        [ span [ class "track-handle-inner" ] []
                        ]
                  ]
                ]
            )
        ]
