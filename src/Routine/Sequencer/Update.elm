module Routine.Sequencer.Update exposing (updateSequencerIndex)

import Array exposing (Array)
import Ports
import Types exposing (..)
import Routine.Sequencer.Types exposing (..)
import Utils exposing (..)


getSequencerIndex : Position -> Int -> Int
getSequencerIndex position stepSize =
    floor (position * (toFloat stepSize))


updateTrackIndex : Int -> Track -> Track
updateTrackIndex sequencerIndex track =
    let
        index =
            sequencerIndex % track.steps
    in
        { track | currentIndex = index }


toggleStep : Step -> Step
toggleStep step =
    let
        enabled =
            if step.enabled == StepOn then
                StepOff
            else
                StepOn
    in
        { step | enabled = enabled }


updateSequencerIndex : Int -> Array Track -> Array Track
updateSequencerIndex sequencerIndex tracks =
    Array.map (updateTrackIndex sequencerIndex) tracks


getTrackEvent : Int -> Track -> List (Cmd msg) -> List (Cmd msg)
getTrackEvent sequenceIndex track cmds =
    let
        index =
            sequenceIndex % track.steps
    in
        case Array.get index track.sequence of
            Nothing ->
                cmds

            Just step ->
                if step.enabled == StepOn then
                    (Ports.triggerSample track.clip) :: cmds
                else
                    cmds


bundleSequencerEvents : Array Track -> Int -> Int -> List (Cmd msg)
bundleSequencerEvents tracks lastIndex index =
    -- filter tracks to get the sample names
    -- of current
    if lastIndex == index then
        []
    else
        Array.foldl (getTrackEvent index) [] tracks



-- updateProgramTracks : Int -> Int -> Routine -> Routine
-- updateProgramTracks trackIndex stepIndex program =
--     case program of
--         Sequencer.Sequencer sequencerInfo ->
--             Sequencer.Sequencer
--                 { sequencerInfo
--                     | tracks = updateTracks trackIndex stepIndex sequencerInfo.tracks
--                 }


updateTracks : Int -> Int -> Array Track -> Array Track
updateTracks trackIndex stepIndex tracks =
    let
        updateSequence sequence =
            setNestedArray stepIndex toggleStep sequence

        newTrack track =
            { track | sequence = (updateSequence track.sequence) }
    in
        setNestedArray trackIndex newTrack tracks
