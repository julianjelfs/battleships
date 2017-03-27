module SetUp exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Actions exposing (..)
import Battlefield
import Ships exposing (coordsAndColor)

view : Model -> Html Msg
view model =
    div [ class "setup" ]
        [ div
            [ class "header" ]
            [ h1
                [ class "title" ]
                [ text "Shuffle your ships until happy" ]
            , span
                []
                [ button
                    [ class "play"
                    , onClick StartGame
                    ]
                    [ text "Play" ]
                ]
            , span
                []
                [ button
                    [ class "shuffle"
                    , onClick Shuffle
                    ]
                    [ text "Shuffle" ]
                ]
            ]
        , Battlefield.view model.gameState model.myState
        ]
