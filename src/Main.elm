module Main exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class, id)
import Types exposing (..)
import Update exposing (update)
import Subscriptions exposing (subscriptions)
import Views exposing (renderHeader, renderPlayback, renderControls)
import Array exposing (Array)


initialTempo : Tempo
initialTempo =
    { bpm = 120
    , newBpm = 120
    , bpms = 120.0 / 60000
    }


initialModel : Model
initialModel =
    { dragEvent = NoDrag
    , mouseX = Nothing
    , tempo = initialTempo
    , position = 0.0
    , lastPosition = 0.0
    , swing = 0.5
    , playback = Stopped
    , isClicking = False
    , ppqn = 2
    , nextClick = 0.0
    , poSyncEnabled = Off
    , clickEnabled = Off
    , routines = Array.empty
    , routineResizing = Nothing
    , trackResizing = Nothing
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    div [ id "mount" ]
        [ div [ id "topbar" ]
            [ renderHeader
            , renderPlayback model
            , renderControls model
            ]
        , div [ class "main" ] []
        ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
