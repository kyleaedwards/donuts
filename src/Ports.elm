port module Ports exposing (..)


port triggerClick : String -> Cmd msg


port triggerSample : String -> Cmd msg


port toggleSyncMode : Bool -> Cmd msg


port log : String -> Cmd msg
