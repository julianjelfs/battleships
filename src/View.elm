module View exposing (..)

import Dict
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
                [ onClick (NavigateTo "")
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

        Just SetUp ->
            SetUp.view model

        Just ShareRoute ->
            div [] [ h2 [ class "title" ] [ text "Share" ] ]

        Just GameRoute ->
            div [] [ h2 [ class "title" ] [ text "Play Game" ] ]

        _ ->
            div [] [ h2 [ class "title" ] [ text "Not found" ] ]
