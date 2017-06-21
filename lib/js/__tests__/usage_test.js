'use strict';

var Jest    = require("bs-jest/lib/js/src/jest.js");
var Curry   = require("bs-platform/lib/js/curry.js");
var TheBox  = require("../src/theBox.js");
var Quickie = require("../src/quickie.js");

var forAll = Quickie.Property[/* forAll */0];

function ok() {
  return Jest.pass;
}

var fail = Jest.fail;

var Quick = Quickie.Make(/* module */[
      /* ok */ok,
      /* fail */fail
    ]);

describe("recursive variant", (function () {
        return Jest.test("tree", (function () {
                      var gen_tree = function (gen_element, r, s) {
                        return Curry._3(TheBox.OfGenerators[/* oneOf */2], /* array */[
                                    (function (rng, size) {
                                        return /* Node */[
                                                gen_tree(gen_element, rng, size),
                                                Curry._2(gen_element, rng, size),
                                                /* Leaf */0
                                              ];
                                      }),
                                    (function (rng, size) {
                                        return /* Node */[
                                                /* Leaf */0,
                                                Curry._2(gen_element, rng, size),
                                                gen_tree(gen_element, rng, size)
                                              ];
                                      }),
                                    (function (rng, size) {
                                        return /* Node */[
                                                gen_tree(gen_element, rng, size),
                                                Curry._2(gen_element, rng, size),
                                                gen_tree(gen_element, rng, size)
                                              ];
                                      }),
                                    (function (rng, size) {
                                        return /* Node */[
                                                /* Leaf */0,
                                                Curry._2(gen_element, rng, size),
                                                /* Leaf */0
                                              ];
                                      })
                                  ], r, s);
                      };
                      var partial_arg = TheBox.OfGenerators[/* int */0];
                      return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* None */0, (function (param, param$1) {
                                        return gen_tree(partial_arg, param, param$1);
                                      }), (function (param) {
                                        if (param) {
                                          return /* true */1;
                                        } else {
                                          return /* false */0;
                                        }
                                      })));
                    }));
      }));

var Gen = 0;

exports.forAll = forAll;
exports.Gen    = Gen;
exports.Quick  = Quick;
/* Quick Not a pure module */
