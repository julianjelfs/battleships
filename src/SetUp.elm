module SetUp exposing (view)

import Char exposing (fromCode)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String exposing (fromChar, toUpper)
import Types exposing (..)

headerCol c =
    th [] [text c]

gridCol n =
    td [] []

headerRow =
    let
        range = [97..106] |> List.map (fromCode >> fromChar >> toUpper)
    in
        tr
            []
            (th [][] :: (List.map headerCol range))

gridRow n =
    tr
        []
        (td [] [text (toString n)] :: List.map gridCol [1..10])

grid : Html Msg
grid =
    table
        []
        [ tbody
            []
            (headerRow :: (List.map gridRow [1..10]))
        ]

view: Model -> Html Msg
view model =
    div [ class "stage" ]
        [ h1
            [ class "title" ]
            [ text "Place your ships" ]
        , div
            [ class "setup" ]
            [ div
                [ class "battlefield" ]
                [ grid ]
            , div
                [ class "choose-ships" ]
                []
            ]
        ]
