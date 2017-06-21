'use strict';

var Jest       = require("bs-jest/lib/js/src/jest.js");
var $$Array    = require("bs-platform/lib/js/array.js");
var Curry      = require("bs-platform/lib/js/curry.js");
var TheBox     = require("../../src/theBox.js");
var Quickie    = require("../../src/quickie.js");
var Caml_obj   = require("bs-platform/lib/js/caml_obj.js");
var Caml_int32 = require("bs-platform/lib/js/caml_int32.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");

var forAll = Quickie.Property[/* forAll */0];

var fixSize = Quickie.Generator[/* fixSize */0];

function ok() {
  return Jest.pass;
}

var fail = Jest.fail;

var Quick = Quickie.Make(/* module */[
      /* ok */ok,
      /* fail */fail
    ]);

Jest.test("int < size", (function () {
        return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* None */0, TheBox.OfGenerators[/* int */0], (function (n) {
                          return +(Curry._2(TheBox.OfGenerators[/* int */0], (function () {
                                          return n;
                                        }), n) < n);
                        })));
      }));

Jest.test("int > 0", (function () {
        return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* None */0, TheBox.OfGenerators[/* int */0], (function (n) {
                          return +(n > 0);
                        })));
      }));

Jest.test("int - 10±5% in bottom decile", (function () {
        var quantileSize = 100;
        var acceptedDeviation = quantileSize / 2 | 0;
        var quantileThreshold = 107374182;
        var quantile = function (v) {
          return v.filter((function (param) {
                        return Caml_obj.caml_greaterthan(quantileThreshold, param);
                      }));
        };
        var deviation = function (q) {
          return Pervasives.abs(quantileSize - q.length | 0);
        };
        return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* Some */[(function (v, _) {
                            var actual = Pervasives.string_of_int(deviation(quantile(v)));
                            var accepted = Pervasives.string_of_int(acceptedDeviation);
                            return "Sample deviates by " + (actual + (" which is greater than the accepted deviation of " + accepted));
                          })], Curry._2(fixSize, 1000, Curry._1(TheBox.OfGenerators[/* arrayOf */5], Curry._2(fixSize, 1073741823, TheBox.OfGenerators[/* int */0]))), (function (v) {
                          return Caml_obj.caml_greaterequal(acceptedDeviation, deviation(quantile(v)));
                        })));
      }));

Jest.test("int - 10±5% in top decile", (function () {
        var quantileSize = 100;
        var acceptedDeviation = quantileSize / 2 | 0;
        var quantileThreshold = 966367641;
        var quantile = function (v) {
          return v.filter((function (param) {
                        return Caml_obj.caml_lessthan(quantileThreshold, param);
                      }));
        };
        var deviation = function (q) {
          return Pervasives.abs(quantileSize - q.length | 0);
        };
        return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* Some */[(function (v, _) {
                            var actual = Pervasives.string_of_int(deviation(quantile(v)));
                            var accepted = Pervasives.string_of_int(acceptedDeviation);
                            return "Sample deviates by " + (actual + (" which is greater than the accepted deviation of " + accepted));
                          })], Curry._2(fixSize, 1000, Curry._1(TheBox.OfGenerators[/* arrayOf */5], Curry._2(fixSize, 1073741823, TheBox.OfGenerators[/* int */0]))), (function (v) {
                          return Caml_obj.caml_greaterequal(acceptedDeviation, deviation(quantile(v)));
                        })));
      }));

Jest.test("choose - 10±5% in bottom decile", (function () {
        var quantileSize = 100;
        var acceptedDeviation = quantileSize / 2 | 0;
        var quantileThreshold = 10;
        var quantile = function (v) {
          return v.filter((function (param) {
                        return Caml_obj.caml_greaterthan(quantileThreshold, param);
                      }));
        };
        var deviation = function (q) {
          return Pervasives.abs(quantileSize - q.length | 0);
        };
        return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* Some */[(function (v, _) {
                            var actual = Pervasives.string_of_int(deviation(quantile(v)));
                            var accepted = Pervasives.string_of_int(acceptedDeviation);
                            return "Sample deviates by " + (actual + (" which is greater than the accepted deviation of " + accepted));
                          })], Curry._2(fixSize, 1000, Curry._1(TheBox.OfGenerators[/* arrayOf */5], Curry._2(fixSize, 100, Curry._2(TheBox.OfGenerators[/* choose */1], 0, 100)))), (function (v) {
                          return Caml_obj.caml_greaterequal(acceptedDeviation, deviation(quantile(v)));
                        })));
      }));

Jest.test("choose - 10±5% in top decile", (function () {
        var quantileSize = 100;
        var acceptedDeviation = quantileSize / 2 | 0;
        var quantileThreshold = 4140;
        var quantile = function (v) {
          return v.filter((function (param) {
                        return Caml_obj.caml_lessthan(quantileThreshold, param);
                      }));
        };
        var deviation = function (q) {
          return Pervasives.abs(quantileSize - q.length | 0);
        };
        return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* Some */[(function (v, _) {
                            var actual = Pervasives.string_of_int(deviation(quantile(v)));
                            var accepted = Pervasives.string_of_int(acceptedDeviation);
                            return "Sample deviates by " + (actual + (" which is greater than the accepted deviation of " + accepted));
                          })], Curry._2(fixSize, 1000, Curry._1(TheBox.OfGenerators[/* arrayOf */5], Curry._2(fixSize, 4600, Curry._2(TheBox.OfGenerators[/* choose */1], 0, 4600)))), (function (v) {
                          return Caml_obj.caml_greaterequal(acceptedDeviation, deviation(quantile(v)));
                        })));
      }));

Jest.test("oneOf - ±10% even distribution", (function () {
        var choices = /* array */[
          "a",
          "b",
          "c"
        ];
        var target = Caml_int32.div(1000, choices.length);
        var acceptedDeviation = target / 10 | 0;
        var count = function (arr, value) {
          return arr.filter((function (param) {
                        return Caml_obj.caml_equal(value, param);
                      })).length;
        };
        return Curry._3(Quick[/* check */0], /* None */0, /* None */0, Curry._3(forAll, /* Some */[(function (v, _) {
                            var target$1 = Pervasives.string_of_int(target);
                            var accepted = Pervasives.string_of_int(acceptedDeviation);
                            var distribution = $$Array.map((function (param) {
                                      return param[0] + (": " + Pervasives.string_of_int(param[1]));
                                    }), $$Array.map((function (c) {
                                          return /* tuple */[
                                                  c,
                                                  count(v, c)
                                                ];
                                        }), choices)).join("\r\n\t");
                            return "Sample is too unevenly distributed (target: " + (target$1 + ("±" + (accepted + ("):\r\n\t" + distribution))));
                          })], Curry._2(fixSize, 1000, Curry._1(TheBox.OfGenerators[/* arrayOf */5], Curry._1(TheBox.OfGenerators[/* oneOf */2], $$Array.map((function (x, _, _$1) {
                                          return x;
                                        }), choices)))), (function (arr) {
                          return Caml_obj.caml_lessthan(0, $$Array.map(Pervasives.abs, $$Array.map((function (param) {
                                                  return target - param | 0;
                                                }), $$Array.map((function (param) {
                                                      return count(arr, param);
                                                    }), choices))).filter((function (param) {
                                            return Caml_obj.caml_greaterthan(acceptedDeviation, param);
                                          })).length);
                        })));
      }));

var Gen = 0;

exports.forAll  = forAll;
exports.fixSize = fixSize;
exports.Gen     = Gen;
exports.Quick   = Quick;
/* Quick Not a pure module */
