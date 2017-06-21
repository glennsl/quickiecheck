open Jest
open Expect1
let (forAll) = Quickie.Property.(forAll);
module Gen = TheBox.OfGenerators
module Quick = Quickie.Make(struct
  type t = unit case
  let ok () = Just Ok
  let fail s = Just (Fail s)
end)

type 'a tree =
| Node of 'a tree * 'a * 'a tree
| Leaf

let _ = 

describe "recursive variant" (fun _ ->
  let rec gen_tree gen_element =
    Gen.oneOf [|
      (fun rng size -> Node ((gen_tree gen_element rng size), gen_element rng size, Leaf));
      (fun rng size -> Node (Leaf, gen_element rng size, (gen_tree gen_element rng size)));
      (fun rng size -> Node ((gen_tree gen_element rng size), gen_element rng size, (gen_tree gen_element rng size)));
      (fun rng size -> Node (Leaf, gen_element rng size, Leaf));
    |] in

  Quick.check
    (Prop.forAll
      (gen_tree Gen.int)
      (function
        | Node _ -> true
        | _ -> false))
);