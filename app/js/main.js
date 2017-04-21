// IMPORT ASSETS
import '../css/App.scss'
import '../img/bomb.png'
import '../img/flag.png'
import reinforce from 'reinforcenode'

//import io from 'socket.io-client'
import Elm from '../../src/Main.elm'

const app = Elm.Main.fullscreen();

let iteration = 0;

app.ports.sendInitialState.subscribe(ships => {
    iteration += 1;

    console.log(`Playing game with ships: ${ships}`);

    let state = {
        ships : ships,
        hits : [],
        misses : []
    };
    let hitlog = [];

    do {
        const s = mapState(state);
        const allVisited = state.hits.concat(state.misses);

        let visited = true,
            attack = null,
            action = null;

        do {
            action = agent.act(s);
            attack = indexToCoord(action);
            visited = contains(allVisited, attack);
        } while (visited);

        if(contains(state.ships, attack)) {
            state.hits.push(attack);
            hitlog.push(1);
        } else {
            state.misses.push(attack);
            hitlog.push(0);
        }
        agent.learn(calculateReward(hitlog, 0.5));
    } while (state.hits.length < 17);

    console.log(`Game ${iteration} completed with ${state.misses.length} misses`);

    //store the training so far
    localStorage.setItem("AgentState", JSON.stringify(agent.toJSON()));

    if(iteration < 100) {
        app.ports.requestInitialState.send(null);
    }
});

function train() {
    iteration = 0;
    app.ports.requestInitialState.send(null);
}

function randomMove() {
    const x = Math.floor(Math.random() * 10) + 1;
    const y = Math.floor(Math.random() * 10) + 1;
    return [x,y];
}

function sum(arr) {
    return arr.reduce((acc, v) => acc + v, 0);
}

// This is our reward function
//  r(a;t0) = ∑t≥t0(h(t)–h(t))(0.5)t−t
// looks at action a taken at time t0 and returns a
// weighted sum of hit values h(t) for this and all
// future steps of the game
function calculateReward(hitlog, gamma) {
    const weighted = hitlog.map((item, i) => {
        const sumPreviousHits = sum(hitlog.slice(0, i));
        const remainingHits = 17 - sumPreviousHits;
        const total = 100 - (Math.pow (gamma, i));
        return item - remainingHits / total;
    });

    const reward = weighted.map((item, i) => {
       const sumRemainingWeighted = sum(weighted.slice(i));
       return Math.pow(gamma, -i) * sumRemainingWeighted;
    });

    return reward[reward.length-1];
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
            coords.push(hit ? 1 : miss ? 0 : -1);
        }
    }
    return coords;
}

let currentState = mapState({hits:[], misses:[]});

app.ports.startTraining.subscribe(() => {
    console.log('starting training game');
    train();
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

const state = localStorage.getItem("AgentState")
if(state) {
    agent.fromJSON(JSON.parse(state));
}

/* to save agent use agent.toJSON() and agent.fromJSON() and localStorage */
