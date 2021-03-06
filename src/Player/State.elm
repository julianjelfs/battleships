module Player.State exposing (update)

import Player.Actions exposing (..)
import Types exposing (Commander, PlayerState)

update : Msg -> PlayerState -> PlayerState
update msg model =
    case msg of
        PositionShips (c, s) ->
            if c == model.commander then
                { model | ships = s }
            else
                model
