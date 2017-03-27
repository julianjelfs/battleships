module Main exposing (..)

import Navigation
import Routing exposing (urlChange)
import Types exposing (..)
import Actions exposing (..)
import View exposing (..)
import State exposing (update)
import Time exposing (every, second)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    urlChange location initialModel


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.gameState of
        Playing Opponent ->
            every second Think
        _ -> Sub.none


main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

