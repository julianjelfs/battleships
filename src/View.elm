module View exposing(..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (map)

root : Model -> Html Msg
root model =
    h1
        []
        [ text "Battleships" ]
