module Types exposing(..)

type Msg =
    None

type alias Model =
    { test: String
    }

initialModel : Model
initialModel =
    Model "Battleships"
