module View exposing (..)

import Dict
import Game
import Html.Events exposing (onClick)
import Routing exposing (..)
import Types exposing (..)
import Actions exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Start
import SetUp



view : Model -> Html Msg
view model =
    div []
        [ pageView model
        ]


pageView : Model -> Html Msg
pageView model =
    case model.route of
        Just StartRoute ->
            Start.view model

        Just SetUpRoute ->
            SetUp.view model

        Just GameRoute ->
            Game.view model

        _ ->
            div [] [ h2 [ class "title" ] [ text "Not found" ] ]
