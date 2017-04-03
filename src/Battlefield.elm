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


gridCol gameState playerState ships y x =
    let
        hit = Set.member (x, y) playerState.hits

        miss = Set.member (x, y) playerState.misses

        s =
            case playerState.commander of
                Opponent -> []
                _ ->
                    case cellCoveredByShip ( x, y ) ships of
                        Nothing ->
                            [ ]

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
                                        ++ ",1)"
                            in
                                [ ( "backgroundColor", str ) ]
        attrs =
            [ style s
            , classList [("hit", hit), ("miss", miss)]
            ]
    in
        td
            (case playerState.commander of
                Opponent ->
                    case gameState of
                        Playing Me ->
                            List.append attrs
                            [ onClick (Attack Me (x, y))]
                        _ -> attrs
                _ ->
                    attrs)
            []


headerRow =
    let
        range =
            List.range 97 106 |> List.map (fromCode >> fromChar >> toUpper)
    in
        tr
            []
            (th [] [] :: (List.map headerCol range))


gridRow gameState playerState ships y =
    tr
        []
        (td
            [ class "row-index" ]
            [ text (toString y) ] :: List.map (gridCol gameState playerState ships y) (List.range 1 10))


grid : GameState -> PlayerState -> List ( Int, Int, Color.Color ) -> Html Msg
grid gameState playerState ships =
    table
        []
        [ tbody
            []
            (headerRow :: (List.map (gridRow gameState playerState ships) (List.range 1 10)))
        ]


view : GameState -> PlayerState -> Html Msg
view gameState playerState =
    let
        ships = playerState.ships
            |> List.concatMap coordsAndColor
    in
    div
        [ class "battlefield" ]
        [ grid gameState playerState ships
        ]
