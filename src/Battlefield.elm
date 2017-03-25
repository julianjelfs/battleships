module Battlefield exposing (view)

import Char exposing (fromCode)
import Color
import Ships exposing (coordsAndColor)
import Types exposing (..)
import Actions exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String exposing (fromChar, toUpper)
import Set

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


gridCol state ships y x =
    let
        hit = Set.member (x, y) state.hits

        miss = Set.member (x, y) state.misses

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
                                ++ (toString (case state.commander of
                                    Opponent -> 0.05
                                    Me -> 1))
                                ++ ")"
                    in
                        [ ( "backgroundColor", str ) ]
    in
        td
            (case state.commander of
                Opponent ->
                    [ style s
                    , classList [("hit", hit), ("miss", miss)]
                    , onClick (Attack Me (x, y))]
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


gridRow state ships y =
    tr
        []
        (td
            [ class "row-index" ]
            [ text (toString y) ] :: List.map (gridCol state ships y) (List.range 1 10))


grid : PlayerState -> List ( Int, Int, Color.Color ) -> Html Msg
grid state ships =
    table
        []
        [ tbody
            []
            (headerRow :: (List.map (gridRow state ships) (List.range 1 10)))
        ]


view : PlayerState -> Html Msg
view state =
    let
        ships = state.ships
            |> List.concatMap coordsAndColor
    in
    div
        [ class "battlefield" ]
        [ grid state ships
        ]
