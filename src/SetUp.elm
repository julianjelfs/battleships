module SetUp exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Battlefield
import Ships exposing (coordsAndColor)

view : Model -> Html Msg
view model =
    let
        ships =
            model.myShips
                |> List.concatMap coordsAndColor
    in
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
                        , onClick (NavigateTo "game")
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
            , Battlefield.view ships
            ]
