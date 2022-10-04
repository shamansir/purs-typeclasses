let e = ./expr.dhall


-- let r = e.Expr/render


let raw
    : Text -> e.Expr
    = e.Expr.Raw

let test_raw = assert : e.Expr/render (raw "foobar_%2x* x 2") ≡ "foobar_%2x* x 2"


let num
    : Text -> e.Expr
    = e.Expr.Num

let test_raw = assert : e.Expr/render (num "42") ≡ "{{num:42}}"


let ph
    : e.Expr
    = e.Expr.PH

let test_ph = assert : e.Expr/render ph ≡ "{{var:_}}"

-- norm Var: a, b etc.
let n
    : Text -> e.Expr
    = \(v : Text)
    -> e.Expr.Var v

let test_n = assert : e.Expr/render (n "v") ≡ "{{var:v}}"

-- functor-style Var: f, g, m, ...
let f
    : Text -> e.Expr
    = \(f : Text) -> e.Expr.Single (e.What.FVar f)

let test_f = assert : e.Expr/render (f "f") ≡ "{{fvar:f}}"

-- type-style Var: w, t, m, ...
let t
    : Text -> e.Expr
    = \(t : Text) -> e.Expr.Single (e.What.Type_ t)

let test_t = assert : e.Expr/render (t "w") ≡ "{{typevar:w}}"

-- bracket the expression
let br
    : e.Expr -> e.Expr
    = \(expr : e.Expr) -> e.Expr.Brackets (e.Expr/seal expr)

let test_br = assert : e.Expr/render (br (t "w")) ≡ "({{typevar:w}})"


-- expr1 expr2 expr3 ...
let ap
    : List e.Expr -> e.Expr
    = \(items : List e.Expr) ->
    e.Expr.ApplyExp { items = e.Expr/sealAll items }

let test_ap
    = assert
    : e.Expr/render (ap [ t "w", n "v", f "f" ])
    ≡ "{{typevar:w}} {{var:v}} {{fvar:f}}"


-- expr1 expr2
let ap2
    : e.Expr -> e.Expr -> e.Expr
    = \(expr1 : e.Expr) -> \(expr2 : e.Expr)
    -> ap [ expr1, expr2 ]

let test_ap2
    = assert
    : e.Expr/render (ap2 (t "f") (n "v"))
    ≡ "{{typevar:f}} {{var:v}}"


let ap3
    : e.Expr -> e.Expr -> e.Expr -> e.Expr
    = \(expr1 : e.Expr) -> \(expr2 : e.Expr) -> \(expr3 : e.Expr)
    -> ap [ expr1, expr2, expr3 ]

let test_ap3
    = assert
    : e.Expr/render (ap3 (t "f") (n "v") (n "x"))
    ≡ "{{typevar:f}} {{var:v}} {{var:x}}"


-- what expr1 expr2 expr3 ...
let apw
    : e.What -> List e.Expr -> e.Expr
    = \(what : e.What) -> \(args : List e.Expr) ->
    e.Expr.Apply { what, arguments = e.Expr/sealAll args }

let test_apw
    = assert
    : e.Expr/render (apw (e.What.FVar "f") [ t "w", n "v", f "f" ])
    ≡ "{{fvar:f}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- what
let apwE
    : e.What -> e.Expr
    = \(what : e.What)
    -> apw what e.Expr/none

let test_apwE
    = assert
    : e.Expr/render (apwE (e.What.FVar "f"))
    ≡ "{{fvar:f}}"


-- what expr1
let apw1
    : e.What -> e.Expr -> e.Expr
    = \(what : e.What) -> \(var : e.Expr)
    -> apw what [ var ]

let test_apw1
    = assert
    : e.Expr/render (apw1 (e.What.FVar "f") (n "v"))
    ≡ "{{fvar:f}} {{var:v}}"


-- Subject expr1 expr2 ...
let subj
    : Text -> List e.Expr -> e.Expr
    = \(subj : Text) -> \(args : List e.Expr) ->
    apw (e.What.Subject subj) args

let test_subj
    = assert
    : e.Expr/render (subj "Foo" [ t "w", n "v", f "f" ])
    ≡ "{{subj:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- Subject
let subjE
    : Text -> e.Expr
    = \(subj_ : Text) ->
    subj subj_ e.Expr/none -- ≡ E.Single (e.What.Subj subj)

let test_subjE
    = assert
    : e.Expr/render (subjE "Foo")
    ≡ "{{subj:Foo}}"


-- Subject expr
let subj1
    : Text -> e.Expr -> e.Expr
    = \(subj_ : Text) -> \(var : e.Expr) ->
    subj subj_ [ var ]

let test_subj1
    = assert
    : e.Expr/render (subj1 "Foo" (n "v"))
    ≡ "{{subj:Foo}} {{var:v}}"


-- Class expr1 expr2 ...
let class
    : Text -> List e.Expr -> e.Expr
    = \(cl : Text) -> \(args : List e.Expr) ->
    apw (e.What.Class cl) args

let test_class
    = assert
    : e.Expr/render (class "Foo" [ t "w", n "v", f "f" ])
    ≡ "{{class:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- Class
let classE
    : Text -> e.Expr
    = \(cl : Text) ->
    class cl e.Expr/none -- ≡ E.Single (e.What.Class cl)

let test_classE
    = assert
    : e.Expr/render (classE "foo")
    ≡ "{{class:foo}}"


-- Class expr
let class1
    : Text -> e.Expr -> e.Expr
    = \(cl : Text) -> \(expr : e.Expr) ->
    class cl [ expr ]

let test_class1
    = assert
    : e.Expr/render (class1 "Foo" (n "v"))
    ≡ "{{class:Foo}} {{var:v}}"




-- fn expr1 expr2 ...
let call
    : Text -> List e.Expr -> e.Expr
    = \(fn : Text) -> \(args : List e.Expr) ->
    apw (e.What.Function fn) args

let test_call
    = assert
    : e.Expr/render (call "foobar" [ t "w", n "v", f "f" ])
    ≡ "{{method:foobar}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- fn
let callE
    : Text -> e.Expr
    = \(fn : Text) ->
    call fn e.Expr/none -- ≡ E.Single (e.What.Function fn)

let test_callE
    = assert
    : e.Expr/render (callE "foobar")
    ≡ "{{method:foobar}}"


-- fn expr1
let call1
    : Text -> e.Expr -> e.Expr
    = \(fn : Text) -> \(var : e.Expr) ->
    call fn [ var ]

let test_call1
    = assert
    : e.Expr/render (call1 "foobar" (n "v"))
    ≡ "{{method:foobar}} {{var:v}}"


-- expr1 -> expr2 -> expr3 -> ...
let fn
    : List e.Expr -> e.Expr
    = \(args : List e.Expr)
    -> e.Expr.FnTypeDef { items = e.Expr/sealAll args }

let test_fn
    = assert
    : e.Expr/render (fn [ class "Foo" [ t "w", n "v", f "f" ], class "Bar" [ t "v", n "n" ], n "v", classE "Foo" ])
    ≡ "{{class:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}} {{op:->}} {{class:Bar}} {{typevar:v}} {{var:n}} {{op:->}} {{var:v}} {{op:->}} {{class:Foo}}"


-- expr1 -> expr2
let fn2
    : e.Expr -> e.Expr -> e.Expr
    = \(expr1 : e.Expr) -> \(expr2 : e.Expr)
    -> fn [ expr1, expr2 ]

let test_fn2
    = assert
    : e.Expr/render (fn2 (class "Bar" [ t "v", n "n" ]) (n "v"))
    ≡ "{{class:Bar}} {{typevar:v}} {{var:n}} {{op:->}} {{var:v}}"


-- expr1 -> expr2 -> expr3
let fn3
    : e.Expr -> e.Expr -> e.Expr -> e.Expr
    = \(expr1 : e.Expr) -> \(expr2 : e.Expr) -> \(expr3 : e.Expr)
    -> fn [ expr1, expr2, expr3 ]

let test_fn3
    = assert
    : e.Expr/render (fn3 (classE "Foo") (class "Bar" [ t "v", n "n" ]) (n "v"))
    ≡ "{{class:Foo}} {{op:->}} {{class:Bar}} {{typevar:v}} {{var:n}} {{op:->}} {{var:v}}"


-- left `op` right
let inf
    : Text -> e.Expr -> e.Expr -> e.Expr
    = \(op: Text) -> \(left : e.Expr) -> \(right : e.Expr)
    -> e.Expr.OperatorCall { op, left = e.Expr/seal left, right = e.Expr/seal right }

let test_inf1
    = assert
    : e.Expr/render (inf "*" (n "PI") (num "2"))
    ≡ "{{var:PI}} {{op:*}} {{num:2}}"


-- fn :: expr1 -> expr2 ...
let mdef
    : Text -> List e.Expr -> e.Expr
    = \(fn : Text) -> \(args : List e.Expr)
    -> e.Expr.FnDef { fn, items = e.Expr/sealAll args }

let test_mdef
    = assert
    : e.Expr/render (mdef "buz" [ class "Bar" [ t "v", n "n" ], classE "Foo", n "v" ])
    ≡ "{{method:buz}} {{op:::}} {{class:Bar}} {{typevar:v}} {{var:n}} {{op:->}} {{class:Foo}} {{op:->}} {{var:v}}"


-- fn :: expr
let mdef1
    : Text -> e.Expr -> e.Expr
    = \(fn : Text) -> \(def : e.Expr)
    -> mdef fn [ def ]

let test_mdef1
    = assert
    : e.Expr/render (mdef1 "buz" (n "v"))
    ≡ "{{method:buz}} {{op:::}} {{var:v}}"


-- (req1, req2, ...) => what
let req
    : List e.Expr -> e.Expr -> e.Expr
    = \(reqs : List e.Expr) -> \(what : e.Expr)
    -> e.Expr.Constrained { constraints = e.Expr/sealAll reqs, expr = e.Expr/seal what }

let test_req
    = assert
    : e.Expr/render (req [ class "Bar" [ t "v", n "n" ], classE "Foo", n "v" ] (class1 "Foo" (n "v")))
    ≡ "({{class:Bar}} {{typevar:v}} {{var:n}}, {{class:Foo}}, {{var:v}}) {{op:=>}} {{class:Foo}} {{var:v}}"


-- req1 => req2 => ... => what
let reqseq
    : List e.Expr -> e.Expr -> e.Expr
    = \(reqs : List e.Expr) -> \(what : e.Expr)
    -> e.Expr.ConstrainedSeq { constraints = e.Expr/sealAll reqs, expr = e.Expr/seal what }
let test_reqseq
    = assert
    : e.Expr/render (reqseq [ class "Bar" [ t "v", n "n" ], classE "Foo", n "v" ] (class1 "Foo" (n "v")))
    ≡ "{{class:Bar}} {{typevar:v}} {{var:n}} {{op:=>}} {{class:Foo}} {{op:=>}} {{var:v}} {{op:=>}} {{class:Foo}} {{var:v}}"


-- req => what
let req1
    : e.Expr -> e.Expr -> e.Expr
    = \(req : e.Expr) -> \(what : e.Expr) ->
    reqseq [ req ] what
let test_req1
    = assert
    : e.Expr/render (req1 (class "Bar" [ t "v", n "n" ]) (class1 "Foo" (n "v")))
    ≡ "{{class:Bar}} {{typevar:v}} {{var:n}} {{op:=>}} {{class:Foo}} {{var:v}}"


let r = e.Expr/render


in
    { raw, num, ph
    , n, f, t
    , br
    , ap, ap2, ap3
    , apw, apwE, apw1
    , subj, subjE, subj1
    , class, classE, class1
    , call, callE, call1
    , fn, fn2, fn3
    , inf
    , mdef, mdef1
    , req, req1, reqseq
    , r
    }