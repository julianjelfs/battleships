module Types exposing (..)

import Navigation
import Set exposing (Set)
import UrlParser as Url


type alias Coord =
    ( Int, Int, Bool )


type alias Ship =
    { positions : List Coord
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
    | None ()

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
