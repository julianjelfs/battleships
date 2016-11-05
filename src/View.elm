module View exposing(..)

import Dict
import Html.Events exposing (onClick)
import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (map)
import Start

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
                [ onClick (NavigateTo "share")
                ]
                [ text "Share" ]
            , button
                [ onClick (NavigateTo "game")
                ]
                [ text "Game" ]
            ]
        ]

pageView : Model -> Html Msg
pageView model =
    case model.route of
        StartRoute ->
            Start.view model

        ShareRoute ->
            div [] [ h2 [ class "title" ] [ text "Share" ] ]

        GameRoute ->
            div [] [ h2 [ class "title" ] [ text "Play Game" ] ]

        NotFoundRoute ->
            div [] [ h2 [ class "title" ] [ text "Not found" ] ]
