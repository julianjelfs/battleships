module State exposing(..)

import Array exposing (Array)
import Hop
import Random exposing (Seed)
import Types exposing (..)
import Debug exposing (log)
import Navigation
import Routing exposing (navigateTo, setQuery)
import Task
import Time
import Set
import Random exposing (generate)
import Random.Array as RA

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (log "msg: " msg) of
        NavigateTo path ->
            let
                (m, c) =
                    navigateTo model path

                cmds =
                    case path of
                        "setup" -> Cmd.batch [c, getRandomShips]
                        _ -> c
            in
                (m, cmds)

        SetQuery query ->
            setQuery model query

        PositionShips ships ->
            ({model | myShips = ships}, Cmd.none)

        None () ->
            (model, Cmd.none)

type ShipType =
    None
    | Carrier
    | Battleship
    | Cruiser
    | Submarine
    | Destroyer

carrier = 5
battleship = 4
cruiser = 3
submarine = 3
destroyer = 2

allShips = [Carrier, Battleship, Cruiser, Submarine, Destroyer]

getAShip: Array ShipType -> Seed -> (ShipType, Seed, Array ShipType)
getAShip ships seed =
    let
        ((ms, rs), s1) = Random.step (RA.choose ships) seed
    in
        ( Maybe.withDefault None ms
        , s1
        , rs )

--this will generate a random arrangement of ships
--which we will have the chance to move around
--we need one of each type of ship and they need to be positioned so that
--they do not overlap
--orientation needs to be random too
randomShips : Array ShipType -> Random.Seed -> Ships
randomShips ships seed =
    let
        (shipType, s1, ships) = getAShip ships seed
    in
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
                |> (randomShips allShips)
                |> Task.succeed )
                |> Task.perform None PositionShips
