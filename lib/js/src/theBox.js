'use strict';

var $$Array                 = require("bs-platform/lib/js/array.js");
var Curry                   = require("bs-platform/lib/js/curry.js");
var Caml_array              = require("bs-platform/lib/js/caml_array.js");
var Caml_int32              = require("bs-platform/lib/js/caml_int32.js");
var Pervasives              = require("bs-platform/lib/js/pervasives.js");
var Caml_builtin_exceptions = require("bs-platform/lib/js/caml_builtin_exceptions.js");

function $$int(rng, size) {
  return Caml_int32.mod_(Curry._1(rng, /* () */0), size);
}

function choose(from, to_, rng, size) {
  return Caml_int32.mod_(Caml_int32.mod_(Curry._1(rng, /* () */0), size), from - to_ | 0) + from | 0;
}

function oneOf(generators, rng, size) {
  if (generators.length <= 0) {
    throw [
          Caml_builtin_exceptions.assert_failure,
          [
            "theBox.ml",
            9,
            4
          ]
        ];
  }
  var n = generators.length;
  var i = Caml_int32.mod_(Curry._1(rng, /* () */0), n);
  return Curry._2(Caml_array.caml_array_get(generators, i), rng, size);
}

function $$char(rng, size) {
  return Pervasives.char_of_int(choose(0, 255, rng, size));
}

function asciiChar(rng, size) {
  return Pervasives.char_of_int(choose(0, 255, rng, size));
}

function arrayOf(gen_element, rng, size) {
  return $$Array.init(size, (function () {
                return Curry._2(gen_element, rng, size);
              }));
}

function string(param, param$1) {
  return arrayOf($$char, param, param$1);
}

var generateFromExample = (
    function generateFromExample(example) {
      switch (example.constructor) {
        case Number: return int;
        case String: return string;
        case Array: return array_of.bind(null, generateFromExample(example[0]));
        default: throw new Error("unknown constructor `" + example.constructor + "` of example `" + example + "`.");
      }
    }
  );

var generateFromExample$1 = Curry.__1(generateFromExample);

var OfGenerators = /* module */[
  /* int */$$int,
  /* choose */choose,
  /* oneOf */oneOf,
  /* char */$$char,
  /* asciiChar */asciiChar,
  /* arrayOf */arrayOf,
  /* string */string,
  /* generateFromExample */generateFromExample$1
];

exports.OfGenerators = OfGenerators;
/* generateFromExample Not a pure module */
