module Actions exposing (..)

import Navigation
import Player.Actions as Player

type Msg
    = UrlChange Navigation.Location
    | NavigateTo String
    | Shuffle
    | Attack (Int, Int)
    | PlayerMsg Player.Msg
