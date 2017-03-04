open Jest
let (forAll) = Quickie.Property.(forAll);
module Gen = TheBox.OfGenerators
module Quick = Quickie.Make(struct
  type t = unit case
  let ok () = Just Ok
  let fail s = Just (Fail s)
end)

let _ =

test "int < size" (fun _ ->
  Quick.check
    (forAll
      Gen.int
      (fun n -> Gen.int (fun () -> n) n < n))
);

test "int > 0" (fun _ ->
  Quick.check
    (forAll
      Gen.int
      (fun n -> n > 0))
);