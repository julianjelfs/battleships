module Main exposing (..)

import Navigation
import Routing exposing (urlChange)
import Types exposing (..)
import View exposing (..)
import State exposing (update)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    urlChange location initialModel


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

