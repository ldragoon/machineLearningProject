function splat(fun) {
    return function(array) {
        return fun.apply(null, array);
    };
}

var addArrayElements = splat(function(x, y) { return x + y });

var result = addArrayElements([1,2]);

console.log("Result: ", result);