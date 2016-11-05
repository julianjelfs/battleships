module Types exposing(..)

import Hop.Types exposing (Address, Config, Query)

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
    | GameRoute
    | NotFoundRoute

type alias Model =
    { address: Address
    , route: Route
    }

initialModel : Address -> Route -> Model
initialModel address route =
    Model address route
