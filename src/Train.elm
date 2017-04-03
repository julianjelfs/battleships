module Train exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Actions exposing (..)
import Battlefield

view : Model -> Html Msg
view model =
    div [ class "game" ]
        [ div
            [ class "header" ]
            [ h1
                [ class "title" ]
                [ text "Train the computer opponent" ]
            , span
                []
                [ button
                    [ class "turn"
                    ]
                    [ text "Start Training" ]
                ]
            ]
        , div
            [ class "play-area" ]
            [ div
                [ class "training"
                ]
                [ Battlefield.view model.gameState model.yourState ]
            ]
        ]
