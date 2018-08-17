module Utils exposing (..)

import Array exposing (Array)


-- Takes an index, a transform function, and an array and returns
-- a new array. Returns the initial array if an item does not
-- exist at the index.


setNestedArray : Int -> (a -> a) -> Array a -> Array a
setNestedArray index setFn array =
    case Array.get index array of
        Nothing ->
            array

        Just a ->
            Array.set index (setFn a) array



-- Takes an index, a sub-update, and an array and returns a new
-- array and a command message. Returns the initial array if an
-- item does not exist at the index.


nestedUpdate : Int -> (a -> ( a, Cmd msg )) -> Array a -> ( Array a, Cmd msg )
nestedUpdate index setFn array =
    case Array.get index array of
        Nothing ->
            ( array, Cmd.none )

        Just a ->
            let
                ( newArray, updateCmd ) =
                    setFn a
            in
                ( Array.set index newArray array, updateCmd )
