
open Jest
module Gen = TheBox.OfGenerators
let (forAll) = Quickie.Property.(forAll)
let (fixSize) = Quickie.Generator.(fixSize)

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

test {js|int - 10±5% in bottom decile|js} (fun _ ->
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
      (fixSize sampleSize (Gen.arrayOf (fixSize max Gen.int)))
      (fun v ->
        v |> quantile
          |> deviation
          |> ((>=) acceptedDeviation)
      )
      ~message: (fun v _ ->
        let actual = (v |> quantile |> deviation |> string_of_int) in
        let accepted = (string_of_int acceptedDeviation) in
        "Sample deviates by " ^ actual ^ " which is greater than the accepted deviation of " ^ accepted
      )
    )
);

test {js|int - 10±5% in top decile|js} (fun _ ->
  let max = (1 lsl 30) - 1 in
  let sampleSize = 1000 in
  let quantileDivisor = 10 in
  let quantileSize = sampleSize / quantileDivisor in
  let acceptedDeviation = (quantileSize / 2) in
  let quantileThreshold = max - (max / quantileDivisor) in
  let quantile v = v |> Js.Array.filter ((<) quantileThreshold) in
  let deviation q = q |> Array.length |> ((-) quantileSize) |> abs in
  Quick.check
    (forAll
      (fixSize sampleSize (Gen.arrayOf (fixSize max Gen.int)))
      (fun v ->
        v |> quantile
          |> deviation
          |> ((>=) acceptedDeviation)
      )
      ~message: (fun v _ ->
        let actual = (v |> quantile |> deviation |> string_of_int) in
        let accepted = (string_of_int acceptedDeviation) in
        "Sample deviates by " ^ actual ^ " which is greater than the accepted deviation of " ^ accepted
      )
    )
);

test {js|choose - 10±5% in bottom decile|js} (fun _ ->
  let max = 100 in
  let sampleSize = 1000 in
  let quantileDivisor = 10 in
  let quantileSize = sampleSize / quantileDivisor in
  let acceptedDeviation = (quantileSize / 2) in
  let quantileThreshold = max / quantileDivisor in
  let quantile v = v |> Js.Array.filter ((>) quantileThreshold) in
  let deviation q = q |> Array.length |> ((-) quantileSize) |> abs in
  Quick.check
    (forAll
      (fixSize sampleSize (Gen.arrayOf (fixSize max (Gen.choose 0 max))))
      (fun v ->
        v |> quantile
          |> deviation
          |> ((>=) acceptedDeviation)
      )
      ~message: (fun v _ ->
        let actual = (v |> quantile |> deviation |> string_of_int) in
        let accepted = (string_of_int acceptedDeviation) in
        "Sample deviates by " ^ actual ^ " which is greater than the accepted deviation of " ^ accepted
      )
    )
);

test {js|choose - 10±5% in top decile|js} (fun _ ->
  let max = 4600 in
  let sampleSize = 1000 in
  let quantileDivisor = 10 in
  let quantileSize = sampleSize / quantileDivisor in
  let acceptedDeviation = (quantileSize / 2) in
  let quantileThreshold = max - (max / quantileDivisor) in
  let quantile v = v |> Js.Array.filter ((<) quantileThreshold) in
  let deviation q = q |> Array.length |> ((-) quantileSize) |> abs in
  Quick.check
    (forAll
      (fixSize sampleSize (Gen.arrayOf (fixSize max (Gen.choose 0 max))))
      (fun v ->
        v |> quantile
          |> deviation
          |> ((>=) acceptedDeviation)
      )
      ~message: (fun v _ ->
        let actual = (v |> quantile |> deviation |> string_of_int) in
        let accepted = (string_of_int acceptedDeviation) in
        "Sample deviates by " ^ actual ^ " which is greater than the accepted deviation of " ^ accepted
      )
    )
);

test {js|oneOf - ±10% even distribution|js} (fun _ ->
  let choices = [| "a"; "b"; "c" |] in
  let sampleSize = 1000 in
  let target = sampleSize / Array.length choices in
  let acceptedDeviation = target / 10 in
  let count arr value =
    arr |> Js.Array.filter ((=) value)
        |> Array.length
    in
  Quick.check
    (forAll
      (fixSize sampleSize (Gen.arrayOf (Gen.oneOf choices)))
      (fun arr ->
        choices
          |> Array.map (count arr)
          |> Array.map ((-) target)
          |> Array.map abs
          |> Js.Array.filter ((>) acceptedDeviation)
          |> Array.length
          |> ((<) 0)
      )
      ~message: (fun v _ ->
        let target = string_of_int target in
        let accepted = string_of_int acceptedDeviation in
        let distribution =
          choices
            |> Array.map (fun c -> (c, count v c))
            |> Array.map (fun (c, n) -> c ^ ": " ^ (string_of_int n))
            |> Js.Array.joinWith "\r\n\t"
          in
        "Sample is too unevenly distributed (target: " ^ target ^ {js|±|js} ^ accepted ^ "):\r\n\t" ^ distribution
      )
    )
);
