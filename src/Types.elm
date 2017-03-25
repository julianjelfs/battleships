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


type Commander
    = Me
    | Opponent

type Route
    = StartRoute
    | SetUpRoute
    | GameRoute

type alias PlayerState =
    { ships : Ships
    , hits : Set (Int, Int)
    , misses : Set (Int, Int)
    , commander : Commander
    }

type alias Model =
    { route : Maybe Route
    , mode : GameMode
    , myState : PlayerState
    , yourState : PlayerState
    }


initialModel : Model
initialModel =
    Model
        Nothing
        Alternate
        (PlayerState [] Set.empty Set.empty Me)
        (PlayerState [] Set.empty Set.empty Opponent)
