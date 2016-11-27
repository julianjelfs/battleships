module Ships exposing (getRandomShips)

import Time
import Random
import Task
import Random.Array as RA
import Random exposing (generate, Generator, Seed)
import Tuple
import Types exposing (..)

carrier =
    5


battleship =
    4


cruiser =
    3


submarine =
    3


destroyer =
    2


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


shipGenerator : Int -> Generator Ship
shipGenerator length =
    Random.map2
        (\d ( x, y ) ->
            List.range 0 (length - 1)
                |> List.map
                    (\n ->
                        case d of
                            Horizontal ->
                                ( x, (y + n), False )

                            Vertical ->
                                ( (x + n), y, False )
                    )
                |> Ship
        )
        direction
        point


randomShips : Random.Seed -> Ships
randomShips seed =
    allShips
        |> List.foldl
            (\s ( ships, sd ) ->
                let
                    ( ship, nextSeed ) =
                        Random.step (shipGenerator s) sd
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
