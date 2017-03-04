open Quickie
open Jest

module Quick = Make(struct
  type t = unit case
  let ok () = Just Ok
  let fail s = Just (Fail s)
end)

let _ =

test "first test" (fun _ ->
  Quick.check
    (Prop.forAll
      (fun n -> n mod 10)
      (fun n -> n < 10))
);

test "second test" (fun _ ->
  Quick.check
    (Prop.forAll
      (fun n -> Quickie.fromWhatever (Quickie.Gen.generateFromExample (Quickie.toWhatever "abc") n))
      (fun s -> "abc" |> Js.String.includes s |> Js.to_bool))
);
