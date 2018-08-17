module Update exposing (update)

import Ports
import Types exposing (..)


getNextClick : Int -> Position -> Position
getNextClick ppqn position =
    let
        fPpqn =
            toFloat ppqn
    in
        (position * fPpqn |> ceiling |> toFloat) / fPpqn


getPendingEvents : Model -> Int -> Position -> List (Cmd msg)
getPendingEvents model sequencerIndex position =
    let
        events =
            []
    in
        bundleClickEvent model.clickEnabled position model.nextClick events


bundleClickEvent : Enabled -> Position -> Position -> List (Cmd msg) -> List (Cmd msg)
bundleClickEvent clickEnabled position nextClick cmds =
    if clickEnabled == On && nextClick <= position then
        Ports.triggerClick "click" :: cmds
    else
        cmds


updateTempoMousePosition : Int -> Tempo -> Tempo
updateTempoMousePosition deltaX tempo =
    { tempo
        | newBpm = clamp 60 300 (tempo.bpm + deltaX)
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        -- PLAYBACK
        Play ->
            let
                playback =
                    if model.playback == Playing then
                        Paused
                    else
                        Playing
            in
                ( { model | playback = playback }
                , Cmd.none
                )

        Stop ->
            ( { model
                | playback = Stopped
                , position = 0.0
                , lastPosition = 0.0
                , nextClick = 0.0
              }
            , Cmd.none
            )

        SetTempo ->
            let
                tempo =
                    model.tempo

                newTempo =
                    { tempo
                        | bpms = ((toFloat tempo.newBpm) / 60000.0)
                    }
            in
                ( { model | tempo = newTempo }
                , Cmd.none
                )

        ChangeTempo ->
            ( { model | dragEvent = TempoDrag }
            , Cmd.none
            )

        -- CONTROLS
        ToggleClick ->
            let
                clickEnabled =
                    if model.clickEnabled == On then
                        Off
                    else
                        On
            in
                ( { model | clickEnabled = clickEnabled }, Cmd.none )

        ToggleSync ->
            let
                poSyncEnabled =
                    if model.poSyncEnabled == On then
                        Off
                    else
                        On
            in
                ( { model | poSyncEnabled = poSyncEnabled }, Ports.toggleSyncMode (poSyncEnabled == On) )

        -- MOUSE EVENTS
        MouseMove position ->
            let
                tempo =
                    model.tempo
            in
                case model.mouseX of
                    Nothing ->
                        if model.dragEvent == NoDrag then
                            ( model
                            , Cmd.none
                            )
                        else
                            ( { model | mouseX = Just position.x }
                            , Cmd.none
                            )

                    Just x ->
                        case model.dragEvent of
                            TempoDrag ->
                                ( { model
                                    | tempo = updateTempoMousePosition (position.x - x) tempo
                                  }
                                , Cmd.none
                                )

                            NoDrag ->
                                ( model
                                , Cmd.none
                                )

        MouseUp position ->
            let
                tempo =
                    model.tempo

                newTempo =
                    { tempo
                        | bpm = tempo.newBpm
                        , bpms = (toFloat tempo.newBpm) / 60000.0
                    }
            in
                case model.dragEvent of
                    TempoDrag ->
                        ( { model | tempo = newTempo, mouseX = Nothing, dragEvent = NoDrag }
                        , Cmd.none
                        )

                    NoDrag ->
                        ( model
                        , Cmd.none
                        )

        -- SUBMODULES
        RoutineMsg subMsg ->
            ( model, Cmd.none )

        -- MAIN LOOP
        Tick delta ->
            let
                lastPosition =
                    model.position

                position =
                    model.position + delta * model.tempo.bpms

                pendingEvents =
                    getPendingEvents model 0 position
            in
                if model.playback == Playing then
                    ( { model
                        | position = position
                        , lastPosition = lastPosition
                        , nextClick = getNextClick model.ppqn position
                      }
                    , Cmd.batch pendingEvents
                    )
                else
                    ( model
                    , Cmd.none
                    )
