module Start exposing (view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Actions exposing (..)


view : Model -> Html Msg
view model =
    div [ class "start" ]
        [ h1
            [ class "title" ]
            [ text "Play Battleships" ]
        , div
            []
            [ button
                [ onClick (NavigateTo "setup")
                , class "one-player"
                ]
                [ text "One Player" ]
            , button
                [ onClick (NavigateTo "game")
                , title "This might come later"
                , class "two-player"
                , disabled True
                ]
                [ text "Two Players" ]
            ]
        ]
