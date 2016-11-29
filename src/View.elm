module View exposing (..)

import Dict
import Game
import Html.Events exposing (onClick)
import Routing exposing (..)
import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Start
import SetUp



view : Model -> Html Msg
view model =
    div []
        [ menu model
        , pageView model
        ]


menu : Model -> Html Msg
menu model =
    div []
        [ div [ class "menu" ]
            [ button
                [ onClick (NavigateTo "home")
                ]
                [ text "Home" ]
            , button
                [ onClick (NavigateTo "setup")
                ]
                [ text "Setup" ]
            , button
                [ onClick (NavigateTo "game")
                ]
                [ text "Game" ]
            ]
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
