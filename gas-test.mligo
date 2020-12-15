
type storage = int

type params = {
    one: int;
    two: int;
    three: int;
  }

type parameter =
  | SimpleCall of int
  | DeepCall of int
  | RecursiveCall of int
  | RecursiveStructCall of int
  | StructCall of int
  | LambdaCall of int
  | CurryCall of int
  | SelfAddress of int
  | StringComparison of string
  | VoidCall

type return = operation list * storage

let simple_call (x : int) : storage =
 x + 1

let struct_call (x : params) : storage =
  if x.one = 10002 then (failwith "foo" : storage) else
    x.one * x.two * x.three

let deep_call (x : int) : storage =
  if x = 10002 then (failwith "foo" : storage) else
    struct_call { one = x; two = simple_call x; three = x * x }

let rec recursive_call (x : int) : storage =
  if x = 10002 then (failwith "foo" : storage) else
    if x <= 0 then 0 else recursive_call (x - 1)

let rec recursive_call_many_args
          (x,y,z,a,b,c : int * int * int * int * int * int) : storage =
  if x <= 0 then 0 else recursive_call_many_args (x - 1,y,z,c,a,b)

let rec recursive_struct_call (x : params) : storage =
  if x.one = 10002 then (failwith "foo" : storage) else
    if x.one <= 0 then 1 else
      recursive_struct_call { x with one = (x.one - 1); }

[@inline]
let call_lambda (x, f : int * (int -> int)) : int =
  f x

let lambda_call (x : int) : storage =
  if x = 10002 then (failwith "foo" : storage) else
    call_lambda (x, (fun (x : int) -> x + 1))

let curry_call (x : int) : storage =
  let plus = fun (x : int) (y : int) -> x + y in
  if x = 10002 then (failwith "foo" : storage) else
    call_lambda (x, (plus 1))

let tezos_address (x : int) : storage =
    let address_ = Tezos.self_address in
    if address_ = ("tz1fzBfFktTTqYEdc6te9Ju84GVK3nSPB4uA" : address) then
      (failwith "foo" : storage)
    else x + 1

let string_comparison ( x : string) : storage =
  if x =  "tz1fzBfFktTTqYEdc6te9Ju84GVK3nSPB4uA" then
      (failwith "foo" : storage)
    else 10

let void_call : storage =
  0

let main (action, store : parameter * storage) : return =
  ([] : operation list),
  (match action with
  | SimpleCall x -> simple_call x
  | DeepCall x -> deep_call x
  | StructCall x  -> struct_call { one = x; two = x+1; three = x * 2; }
  | RecursiveCall x -> recursive_call x
  | RecursiveStructCall x ->
     recursive_struct_call { one = x; two = x+1; three = x * 2; }
  | LambdaCall x -> lambda_call x
  | CurryCall x -> curry_call x
  | VoidCall -> void_call
  | SelfAddress x  -> tezos_address x
  | StringComparison x -> string_comparison x)
