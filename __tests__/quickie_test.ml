open Jest
open Expect

module Gen = TheBox.OfGenerators
module Quick = Quickie.Make(struct
  type t = unit assertion
  let ok () = pass
  let fail s = fail s
end)

type assertion =
| Okiedokie
| Oops
| Dunno

let _ =

describe "Quickie.check" (fun _ -> 
  let module Q = Quickie.Make(struct
    type t = assertion
    let ok () = Okiedokie
    let fail _ = Oops
  end) in

  test "Ok returns Okiedokie" (fun _ ->
    let ret = Q.check (fun _ _ -> Ok) in

    expect ret |> toBe Okiedokie
  );

  test "Fail returns Oops" (fun _ ->
    let ret = Q.check (fun _ _ -> Fail "") in

    expect ret |> toBe Oops
  );

  let module Q = Quickie.Make(struct
    type t =  string Quickie.testResult
    let ok () = Quickie.Ok
    let fail s = Quickie.Fail s
  end) in

  test "~iterations - test is run for specified number of iterations" (fun _ ->
    Quick.check (fun rng _ ->
      let actual = ref 0 in
      let expected = rng () mod 100 in
      let _ = Q.check ~iterations:expected
        (fun _ _ -> actual := !actual + 1; Ok) in
      if (!actual = expected) then Ok
      else Fail (string_of_int !actual ^ " <> " ^ string_of_int expected)
    )
  );

  test "~seed - RNG should generate different value on first call when no seed is specified" (fun _ ->
    let previous = ref 0 in
    Quick.check (fun _ _ ->
      Q.check ~iterations:1
        (fun rng _ ->
          let value = rng () in
          if !previous <> value then begin
            previous := value;
            Ok
          end
          else Fail ("Encountered same rng value twice in a row: " ^ (string_of_int value) ^ " = " ^ (string_of_int !previous))
        )
      )
  );

  test "~seed - RNG should return same value on first call if seed is specified" (fun _ ->
    let previous = ref None in
    Quick.check (fun _ _ ->
      Q.check ~iterations:1 ~seed:876942332
        (fun rng _ ->
          let value = rng () in
          if (!previous = None) || (!previous = Some value) then begin
            previous := Some value;
            Ok
          end
          else Fail ("Encountered different rng value: " ^ (string_of_int value))
        )
      )
  );
);

describe "Property.forAll" (fun _ ->
  test "" (fun _ -> pass)
);