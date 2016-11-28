module Ships exposing (getRandomShips)

import Color
import Time
import Random
import Task
import Random.Array as RA
import Random exposing (generate, Generator, Seed)
import Tuple
import Types exposing (..)

carrier =
    (5, Color.red)


battleship =
    (4, Color.purple)


cruiser =
    (3, Color.yellow)


submarine =
    (3, Color.green)


destroyer =
    (2, Color.orange)


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


shipGenerator : (Int, Color.Color) -> Generator Ship
shipGenerator (length, color) =
    Random.map2
        (\d ( x, y ) ->
            List.range 0 (length - 1)
                |> List.map
                    (\n ->
                        case d of
                            Horizontal ->
                                ( x, (y + n), False, color )

                            Vertical ->
                                ( (x + n), y, False, color )
                    )
                |> Ship
        )
        direction
        point

inbounds: ShipCell -> Bool
inbounds (x, y, _, _) =
    x > 0 && x <= 10 && y > 0 && y <= 10

--seem to still be getting overlapping ships
doesntOverlap: List (Int, Int) -> ShipCell -> Bool
doesntOverlap others (x, y, _, _) =
    List.member (x, y) others |> not


validPosition: Ships -> Ship -> Bool
validPosition ships ship =
    let
        allPos =
            List.concatMap
                (\s -> (List.map (\(x, y, _, _) -> (x, y)) s.positions))
                    ships
    in
        List.all
            (\c -> inbounds c && doesntOverlap allPos c)
            ship.positions


getValidShip: (Int, Color.Color) -> Random.Seed -> Ships -> (Ship, Random.Seed)
getValidShip s seed ships =
    let
        ( ship, nextSeed ) =
            Random.step (shipGenerator s) seed
    in
        if validPosition ships ship then
            (ship, nextSeed)
        else
            getValidShip s nextSeed ships


randomShips : Random.Seed -> Ships
randomShips seed =
    allShips
        |> List.foldl
            (\s ( ships, sd ) ->
                let
                    ( ship, nextSeed ) =
                        getValidShip s sd ships
                in
                    ( ship :: ships, nextSeed )
            )
            ( [], seed )
        |> Tuple.first


getRandomShips =
    Time.now
        |> Task.andThen
            (\t ->
                round t
                    |> Random.initialSeed
                    |> randomShips
                    |> Task.succeed
            )
        |> Task.perform PositionShips
