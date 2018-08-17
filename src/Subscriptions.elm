module Subscriptions exposing (subscriptions)

import Mouse
import AnimationFrame
import Types exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Tick
        , Mouse.ups MouseUp
        , Mouse.moves MouseMove
        ]
