module State exposing(..)

import Array exposing (Array)
import Hop
import Random exposing (Generator, Seed)
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
            ({model | myShips = ships |> (log "ship: ") }, Cmd.none)

        None () ->
            (model, Cmd.none)

carrier = 5
battleship = 4
cruiser = 3
submarine = 3
destroyer = 2

allShips = [carrier, battleship, cruiser, submarine, destroyer]

type Direction =
    Horizontal
    | Vertical

direction: Generator Direction
direction =
    Random.bool
        |> Random.map
            (\b -> if b then Horizontal else Vertical)

point: Generator (Int, Int)
point =
    Random.pair
        (Random.int 0 10)
        (Random.int 0 10)

shipGenerator: Int -> Generator Ship
shipGenerator length =
    Random.map2
        (\d (x,y) ->
            [0..length-1]
                |> List.map
                    (\n ->
                        case d of
                            Horizontal -> (x, (y+n), False)
                            Vertical -> ((x+n), y, False))
                |> Ship )
        direction point

randomShips : Random.Seed -> Ships
randomShips seed =
    allShips
        |> List.foldl
            (\s (ships, sd) ->
                let
                    (ship, nextSeed) =
                        Random.step (shipGenerator s) sd
                in
                    (ship :: ships, nextSeed))
                ([], seed)
        |> fst

getRandomShips =
    Time.now `Task.andThen`
        (\t ->
            round t
                |> Random.initialSeed
                |> randomShips
                |> Task.succeed )
                |> Task.perform None PositionShips
