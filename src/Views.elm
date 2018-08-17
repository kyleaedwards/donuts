module Views exposing (renderHeader, renderControls, renderPlayback)

import Html exposing (Html, button, div, text, h3, span, i)
import Html.Events exposing (onClick, onMouseDown)
import Html.Attributes exposing (id, class)
import Types exposing (..)


renderHeader : Html Msg
renderHeader =
    div [ id "logo" ] []


renderSwitch : String -> String -> Enabled -> Msg -> Html Msg
renderSwitch label name active msg =
    let
        classes =
            if active == On then
                name ++ " control control-button switch fas active"
            else
                name ++ " control control-button switch fas"
    in
        div [ class classes, onClick msg ] []


renderControls : Model -> Html Msg
renderControls model =
    div [ id "click" ]
        [ renderSwitch "Click" "click" model.clickEnabled ToggleClick
        , renderSwitch "PO-X Sync" "po-sync" model.poSyncEnabled ToggleSync
        ]


renderPlayback : Model -> Html Msg
renderPlayback model =
    let
        className =
            case model.playback of
                Playing ->
                    "playing"

                Paused ->
                    "paused playing"

                Stopped ->
                    ""
    in
        div [ id "clock", class className ]
            [ getPositionIndicator model.position
            , div [ id "play", class "control control-button fas", onClick Play ] []
            , div [ id "stop", class "control control-button fas", onClick Stop ] []
            , getTempoControl model.tempo
            ]


getTempoControl : Tempo -> Html Msg
getTempoControl tempo =
    div [ id "tempo", class "control" ]
        [ span [ id "bpm", onMouseDown ChangeTempo ] [ text (toString tempo.newBpm) ]
        , i [] [ text "bpm" ]
        ]


getPositionIndicator : Position -> Html Msg
getPositionIndicator position =
    div [ class "position control" ]
        [ span [ id "measure", class "position-item" ] (positionToMeasure position)
        , span [ class "position-item" ] [ text (positionToBeat position) ]
        , span [ class "position-item" ] [ text (positionToDivision position) ]
        ]


positionToMeasure : Position -> List (Html Msg)
positionToMeasure position =
    let
        measure =
            (position / 4) + 1 |> floor |> toString

        strlen =
            String.length measure
    in
        if strlen > 2 then
            [ text measure ]
        else
            [ span [ class "position-padding" ] [ text (String.repeat (3 - strlen) "0") ]
            , text measure
            ]


positionToBeat : Position -> String
positionToBeat position =
    ((floor position) % 4) + 1 |> toString


positionToDivision : Position -> String
positionToDivision position =
    ((position - (toFloat (floor position))) * 4) + 1 |> floor |> toString
