module State exposing(..)

import Hop
import Random
import Types exposing (..)
import Debug exposing (log)
import Navigation
import Routing exposing (navigateTo, setQuery)
import Task
import Time

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (log "msg: " msg) of
        NavigateTo path ->
            let
                (m, c) =
                    navigateTo model path
            in
                (m, Cmd.batch [c, getRandomShips])

        SetQuery query ->
            setQuery model query

        PositionShips ships ->
            ({model | myShips = ships}, Cmd.none)

        None () ->
            (model, Cmd.none)

--this will generate a random arrangement of ships
--which we will have the chance to move around
--we need one of each type of ship and they need to be positioned so that
--they do not overlap
--orientation needs to be random too
randomShips : Random.Seed -> Ships
randomShips seed =
    --remove a ship from the set of remaining ships to place
    --generate a random position and orientation
    --test whether it overlaps with any we have already positioned
    --recurse
    []

getRandomShips =
    Time.now `Task.andThen`
        (\t ->
            round t
                |> Random.initialSeed
                |> randomShips
                |> Task.succeed )
                |> Task.perform None PositionShips
