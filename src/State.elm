module State exposing(..)

import Types exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    (model, Cmd.none)
