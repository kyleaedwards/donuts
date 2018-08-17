module Routine.Update exposing (..)

updateRoutine : Msg -> Routine -> (Routine, Cmd Msg)
updateRoutine msg model =
    case msg of
        SequenceMsg subMsg ->
            let
                (updatedSequence, sequenceCmd) =
                    Sequence.update subMsg model
            in
                (updatedSequence, Cmd.map SequenceMsg sequenceCmd)