module Types exposing (..)

import Color exposing (Color)
import Navigation
import Set exposing (Set)
import UrlParser as Url


type alias Coord =
    ( Int, Int )

--much better structure for ships would be Dict (Int, Int) (Bool, Color)
--refactor next time


type alias Ship =
    { positions : List Coord
    , color: Color
    }

type Direction
    = Horizontal
    | Vertical

type GameMode
    = Alternate
    | SwitchOnMiss


type Commander
    = Me
    | Opponent
    | Trainee

type GameState =
    NotStarted
    | Playing Commander
    | Finished Commander
    | Training


type Route
    = StartRoute
    | SetUpRoute
    | GameRoute
    | TrainRoute

type alias PlayerState =
    { ships : List Ship
    , hits : Set (Int, Int)
    , misses : Set (Int, Int)
    , commander : Commander
    }

type alias Model =
    { route : Maybe Route
    , mode : GameMode
    , myState : PlayerState
    , yourState : PlayerState
    , trainingState : PlayerState
    , gameState : GameState
    , thinking : Int
    }


initialModel : Model
initialModel =
    Model
        Nothing
        Alternate
        (PlayerState [] Set.empty Set.empty Me)
        (PlayerState [] Set.empty Set.empty Opponent)
        (PlayerState [] Set.empty Set.empty Trainee)
        NotStarted
        5
