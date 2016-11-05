module SetUp exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Types exposing (..)

view: Model -> Html Msg
view model =
    div [ class "stage" ]
        [ h1
            [ class "title" ]
            [ text "Place your ships" ]
        , div
            []
            []
        ]
