module Types exposing(..)

import Hop.Types exposing (Address, Config, Query)

type GameMode =
    Alternate
    | SwitchOnMiss

type Msg =
    NavigateTo String
    | SetQuery Query
    | None

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
    }

initialModel : Address -> Route -> Model
initialModel address route =
    Model address route Alternate
