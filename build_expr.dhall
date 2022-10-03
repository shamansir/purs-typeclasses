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
let ap_
    : List e.Expr -> e.Expr
    = \(items : List e.Expr) ->
    e.Expr.ApplyExp { items = e.Expr/sealAll items }

let test_ap_
    = assert
    : e.Expr/render (ap_ [ t "w", n "v", f "f" ])
    ≡ "{{typevar:w}} {{var:v}} {{fvar:f}}"


-- expr1
let ap1
    : e.Expr -> e.Expr
    = \(exp : e.Expr) -> ap_ [ exp ]

let test_ap1
    = assert
    : e.Expr/render (ap1 (f "f"))
    ≡ "{{fvar:f}}"


-- expr1 expr2
let ap2_
    : e.Expr -> e.Expr -> e.Expr
    = \(expr1 : e.Expr) -> \(expr2 : e.Expr)
    -> ap_ [ expr1, expr2 ]

let test_ap2_
    = assert
    : e.Expr/render (ap2_ (t "f") (n "v"))
    ≡ "{{typevar:f}} {{var:v}}"


-- what expr1 expr2 expr3 ...
let apw_
    : e.What -> List e.Expr -> e.Expr
    = \(what : e.What) -> \(args : List e.Expr) ->
    e.Expr.Apply { what, arguments = e.Expr/sealAll args }

let test_apw_
    = assert
    : e.Expr/render (apw_ (e.What.FVar "f") [ t "w", n "v", f "f" ])
    ≡ "{{fvar:f}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- what expr1
let apw1_
    : e.What -> e.Expr -> e.Expr
    = \(what : e.What) -> \(var : e.Expr) -> apw_ what [ var ]

let test_apw1_
    = assert
    : e.Expr/render (apw1_ (e.What.FVar "f") (n "v"))
    ≡ "{{fvar:f}} {{var:v}}"


-- what
let apwE
    : e.What -> e.Expr
    = \(what : e.What) -> apw_ what e.Expr/none

let test_apwE
    = assert
    : e.Expr/render (apwE (e.What.FVar "f"))
    ≡ "{{fvar:f}}"


-- Subject expr1 expr2 ...
let subj_
    : Text -> List e.Expr -> e.Expr
    = \(subj : Text) -> \(args : List e.Expr) ->
    apw_ (e.What.Subject subj) args

let test_subj_
    = assert
    : e.Expr/render (subj_ "Foo" [ t "w", n "v", f "f" ])
    ≡ "{{subj:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- Subject
let subjE
    : Text -> e.Expr
    = \(subj : Text) ->
    subj_ subj e.Expr/none -- ≡ E.Single (e.What.Subj subj)

let test_subjE
    = assert
    : e.Expr/render (subjE "Foo")
    ≡ "{{subj:Foo}}"


-- Subject expr
let subj1_
    : Text -> e.Expr -> e.Expr
    = \(subj : Text) -> \(var : e.Expr) ->
    subj_ subj [ var ]

let test_subj1_
    = assert
    : e.Expr/render (subj1_ "Foo" (n "v"))
    ≡ "{{subj:Foo}} {{var:v}}"


-- Class expr1 expr2 ...
let class_
    : Text -> List e.Expr -> e.Expr
    = \(cl : Text) -> \(args : List e.Expr) ->
    apw_ (e.What.Class cl) args

let test_class_
    = assert
    : e.Expr/render (class_ "Foo" [ t "w", n "v", f "f" ])
    ≡ "{{class:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- Class expr
let class1_
    : Text -> e.Expr -> e.Expr
    = \(cl : Text) -> \(expr : e.Expr) ->
    class_ cl [ expr ]

let test_class1_
    = assert
    : e.Expr/render (class1_ "Foo" (n "v"))
    ≡ "{{class:Foo}} {{var:v}}"


-- Class
let classE
    : Text -> e.Expr
    = \(cl : Text) ->
    class_ cl e.Expr/none -- ≡ E.Single (e.What.Class cl)

let test_classE
    = assert
    : e.Expr/render (classE "foo")
    ≡ "{{class:foo}}"


-- fn expr1 expr2 ...
let call_
    : Text -> List e.Expr -> e.Expr
    = \(fn : Text) -> \(args : List e.Expr) ->
    apw_ (e.What.Function fn) args

let test_call_
    = assert
    : e.Expr/render (call_ "foobar" [ t "w", n "v", f "f" ])
    ≡ "{{method:foobar}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- fn expr1
let call1_
    : Text -> e.Expr -> e.Expr
    = \(fn : Text) -> \(var : e.Expr) ->
    call_ fn [ var ]

let test_call1_
    = assert
    : e.Expr/render (call1_ "foobar" (n "v"))
    ≡ "{{method:foobar}} {{var:v}}"


-- fn
let callE
    : Text -> e.Expr
    = \(fn : Text) ->
    call_ fn e.Expr/none -- ≡ E.Single (e.What.Function fn)

let test_callE
    = assert
    : e.Expr/render (callE "foobar")
    ≡ "{{method:foobar}}"


-- expr1 -> expr2 -> expr3 -> ...
let fn_
    : List e.Expr -> e.Expr
    = \(args : List e.Expr)
    -> e.Expr.FnTypeDef { items = e.Expr/sealAll args }

let test_fn_
    = assert
    : e.Expr/render (fn_ [ class_ "Foo" [ t "w", n "v", f "f" ], class_ "Bar" [ t "v", n "n" ], n "v", classE "Foo" ])
    ≡ "{{class:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}} {{op:->}} {{class:Bar}} {{typevar:v}} {{var:n}} {{op:->}} {{var:v}} {{op:->}} {{class:Foo}}"


-- expr1 -> expr2
let fn2
    : e.Expr -> e.Expr -> e.Expr
    = \(expr1 : e.Expr) -> \(expr2 : e.Expr)
    -> fn_ [ expr1, expr2 ]

let test_fn2
    = assert
    : e.Expr/render (fn2 (class_ "Bar" [ t "v", n "n" ]) (n "v"))
    ≡ "{{class:Bar}} {{typevar:v}} {{var:n}} {{op:->}} {{var:v}}"


-- expr1 -> expr2 -> expr3
let fn3
    : e.Expr -> e.Expr -> e.Expr -> e.Expr
    = \(expr1 : e.Expr) -> \(expr2 : e.Expr) -> \(expr3 : e.Expr)
    -> fn_ [ expr1, expr2, expr3 ]

let test_fn3
    = assert
    : e.Expr/render (fn3 (classE "Foo") (class_ "Bar" [ t "v", n "n" ]) (n "v"))
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
    : e.Expr/render (mdef "buz" [ class_ "Bar" [ t "v", n "n" ], classE "Foo", n "v" ])
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
    : e.Expr/render (req [ class_ "Bar" [ t "v", n "n" ], classE "Foo", n "v" ] (class1_ "Foo" (n "v")))
    ≡ "({{class:Bar}} {{typevar:v}} {{var:n}}, {{class:Foo}}, {{var:v}}) {{op:=>}} {{class:Foo}} {{var:v}}"


-- req1 => req2 => ... => what
let reqseq
    : List e.Expr -> e.Expr -> e.Expr
    = \(reqs : List e.Expr) -> \(what : e.Expr)
    -> e.Expr.ConstrainedSeq { constraints = e.Expr/sealAll reqs, expr = e.Expr/seal what }
let test_reqseq
    = assert
    : e.Expr/render (reqseq [ class_ "Bar" [ t "v", n "n" ], classE "Foo", n "v" ] (class1_ "Foo" (n "v")))
    ≡ "{{class:Bar}} {{typevar:v}} {{var:n}} {{op:=>}} {{class:Foo}} {{op:=>}} {{var:v}} {{op:=>}} {{class:Foo}} {{var:v}}"


-- req => what
let req1
    : e.Expr -> e.Expr -> e.Expr
    = \(req : e.Expr) -> \(what : e.Expr) ->
    reqseq [ req ] what
let test_req1
    = assert
    : e.Expr/render (req1 (class_ "Bar" [ t "v", n "n" ]) (class1_ "Foo" (n "v")))
    ≡ "{{class:Bar}} {{typevar:v}} {{var:n}} {{op:=>}} {{class:Foo}} {{var:v}}"


in
    {
    }