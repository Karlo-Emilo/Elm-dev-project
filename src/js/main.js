import {Elm} from '../elm/app/Main.elm';
import '../scss/main.scss';
import {predictions, testF} from './TreeClassifier.js'


const app = Elm.Main.init({
    node: document.getElementById('elm-container'),
    flags: {}
});

let backwardTruth = 24;

app.ports.truthPort.subscribe(function(data) {
    console.log('port data:', data);
    app.ports.untruthPort.send(testF(data));
  });



if ('serviceWorker' in navigator && process.env.NODE_ENV === 'production') {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/service-worker.js');
    });
}
