require('./main.css');

var Elm = require('./Main.elm');

var root  = document.getElementById('root');

var app = Elm.Main.embed(root);

var setDb = function(db) {
    localStorage.setItem('demons_db', JSON.stringify(db));
};

//load children from local storage and then pipe into the storage port
if(localStorage) {
    var db_str = localStorage.getItem('demons_db');
    var db;
    if(db_str == null) {
        db = {children:[]};
        setDb(db);
    } else {
        db = JSON.parse(db_str);
    }

    app.ports.storage.send(db);
    app.ports.updateStorage.subscribe(setDb);
} else {
    console.log('This app requires localStorage to work properly really')
}



