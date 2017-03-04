
open Jest
module Gen = TheBox.OfGenerators
let (forAll) = Quickie.Property.(forAll)

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
      (fun n -> Gen.int (fun () -> n) n < n)
    )
);

test "int > 0" (fun _ ->
  Quick.check
    (forAll
      Gen.int
      (fun n -> n > 0)
    )
);

test "int - 10±5% in bottom decile" (fun _ ->
  let max = (1 lsl 30) - 1 in
  let sampleSize = 1000 in
  let quantileSizePercentage = 10 in
  let quantileSize = sampleSize / quantileSizePercentage in
  let acceptedDeviation = (quantileSize / 2) in
  let quantileThreshold = max / quantileSizePercentage in
  let quantile v = v |> Js.Array.filter ((>) quantileThreshold) in
  let deviation q = q |> Array.length |> ((-) quantileSize) |> abs in
  Quick.check
    (forAll
      (fun rng _ -> Gen.arrayOf (fun rng _ -> Gen.int rng max) rng sampleSize)
      (fun v ->
        v |> quantile
          |> deviation
          |> ((>=) acceptedDeviation)
      )
      ~message:(fun v _ -> "Sample deviates by " ^ (v |> quantile |> deviation |> string_of_int) ^ " which is greater than the accepted deviation of " ^ (string_of_int acceptedDeviation))
    )
);

test "int - 10±5% in top decile" (fun _ ->
  let max = (1 lsl 30) - 1 in
  let sampleSize = 1000 in
  let quantileSizePercentage = 10 in
  let quantileSize = sampleSize / quantileSizePercentage in
  let acceptedDeviation = (quantileSize / 2) in
  let quantileThreshold = max / quantileSizePercentage * 9 in
  let quantile v = v |> Js.Array.filter ((<) quantileThreshold) in
  let deviation q = q |> Array.length |> ((-) quantileSize) |> abs in
  Quick.check
    (forAll
      (fun rng _ -> Gen.arrayOf (fun rng _ -> Gen.int rng max) rng sampleSize)
      (fun v ->
        v |> quantile
          |> deviation
          |> ((>=) acceptedDeviation)
      )
      ~message:(fun v _ -> "Sample deviates by " ^ (v |> quantile |> deviation |> string_of_int) ^ " which is greater than the accepted deviation of " ^ (string_of_int acceptedDeviation))
    )
);

test "choose - distribution sanity check" (fun _ ->
  Quick.check
    (forAll
      (fun rng _ -> Gen.arrayOf (Gen.choose 0 100) rng 100)
      (fun v ->
        v |> Js.Array.filter ((<) 10)
          |> Array.length
          |> (fun n -> abs (n - 10) < 0)
      )
    )
);
