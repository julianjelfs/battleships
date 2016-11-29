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
                Just SetUpRoute ->
                    case model.myShips of
                        [] -> getRandomShips
                        _ -> Cmd.none
                Just StartRoute -> Cmd.none
                Just GameRoute ->
                    case model.myShips of
                        [] ->
                            Navigation.newUrl "home"
                        _ -> Cmd.none
                _ -> Cmd.none
    in
        ({model | route = mr}, cmd)

routes =
    Url.oneOf
        [ Url.map StartRoute (Url.s "")
        , Url.map StartRoute (Url.s "home")
        , Url.map SetUpRoute (Url.s "setup")
        , Url.map GameRoute (Url.s "game")
        ]

