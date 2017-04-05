// IMPORT ASSETS
import '../css/App.scss'
import '../img/bomb.png'
import '../img/flag.png'
import reinforce from 'reinforcenode'

//import io from 'socket.io-client'
import Elm from '../../src/Main.elm'

const app = Elm.Main.fullscreen();

function randomMove() {
    const x = Math.floor(Math.random() * 10) + 1;
    const y = Math.floor(Math.random() * 10) + 1;
    return [x,y];
}

app.ports.requestMove.subscribe(state => {
    console.log(state);
    app.ports.receiveMove.send(randomMove());
});

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


const agent = new reinforce.DQNAgent(env, spec);
