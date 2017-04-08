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

function calculateReward(action) {
    return 0;
}

function contains (coordList, coord) {
    let contains = false;
    for(let i=0; i<coordList.length; i++) {
        if(coordList[i][0] === coord[0] && coordList[i][1] === coord[1]){
            contains = true;
            break;
        }
    }
    return contains;
}

function mapState(state) {
    let coords = [];
    for(let x=1; x<=10; x++) {
        for (let y=1; y<=10; y++) {
            const c = [x,y];
            const hit = contains(state.hits, c);
            const miss = contains(state.misses, c);
            coords.push(hit ? 1 : miss ? -1 : 0);
        }
    }
    return coords;
}

function trainedMove(state) {
    currentState = mapState(state);
    const action = agent.act(currentState);
    const reward = calculateReward(action);
    agent.learn(reward);
    return randomMove();
}

let currentState = mapState({hits:[], misses:[]});

app.ports.requestMove.subscribe(state => {
    console.log(state);
    app.ports.receiveMove.send(trainedMove(state));
});

// This is our reward function
//  r(a;t0) = ∑t≥t0(h(t)–h(t))(0.5)t−t
// looks at action a taken at time t0 and returns a
// weighted sum of hit values h(t) for this and all
// future steps of the game

const env = {
    getNumStates: function() {
        return 100;
    },
    getMaxNumActions: function() {
        return 1;
    },
};

const spec = {
    alpha: 0.01
};


const agent = new reinforce.DQNAgent(env, spec);
