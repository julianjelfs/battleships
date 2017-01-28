module Game exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Battlefield
import Ships exposing (coordsAndColor)


view : Model -> Html Msg
view model =
    let
        myShips =
            model.myState.ships
                |> List.concatMap coordsAndColor

        yourShips =
            model.yourState.ships
                |> List.concatMap coordsAndColor
    in
        div [ class "game" ]
            [ div
                [ class "header" ]
                [ h1
                    [ class "title" ]
                    [ text "Play the Game" ]
                , span
                    []
                    [ button
                        [ class "turn"
                        ]
                        [ text "Your Turn" ]
                    ]
                ]
            , div
                [ class "play-area" ]
                [ div
                    [ class "opponent" ]
                    [ Battlefield.view yourShips Opponent ]
                , div
                    [ class "me" ]
                    [ Battlefield.view myShips Me ]
                ]
            ]
