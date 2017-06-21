'use strict';

var Jest       = require("bs-jest/lib/js/src/jest.js");
var Curry      = require("bs-platform/lib/js/curry.js");
var Quickie    = require("../src/quickie.js");
var Caml_obj   = require("bs-platform/lib/js/caml_obj.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");

function ok() {
  return Jest.pass;
}

var fail = Jest.fail;

var Quick = Quickie.Make(/* module */[
      /* ok */ok,
      /* fail */fail
    ]);

describe("Quickie.check", (function () {
        var ok = function () {
          return /* Okiedokie */0;
        };
        var fail = function () {
          return /* Oops */1;
        };
        var Q = Quickie.Make(/* module */[
              /* ok */ok,
              /* fail */fail
            ]);
        Jest.test("Ok returns Okiedokie", (function () {
                var ret = Curry._3(Q[/* check */0], /* None */0, /* None */0, (function (_, _$1) {
                        return /* Ok */0;
                      }));
                return Curry._2(Jest.Expect[/* toBe */2], /* Okiedokie */0, Curry._1(Jest.Expect[/* expect */0], ret));
              }));
        Jest.test("Fail returns Oops", (function () {
                var ret = Curry._3(Q[/* check */0], /* None */0, /* None */0, (function (_, _$1) {
                        return /* Fail */[""];
                      }));
                return Curry._2(Jest.Expect[/* toBe */2], /* Oops */1, Curry._1(Jest.Expect[/* expect */0], ret));
              }));
        var ok$1 = function () {
          return /* Ok */0;
        };
        var fail$1 = function (s) {
          return /* Fail */[s];
        };
        var Q$1 = Quickie.Make(/* module */[
              /* ok */ok$1,
              /* fail */fail$1
            ]);
        Jest.test("~iterations - test is run for specified number of iterations", (function () {
                return Curry._3(Quick[/* check */0], /* None */0, /* None */0, (function (rng, _) {
                              var actual = [0];
                              var expected = Curry._1(rng, /* () */0) % 100;
                              Curry._3(Q$1[/* check */0], /* None */0, /* Some */[expected], (function (_, _$1) {
                                      actual[0] = actual[0] + 1 | 0;
                                      return /* Ok */0;
                                    }));
                              if (actual[0] === expected) {
                                return /* Ok */0;
                              } else {
                                return /* Fail */[Pervasives.string_of_int(actual[0]) + (" <> " + Pervasives.string_of_int(expected))];
                              }
                            }));
              }));
        Jest.test("~seed - RNG should generate different value on first call when no seed is specified", (function () {
                var previous = [0];
                return Curry._3(Quick[/* check */0], /* None */0, /* None */0, (function (_, _$1) {
                              return Curry._3(Q$1[/* check */0], /* None */0, /* Some */[1], (function (rng, _) {
                                            var value = Curry._1(rng, /* () */0);
                                            if (previous[0] !== value) {
                                              previous[0] = value;
                                              return /* Ok */0;
                                            } else {
                                              return /* Fail */["Encountered same rng value twice in a row: " + (Pervasives.string_of_int(value) + (" = " + Pervasives.string_of_int(previous[0])))];
                                            }
                                          }));
                            }));
              }));
        return Jest.test("~seed - RNG should return same value on first call if seed is specified", (function () {
                      var previous = [/* None */0];
                      return Curry._3(Quick[/* check */0], /* None */0, /* None */0, (function (_, _$1) {
                                    return Curry._3(Q$1[/* check */0], /* Some */[876942332], /* Some */[1], (function (rng, _) {
                                                  var value = Curry._1(rng, /* () */0);
                                                  if (previous[0] === /* None */0 || Caml_obj.caml_equal(previous[0], /* Some */[value])) {
                                                    previous[0] = /* Some */[value];
                                                    return /* Ok */0;
                                                  } else {
                                                    return /* Fail */["Encountered different rng value: " + Pervasives.string_of_int(value)];
                                                  }
                                                }));
                                  }));
                    }));
      }));

describe("Property.forAll", (function () {
        return Jest.test("", (function () {
                      return Jest.pass;
                    }));
      }));

var Gen = 0;

exports.Gen   = Gen;
exports.Quick = Quick;
/* Quick Not a pure module */
