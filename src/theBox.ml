module OfGenerators = struct
  let int rng size =
    (rng ()) mod size

  let choose from to_ rng size =
    (int rng size) mod (from - to_) + from

  let oneOf generators rng size = 
    assert (Array.length generators > 0);
    let n = Array.length generators in
    let i = (rng ()) mod n in
    generators.(i)

  let char rng size =
    choose 0 255 rng size |> char_of_int

  let asciiChar rng size =
    choose 0 255 rng size |> char_of_int

  let arrayOf gen_element rng size =
    Array.init size (fun i -> gen_element rng size)

  (* let listOf gen_element rnd size = ... *)

  let string =
    arrayOf char

  (* A marvellous proof of concept for an example-driven generator generator *)
  type whatever
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
  let generateFromExample : 'a -> (int -> 'a) = fun a -> Obj.magic (generateFromExample (Obj.magic a))

  (* frequency *)
  (*  *)

end