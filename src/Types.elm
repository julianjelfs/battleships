module Types exposing (..)

import Color exposing (Color)
import Navigation
import Set exposing (Set)
import UrlParser as Url
import Player.Types


type alias ShipCell =
    ( Int, Int, Bool )

--much better structure for ships would be Dict (Int, Int) (Bool, Color)
--refactor next time


--we have a circular ref here. This always happens. I think a better structure might be to split Models and Actions

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
    = UrlChange Navigation.Location
    | NavigateTo String
    | Shuffle
    | Attack (Int, Int)
    | PlayerMsg Player.Types.Msg

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
