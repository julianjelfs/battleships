module Types exposing(..)

import Hop.Types exposing (Address, Config, Query)

type alias Coord =
    { x: Int
    , y: Int
    , hit: Bool
    }

type alias Ship =
    { positions: List Coord
    }

type alias Ships = List Ship

type GameMode =
    Alternate
    | SwitchOnMiss

type Msg =
    NavigateTo String
    | SetQuery Query
    | PositionShips Ships
    | None ()

hopConfig : Config
hopConfig =
    { hash = False
    , basePath = ""
    }

type Route
    = StartRoute
    | ShareRoute
    | SetUp
    | GameRoute
    | NotFoundRoute

type alias Model =
    { address: Address
    , route: Route
    , mode : GameMode
    , myShips : Ships
    }

initialModel : Address -> Route -> Model
initialModel address route =
    Model address route Alternate []
