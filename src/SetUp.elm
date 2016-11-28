module SetUp exposing (view)

import Char exposing (fromCode)
import Color
import Debug exposing (log)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String exposing (fromChar, toUpper)
import Types exposing (..)


headerCol c =
    th [] [ text c ]

coordsAndColor ship =
    List.map (\(x, y, _) -> (x, y, ship.color)) ship.positions

cellCoveredByShip: (Int, Int) -> List (Int, Int, Color.Color) -> Maybe Color.Color
cellCoveredByShip (x, y) ships =
    let
        match = ships
            |> List.filter (\(x1, y1, _) -> x == x1 && y == y1)
            |> List.head
    in
        case match of
            Just (_, _, c) -> Just c
            _ -> Nothing

gridCol ships y x =
    let
        s =
            case cellCoveredByShip (x, y) ships of
                Nothing -> []
                Just c ->
                    let
                        rgba = Color.toRgb c
                        str = "rgb("
                            ++ (toString rgba.red)
                            ++ "," ++ (toString rgba.green)
                            ++ "," ++ (toString rgba.blue)
                            ++ ")"
                    in
                        [ ("backgroundColor", str) ]
    in
        td
            [ style s ]
            []


headerRow =
    let
        range =
            List.range 97 106 |> List.map (fromCode >> fromChar >> toUpper)
    in
        tr
            []
            (th [] [] :: (List.map headerCol range))


gridRow ships y =
    tr
        []
        (td [] [ text (toString y) ] :: List.map (gridCol ships y) (List.range 1 10))


grid : List (Int, Int, Color.Color) -> Html Msg
grid ships =
    table
        []
        [ tbody
            []
            (headerRow :: (List.map (gridRow ships) (List.range 1 10)))
        ]


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
                    [ text "Place your ships" ]
                , span
                    []
                    [ button
                        [ class "shuffle"
                        , onClick Shuffle ]
                        [ text "Shuffle" ]
                    ]
                ]
            , div
                [ class "battlefield" ]
                [ grid ships
                ]
            ]
