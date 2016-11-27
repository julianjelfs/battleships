module SetUp exposing (view)

import Char exposing (fromCode)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String exposing (fromChar, toUpper)
import Types exposing (..)


headerCol c =
    th [] [ text c ]


cellCoveredByShip coord ships =
    ships
        |> List.foldl
            (\s covered ->
                covered || List.member coord s.positions
            )
            False


gridCol ships y x =
    let
        cls =
            case cellCoveredByShip ( x, y, False ) ships of
                True ->
                    "covered"

                False ->
                    ""
    in
        td [ class cls ] []


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


grid : Ships -> Html Msg
grid ships =
    table
        []
        [ tbody
            []
            (headerRow :: (List.map (gridRow ships) (List.range 1 10)))
        ]


view : Model -> Html Msg
view model =
    div [ class "stage" ]
        [ h1
            [ class "title" ]
            [ text "Place your ships" ]
        , div
            [ class "setup" ]
            [ div
                [ class "battlefield" ]
                [ grid model.myShips ]
            , div
                [ class "choose-ships" ]
                []
            ]
        ]
