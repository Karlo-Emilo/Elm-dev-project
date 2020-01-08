import  { DecisionTreeClassifier as DTC } from "ml-cart";


export function classify() {

let features = [
    [0, 1, 1],
    [1, 0, 1],
    [1, 1, 0],
    [1, 0, 0],
    [0, 1, 0],
    [0, 0, 1],
];

let labels = [1, 1, 1, 0, 0, 0];

const options = {
    gainFunction: 'gini',
    maxDepth: 3,
    minNumSamples: 3,
}

const dtc = new DTC(options);
dtc.train(features, labels);
const predictions = dtc.predict(features);

console.log('Predictions:', predictions);
console.log('Model:', dtc.toJSON());

return predictions;
}

export function testF(number) {
    console.log('NUmber in testF:', number);
    return number + 5;
}

