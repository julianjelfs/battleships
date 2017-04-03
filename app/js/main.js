// IMPORT ASSETS
import '../css/App.scss'
import '../img/bomb.png'
import '../img/flag.png'
import reinforce from '../js/reinforce.js'

//import io from 'socket.io-client'
import Elm from '../../src/Main.elm'

Elm.Main.fullscreen();

const env = {
    getNumStates: function() {
        return 100;
    },
    getMaxNumActions: function() {
        return 100;
    },
};

const spec = {
    alpha: 0.01
};

//const agent = new reinforce.RL.DQNAgent(env, spec);
