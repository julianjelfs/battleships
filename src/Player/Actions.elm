module Player.Actions exposing (..)

import Types exposing (Commander, Ships)

type Msg =
    PositionShips (Commander, Ships)
