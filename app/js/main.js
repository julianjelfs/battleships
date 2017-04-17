// IMPORT ASSETS
import '../css/App.scss'
import '../img/bomb.png'
import '../img/flag.png'
import reinforce from 'reinforcenode'

//import io from 'socket.io-client'
import Elm from '../../src/Main.elm'

const app = Elm.Main.fullscreen();

/*
Integrating this stuff with elm UI was a mistake and a waste of time.
Let's just store the agent in localStorage and use when we choose to training it
we'll just run 1000 games with no UI and then save to localStorage. Then when
playing 1 player we will just play against the agent.
 */

function train() {
    //make sure we have the agent (load from LocalStorage if necessary

    for(let i=0; i<1000; i++) {
        //generate a random position (via elm ports so we don't have to rewrite all that)
        //state { hits: [], misses : [], ships : [] }

        //while (hiddenShips) {
            //get action
            //update state (carry out action)
            //calculate reward
            //learn
        //
    }
}

function randomMove() {
    const x = Math.floor(Math.random() * 10) + 1;
    const y = Math.floor(Math.random() * 10) + 1;
    return [x,y];
}

function calculateReward(action) {
    return Math.random() * 100;
}

function indexToCoord(index) {
    const x = Math.floor (index / 10);
    const y = index % 10;
    return [x+1, y+1];
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
    const allVisited = state.hits.concat(state.misses);

    let visited = true,
        attack = null,
        action = null;

    do {
        action = agent.act(currentState);
        attack = indexToCoord(action);
        visited = contains(allVisited, attack);
    } while (visited);


    if(contains(state.ships, attack)) {
        agent.learn(100);
    } else {
        agent.learn(10);
    }
    return attack;
}

let currentState = mapState({hits:[], misses:[]});

app.ports.startTraining.subscribe(() => {
    console.log('starting training game');
});

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
        return 100;
    },
};

const spec = {
    alpha: 0.01
};


const agent = new reinforce.DQNAgent(env, spec);

/* to save agent use agent.toJSON() and agent.fromJSON() and localStorage */
