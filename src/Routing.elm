module Routing exposing (..)

import Navigation
import Ships exposing (getRandomShips)
import Types exposing (..)
import UrlParser as Url

urlChange: Navigation.Location -> Model -> (Model, Cmd Msg)
urlChange location model =
    let
        mr = (Url.parsePath routes location)

        cmd =
            case mr of
                Just SetUp -> getRandomShips
                _ -> Cmd.none
    in
    ({model | route = mr}, cmd)

routes =
    Url.oneOf
        [ Url.map StartRoute (Url.s "")
        , Url.map SetUp (Url.s "setup")
        , Url.map ShareRoute (Url.s "share")
        , Url.map GameRoute (Url.s "game")
        ]

