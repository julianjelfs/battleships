module Main exposing(..)

import Hop.Types exposing (Address)
import Navigation
import Routing exposing (urlParser, urlUpdate)
import Types exposing (..)
import View exposing (..)
import State exposing (update)
import Html.App as Html

init : (Route, Address) -> ( Model, Cmd Msg )
init (route, address) =
  ( initialModel address route, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main: Program Never
main =
    Navigation.program urlParser
        { init = init
        , update = update
        , view = view
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }


