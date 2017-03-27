module Game exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Actions exposing (..)
import Battlefield
import Ships exposing (coordsAndColor)

turnText : GameState -> String
turnText gameState =
    case gameState of
        Playing Me -> "Your Turn"
        Playing Opponent -> "Opponent Thinking ..."
        _ -> "Whoops"

view : Model -> Html Msg
view model =
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
                    [ text <| turnText model.gameState ]
                ]
            ]
        , div
            [ class "play-area" ]
            [ div
                [ class "opponent"
                , classList [("my-turn", model.gameState == Playing Me)]
                ]
                [ Battlefield.view model.gameState model.yourState ]
            , div
                [ class "me" ]
                [ Battlefield.view model.gameState model.myState ]
            ]
        ]
