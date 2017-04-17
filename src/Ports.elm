port module Ports exposing (..)

import Types exposing (TrainingState)

port requestMove : TrainingState -> Cmd msg

port startTraining : () -> Cmd msg

port receiveMove : ((Int, Int) -> msg) -> Sub msg

