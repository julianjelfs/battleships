module Main exposing(..)

import Types exposing (..)
import View exposing (root)
import State exposing (update)
import Html.App as Html

init : ( Model, Cmd Msg )
init =
  ( initialModel, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main =
    Html.program
        { init = init
        , update = update
        , view = root
        , subscriptions = subscriptions
        }
