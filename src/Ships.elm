module Ships exposing (getBothBattlefields, coordsAndColor)

import Color
import Time
import Random
import Task
import Random.Array as RA
import Random exposing (generate, Generator, Seed)
import Tuple
import Types exposing (..)
import Actions exposing (..)
import Player.Actions exposing (..)


carrier =
    ( 5, Color.red )


battleship =
    ( 4, Color.purple )


cruiser =
    ( 3, Color.yellow )


submarine =
    ( 3, Color.green )


destroyer =
    ( 2, Color.orange )


allShips =
    [ carrier, battleship, cruiser, submarine, destroyer ]


direction : Generator Direction
direction =
    Random.bool
        |> Random.map
            (\b ->
                if b then
                    Horizontal
                else
                    Vertical
            )


point : Generator ( Int, Int )
point =
    Random.pair
        (Random.int 0 10)
        (Random.int 0 10)


shipGenerator : Int -> Generator (List Coord)
shipGenerator length =
    Random.map2
        (\d ( x, y ) ->
            List.range 0 (length - 1)
                |> List.map
                    (\n ->
                        case d of
                            Horizontal ->
                                ( x, (y + n))

                            Vertical ->
                                ( (x + n), y)
                    )
        )
        direction
        point


inbounds : Coord -> Bool
inbounds ( x, y ) =
    x > 0 && x <= 10 && y > 0 && y <= 10


doesntOverlap : List Coord -> Coord -> Bool
doesntOverlap others coord =
    List.member coord others |> not


validPosition : List Ship -> List Coord -> Bool
validPosition ships coords =
    let
        allPos =
            List.concatMap .positions ships
    in
        List.all
            (\c -> inbounds c && doesntOverlap allPos c)
            coords


getValidShip : Int -> Random.Seed -> List Ship -> ( List Coord, Random.Seed )
getValidShip n seed ships =
    let
        ( shipCells, nextSeed ) =
            Random.step (shipGenerator n) seed
    in
        if validPosition ships shipCells then
            ( shipCells, nextSeed )
        else
            getValidShip n nextSeed ships


randomShips : Random.Seed -> List Ship
randomShips seed =
    allShips
        |> List.foldl
            (\( n, c ) ( ships, sd ) ->
                let
                    ( positions, nextSeed ) =
                        getValidShip n sd ships
                in
                    ( Ship positions c :: ships, nextSeed )
            )
            ( [], seed )
        |> Tuple.first

getBothBattlefields =
    Cmd.batch
        [ Cmd.map PlayerMsg (getRandomShips Me 0)
        , Cmd.map PlayerMsg (getRandomShips Opponent 1000) ]

getRandomShips cmdr offset =
    Time.now
        |> Task.andThen
            (\t ->
                (round t) + offset
                    |> Random.initialSeed
                    |> randomShips
                    |> Task.succeed
            )
        |> Task.map (\s -> (cmdr, s))
        |> Task.perform PositionShips

coordsAndColor: Ship -> List (Int, Int, Color.Color)
coordsAndColor ship =
    List.map (\( x, y ) -> ( x, y, ship.color )) ship.positions
