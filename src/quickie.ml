
type 'a testResult =
| Ok
| Fail of string

(* Initialize Random so it won't use the default seed *)
let _ = Random.self_init()

external toString : 'a -> string = "JSON.stringify" [@@bs.val]
external toStringProp : ('a -> bool) -> string = "String" [@@bs.new]

type rng = unit -> int

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

module Generator = struct
  type 'a t = (rng -> int -> 'a)

  let fixSize size g = fun rng _ -> g rng size

  (* sample *)
  (* recursive *)
  (* fmap *)
  (* map *)
end

module Property : sig
  type 'a t = (rng -> int -> 'a testResult)
  type 'a predicate = ('a -> bool)

  val forAll : ?message:('a -> ('a -> bool) -> string) -> 'a Generator.t -> 'a predicate -> 'a t
end = struct
  type 'a t = (rng -> int -> 'a testResult)
  type 'a predicate = ('a -> bool)

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

  let defaultMessage = fun sample predicate ->
    let s = toString sample in
    let p = predicate |> toStringProp |> beta_reduce s in
    s ^ " does not satisfy the property\r\n\r\n\t" ^ p

  let forAll ?(message=defaultMessage) generator predicate = fun rng size ->
    let sample = generator rng size in
    if predicate sample then Ok else Fail (message sample predicate)
end

module type Assertions = sig
  type t
  val ok : unit -> t
  val fail : string -> t
end

module Make (Assert : Assertions) : sig
  val check : 
    ?seed:int ->
    ?iterations:int ->
    'a Property.t ->
    Assert.t
end = struct
  module RNG = DefaultRNG

  let max_rng_int = (1 lsl 30) - 1

  let rec run rngState property = function
    | 0 -> Assert.ok ()
    | i -> 
      let size = max_rng_int in (* TODO *)
      let rng = fun () -> RNG.int rngState in
      match property rng size with
      | Ok ->
        run rngState property (i - 1)
      | Fail message ->
        Assert.fail ("Using seed: " ^ (string_of_int (RNG.seed rngState)) ^ "\r\n\r\n" ^ message ^ "\r\n")

  let check
    ?(seed=Random.int max_rng_int)
    ?(iterations=100)
    property
  = run (RNG.make seed) property iterations
end

include Make(struct
  type t = bool
  let ok () = true
  let fail _ = false
end)