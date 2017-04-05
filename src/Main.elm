module Main exposing (..)

import Navigation
import Routing exposing (urlChange)
import Types exposing (..)
import Actions exposing (..)
import View exposing (..)
import State exposing (update)
import Time exposing (every, millisecond, second)
import Ports exposing (receiveMove)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    urlChange location initialModel


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveMove (Attack Trainee)
        , case model.gameState of
            Playing Opponent ->
                every second Think
            Training ->
                every (millisecond * 10) Train
            _ -> Sub.none
        ]



main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

