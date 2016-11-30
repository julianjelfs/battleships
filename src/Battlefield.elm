module Battlefield exposing (view)

import Char exposing (fromCode)
import Color
import Types exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String exposing (fromChar, toUpper)

headerCol c =
    th [] [ text c ]

cellCoveredByShip : ( Int, Int ) -> List ( Int, Int, Color.Color ) -> Maybe Color.Color
cellCoveredByShip ( x, y ) ships =
    let
        match =
            ships
                |> List.filter (\( x1, y1, _ ) -> x == x1 && y == y1)
                |> List.head
    in
        case match of
            Just ( _, _, c ) ->
                Just c

            _ ->
                Nothing


gridCol ships commander y x =
    let
        s =
            case cellCoveredByShip ( x, y ) ships of
                Nothing ->
                    []

                Just c ->
                    let
                        rgba =
                            Color.toRgb c

                        str =
                            "rgba("
                                ++ (toString rgba.red)
                                ++ ","
                                ++ (toString rgba.green)
                                ++ ","
                                ++ (toString rgba.blue)
                                ++ ","
                                ++ (toString (case commander of
                                    Opponent -> 0.05
                                    Me -> 1))
                                ++ ")"
                    in
                        [ ( "backgroundColor", str ) ]
    in
        td
            (case commander of
                Opponent ->
                    [ style s
                    , onClick (Attack (x, y))]
                Me ->
                    [ style s ])
            []


headerRow =
    let
        range =
            List.range 97 106 |> List.map (fromCode >> fromChar >> toUpper)
    in
        tr
            []
            (th [] [] :: (List.map headerCol range))


gridRow ships commander y =
    tr
        []
        (td
            [ class "row-index" ]
            [ text (toString y) ] :: List.map (gridCol ships commander y) (List.range 1 10))


grid : List ( Int, Int, Color.Color ) -> Commander -> Html Msg
grid ships commander =
    table
        []
        [ tbody
            []
            (headerRow :: (List.map (gridRow ships commander) (List.range 1 10)))
        ]


view : List (Int, Int, Color.Color) -> Commander -> Html Msg
view ships commander =
    div
        [ class "battlefield" ]
        [ grid ships commander
        ]
