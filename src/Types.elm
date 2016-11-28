module Types exposing (..)

import Color exposing (Color)
import Navigation
import Set exposing (Set)
import UrlParser as Url


type alias ShipCell =
    ( Int, Int, Bool )

--much better structure for ships would be Dict (Int, Int) (Bool, Color)
--refactor next time

type alias Ship =
    { positions : List ShipCell
    , color: Color
    }


type alias Ships =
    List Ship


type Direction
    = Horizontal
    | Vertical

type GameMode
    = Alternate
    | SwitchOnMiss


type Msg
    = PositionShips Ships
    | UrlChange Navigation.Location
    | NavigateTo String
    | Shuffle

type Route
    = StartRoute
    | ShareRoute
    | SetUp
    | GameRoute

type alias Model =
    { route : Maybe Route
    , mode : GameMode
    , myShips : Ships
    }


initialModel : Model
initialModel =
    Model Nothing Alternate []
