'use strict';

var Curry      = require("bs-platform/lib/js/curry.js");
var Random     = require("bs-platform/lib/js/random.js");
var Caml_array = require("bs-platform/lib/js/caml_array.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");

Random.self_init(/* () */0);

function make(seed) {
  return /* tuple */[
          Curry._1(Random.State[/* make */0], /* int array */[seed]),
          seed
        ];
}

function seed(param) {
  return param[1];
}

function $$int(param) {
  return Curry._2(Random.State[/* int */4], param[0], 1073741823);
}

var DefaultRNG = /* module */[
  /* make */make,
  /* seed */seed,
  /* int */$$int
];

function fixSize(size, g, rng, _) {
  return Curry._2(g, rng, size);
}

var Generator = /* module */[/* fixSize */fixSize];

function beta_reduce(x, f) {
  var match = (/function\s*\(([^\)]+)\)/).exec(f);
  if (match !== null) {
    var arg = Caml_array.caml_array_get(match, 1);
    var match$1 = (/function\s+\(.+\)\s*{([\s\S]*)}/).exec(f);
    if (match$1 !== null) {
      return Caml_array.caml_array_get(match$1, 1).trim().replace((/^return /), "").replace((/;$/), "").replace(new RegExp("\\b" + (arg + "\\b")), x);
    } else {
      return f;
    }
  } else {
    return f;
  }
}

function defaultMessage(sample, predicate) {
  var s = JSON.stringify(sample);
  var p = beta_reduce(s, new String(predicate));
  return s + (" does not satisfy the property\r\n\r\n\t" + p);
}

function forAll($staropt$star, generator, predicate, rng, size) {
  var message = $staropt$star ? $staropt$star[0] : defaultMessage;
  var sample = Curry._2(generator, rng, size);
  if (Curry._1(predicate, sample)) {
    return /* Ok */0;
  } else {
    return /* Fail */[Curry._2(message, sample, predicate)];
  }
}

var Property = /* module */[/* forAll */forAll];

function Make(Assert) {
  var check = function ($staropt$star, $staropt$star$1, property) {
    var seed$1 = $staropt$star ? $staropt$star[0] : Random.$$int(1073741823);
    var iterations = $staropt$star$1 ? $staropt$star$1[0] : 100;
    var rngState = make(seed$1);
    var property$1 = property;
    var iterations$1 = iterations;
    var _i = 0;
    while(true) {
      var i = _i;
      if (i >= iterations$1) {
        return Curry._1(Assert[/* ok */0], /* () */0);
      } else {
        var rng = function () {
          return $$int(rngState);
        };
        var match = Curry._2(property$1, rng, 1073741823);
        if (match) {
          return Curry._1(Assert[/* fail */1], "Iteration " + (Pervasives.string_of_int(i) + (" using seed: " + (Pervasives.string_of_int(seed(rngState)) + ("\r\n\r\n" + (match[0] + "\r\n"))))));
        } else {
          _i = i + 1 | 0;
          continue ;
          
        }
      }
    };
  };
  return /* module */[/* check */check];
}

function check($staropt$star, $staropt$star$1, property) {
  var seed$1 = $staropt$star ? $staropt$star[0] : Random.$$int(1073741823);
  var iterations = $staropt$star$1 ? $staropt$star$1[0] : 100;
  var rngState = make(seed$1);
  var property$1 = property;
  var iterations$1 = iterations;
  var _i = 0;
  while(true) {
    var i = _i;
    if (i >= iterations$1) {
      return /* true */1;
    } else {
      var rng = function () {
        return $$int(rngState);
      };
      var match = Curry._2(property$1, rng, 1073741823);
      if (match) {
        "Iteration " + (Pervasives.string_of_int(i) + (" using seed: " + (Pervasives.string_of_int(seed(rngState)) + ("\r\n\r\n" + (match[0] + "\r\n")))));
        return /* false */0;
      } else {
        _i = i + 1 | 0;
        continue ;
        
      }
    }
  };
}

exports.DefaultRNG = DefaultRNG;
exports.Generator  = Generator;
exports.Property   = Property;
exports.Make       = Make;
exports.check      = check;
/*  Not a pure module */
