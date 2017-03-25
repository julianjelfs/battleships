module Player.Actions exposing (..)

import Types exposing (Commander, Ship)

type Msg =
    PositionShips (Commander, List Ship)
