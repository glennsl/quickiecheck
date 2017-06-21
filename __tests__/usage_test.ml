open Jest

let (forAll) = Quickie.Property.(forAll);

module Gen = TheBox.OfGenerators
module Quick = Quickie.Make(struct
  type t = unit assertion
  let ok () = pass
  let fail s = fail s
end)

type 'a tree =
| Node of 'a tree * 'a * 'a tree
| Leaf

let _ = 

describe "recursive variant" (fun _ ->
  test "tree" (fun _ ->
    let rec gen_tree (gen_element: Quickie.rng -> int -> int) r s =
      Gen.oneOf [|
        (fun rng size -> Node ((gen_tree gen_element rng size), gen_element rng size, Leaf));
        (fun rng size -> Node (Leaf, gen_element rng size, (gen_tree gen_element rng size)));
        (fun rng size -> Node ((gen_tree gen_element rng size), gen_element rng size, (gen_tree gen_element rng size)));
        (fun rng size -> Node (Leaf, gen_element rng size, Leaf));
      |] r s in

    Quick.check
      (forAll
        (gen_tree Gen.int)
        (function
          | Node _ -> true
          | _ -> false)))
);