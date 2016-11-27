module Types exposing (..)

import Navigation
import Routing exposing (..)
import Set exposing (Set)
import UrlParser as Url


type alias Coord =
    ( Int, Int, Bool )


type alias Ship =
    { positions : List Coord
    }


type alias Ships =
    List Ship


type GameMode
    = Alternate
    | SwitchOnMiss


type Msg
    = PositionShips Ships
    | UrlChange Navigation.Location
    | NavigateTo String
    | None ()


type alias Model =
    { route : Maybe Route
    , mode : GameMode
    , myShips : Ships
    }


initialModel : Navigation.Location -> Model
initialModel location =
    Model (Url.parsePath Routing.routes location) Alternate []
