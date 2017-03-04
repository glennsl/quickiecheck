
type 'a testResult =
| Ok
| Fail of 'a * ('a -> bool)
| Discard

external toString : 'a -> string = "JSON.stringify" [@@bs.val]
external toStringProp : ('a -> bool) -> string = "String" [@@bs.new]

type whatever
external toWhatever : 'a -> whatever = "%identity"
external fromWhatever : whatever -> 'a = "%identity"

module type RNG = sig
  type state
  val make  : int -> state
  val seed : state -> int
  val int : state -> int
end

module DefaultRNG : RNG = struct
  type state = Random.State.t * int
  let make seed = (Random.State.make [| seed |], seed)
  let seed = function (_, seed) -> seed
  let int = function (r,  _) -> Random.State.int r ((1 lsl 30) - 1)
end

module Gen = struct
  (* A marvell proof of concept of an example driven generator generator *)
  let int n = n
  let string _ = "x"
  let array_of gen n = [| gen n |]

  let generateFromExample : whatever -> (int -> whatever) = [%bs.raw {|
    function generateFromExample(example) {
      switch (example.constructor) {
        case Number: return int;
        case String: return string;
        case Array: return array_of.bind(null, generateFromExample(example[0]));
        default: throw new Error("unknown constructor `" + example.constructor + "` of example `" + example + "`.");
      }
    }
  |}]

  (* frequency *)
  (* one_of / choose *)
  (*  *)

end

module Prop : sig
  val forAll :
    (int -> 'a) ->
    ('a -> bool) ->
    (int -> 'a testResult)
end = struct
  let forAll generator f = fun n ->
      let sample = generator n in
      if f sample then Ok else Fail (sample, f)
end

module type Assertions = sig
  type t
  val ok : unit -> t
  val fail : string -> t
end

module Make (Assert : Assertions) : sig
  val check : 
    ?seed:int ->
    ?toString:('a -> string) ->
    ?iterations:int ->
    (int -> 'a testResult) ->
    Assert.t
end = struct
  module RNG = DefaultRNG

  let beta_reduce x f =
    match [%re "/function\\s*\\(([^\\)]+)\\)/"] |> Js.Re.exec f |> Js.Null.to_opt with
    | None -> f
    | Some res ->
      let arg = (res |> Js.Re.matches).(1) in
      match [%re "/function\\s+\\(.+\\)\\s*{([\\s\\S]*)}/"] |> Js.Re.exec f |> Js.Null.to_opt with
      | None -> f
      | Some res ->
        res |> Js.Re.matches
            |> (fun matches -> matches.(1))
            |> Js.String.trim
            |> Js.String.replaceByRe [%re "/^return /"] ""
            |> Js.String.replaceByRe [%re "/;$/"] ""
            |> Js.String.replaceByRe (Js.Re.fromString ("\\b" ^ arg ^ "\\b")) x

  let rec run rng property = function
    | 0 -> Assert.ok ()
    | i -> 
      match property (RNG.int rng) with
      | Discard
      | Ok ->
        run rng property (i - 1)
      | Fail (sample, f) ->
        let s = toString sample in
        let p = f |> toStringProp |> beta_reduce s in
        Assert.fail ("Using seed: " ^ (string_of_int (RNG.seed rng)) ^ "\r\n\r\n" ^ s ^ " does not satisfy the property\r\n\r\n\t" ^ p  ^ "\r\n")

  let check
    ?(seed=Random.int ((1 lsl 30) - 1))
    ?(toString=toString)
    ?(iterations=100)
    property
  = run (RNG.make seed) property iterations
end

include Make(struct
  type t = bool
  let ok () = true
  let fail _ = false
end)