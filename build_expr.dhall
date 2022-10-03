let e = ./expr.dhall


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

{-
-- raw text Var
let r
    : Text -> Var
    = \(r : Text) -> Var.Raw r
-}

{-
-- (raw text) Var
let rbr
    : Text -> Var
    = \(r : Text) -> Var.RawBr r
-}

{-
-- raw text Var from Value
let rv
    : Value -> Var
    = \(rv : Value) -> Var.Raw (val rv)
-}

{-
-- (raw text) Var from Value
let rbrv
    : Value -> Var
    = \(rbrv : Value) -> Var.RawBr (val rbrv)
-}


-- what var1 var2 ...
let ap_
    : e.What -> List e.Expr -> e.Expr
    = \(what : e.What) -> \(args : List e.Expr) ->
    e.Expr.Apply { what, arguments = e.Expr/sealAll args }

let test_ap_
    = assert
    : e.Expr/render (ap_ (e.What.FVar "f") [ t "w", n "v", f "f" ])
    ≡ "{{fvar:f}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- what var1
let ap1_
    : e.What -> e.Expr -> e.Expr
    = \(what : e.What) -> \(var : e.Expr) -> ap_ what [ var ]

let test_ap1_
    = assert
    : e.Expr/render (ap1_ (e.What.FVar "f") (n "v"))
    ≡ "{{fvar:f}} {{var:v}}"


-- what
let apE
    : e.What -> e.Expr
    = \(what : e.What) -> ap_ what e.Expr/none

let test_apE
    = assert
    : e.Expr/render (apE (e.What.FVar "f"))
    ≡ "{{fvar:f}}"


-- Subject expr1 expr2 ...
let subj_
    : Text -> List e.Expr -> e.Expr
    = \(subj : Text) -> \(args : List e.Expr) ->
    ap_ (e.What.Subject subj) args

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


-- Subject var
let subj1_
    : Text -> e.Expr -> e.Expr
    = \(subj : Text) -> \(var : e.Expr) ->
    subj_ subj [ var ]

let test_subj1_
    = assert
    : e.Expr/render (subj1_ "Foo" (n "v"))
    ≡ "{{subj:Foo}} {{var:v}}"


-- Class var1 var2 ...
let class_
    : Text -> List e.Expr -> e.Expr
    = \(cl : Text) -> \(args : List e.Expr) ->
    ap_ (e.What.Class cl) args

let test_class_
    = assert
    : e.Expr/render (class_ "Foo" [ t "w", n "v", f "f" ])
    ≡ "{{class:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- Class var
let class1_
    : Text -> e.Expr -> e.Expr
    = \(cl : Text) -> \(var : e.Expr) ->
    class_ cl [ var ]

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


-- fn var1 var2 ...
let call_
    : Text -> List e.Expr -> e.Expr
    = \(fn : Text) -> \(args : List e.Expr) ->
    ap_ (e.What.Function fn) args

let test_call_
    = assert
    : e.Expr/render (call_ "foobar" [ t "w", n "v", f "f" ])
    ≡ "{{method:foobar}} {{typevar:w}} {{var:v}} {{fvar:f}}"


-- method var
let call1_
    : Text -> e.Expr -> e.Expr
    = \(fn : Text) -> \(var : e.Expr) ->
    call_ fn [ var ]

let test_call1_
    = assert
    : e.Expr/render (call1_ "foobar" (n "v"))
    ≡ "{{method:foobar}} {{var:v}}"


-- method
let callE
    : Text -> e.Expr
    = \(fn : Text) ->
    call_ fn e.Expr/none -- ≡ E.Single (e.What.Function fn)

let test_callE
    = assert
    : e.Expr/render (callE "foobar")
    ≡ "{{method:foobar}}"


-- var1 -> var2 -> var3 -> ...
let fn_
    : List e.Expr -> e.Expr
    = \(args : List e.Expr)
    -> e.Expr.FnTypeDef { items = e.Expr/sealAll args }

let test_fn_
    = assert
    : e.Expr/render (fn_ [ class_ "Foo" [ t "w", n "v", f "f" ], class_ "Bar" [ t "v", n "n" ], n "v", classE "Foo" ])
    ≡ "{{class:Foo}} {{typevar:w}} {{var:v}} {{fvar:f}} -> {{class:Bar}} {{typevar:v}} {{var:n}} -> {{var:v}} -> {{class:Foo}}"


{-
-- Var as a Value
let v
    : Var -> Value
    = \(v: Var) -> Value.Var v

-- Norm Var as a Value
let vn
    : Text -> Value
    = \(vn : Text) -> v (n vn)

-- Func Var as a Value
let vf
    : Text -> Value
    = \(vf : Text) -> v (f vf)

-- Type Var as a Value
let vt
    : Text -> Value
    = \(vt : Text) -> v (t vt)

-- raw text as Value
let rtv
    : Text -> Value
    = \(r_ : Text) ->  Value.Var (r r_)

-- (raw text) as Value
let rtvbr
    : Text -> Value
    = \(r_ : Text) ->  Value.Var (rbr r_)

-- operator value
let op
    : Text -> Value
    = \(o: Text) -> Value.Op o
-}


{- TO TEXT -}

-- value1 value2
let ap
    : Value -> Value -> Text
    = \(value1 : Value) -> \(value2 : Value) -> tt "${val value1} ${val value2}"

-- (value1 value2)
let apBr
    : Value -> Value -> Text
    = \(value1 : Value) -> \(value2 : Value) -> tt "(${ap value1 value2})"

-- value1 value2 value3
let ap3
    : Value -> Value -> Value -> Text
    = \(value1 : Value) -> \(value2 : Value) -> \(value3 : Value) -> tt "${val value1} ${val value2} ${val value3}"

-- (value1 value2 value3)
let ap2Br
    : Value -> Value -> Value -> Text
    = \(value1 : Value) -> \(value2 : Value) -> \(value3 : Value) -> tt "(${val value1} ${val value2} ${val value3})"

-- value1 -> value2
let fn
    : Value -> Value -> Text
    = \(value1 : Value) -> \(value2 : Value) -> tt "${val value1} {{op:->}} ${val value2}"

-- value1 -> value2 -> value3
let fn3
    : Value -> Value -> Value -> Text
    = \(value1 : Value) -> \(value2 : Value) -> \(value3 : Value) -> tt "${val value1} {{op:->}} ${val value2} {{op:->}} ${val value3}"

-- left op right ~~> Text
let inf
    : Op_ -> Value -> Value -> Text
    = \(op: Op_) -> \(left : Value) -> \(right : Value) -> tt "${val left} {{op:${op}}} ${val right}"

-- value1 -> value2 -> value3 -> ...
let fnvs
    : List Value -> Text
    = \(items : List Value) ->
    -- val (Value.Fn { items })
    tt "${Text/concatMapSep " {{op:->}} " Value val items}"

-- (value1 -> value2)
let fnBr
    : Value -> Value -> Text
    = \(value1 : Value) -> \(value2 : Value) -> tt "(${fn value1 value2})"

-- method :: def
let mdef
    : Text -> Value -> Text
    = \(method : Text) -> \(def : Value) -> inf "::" (callE method) def

-- (text)
let br
    : Text -> Text
    = \(text : Text) -> "(${text})"

-- (val)
let brv
    : Value -> Text
    = \(val_ : Value) -> "(${val val_})"

-- (var)
let brvr
    : Var -> Text
    = \(var_ : Var) -> "(${var var_})"

-- (req1, req2, ...) => what
let req
    : List Value -> Value -> Text
    = \(reqs : List Value) -> \(what : Value) ->
    tt "(${Text/concatMapSep ", " Value val reqs}) {{op:=>}} ${val what}"

let req1
    : Value -> Value -> Text
    = \(req : Value) -> \(what : Value) ->
    tt "(${val req}) {{op:=>}} ${val what}"


in
    { Var, Class_, Subj_, Value
    , noVarsE
    , var, val
    , br, brv, brvr, rbr
    , ap, apBr, ap3, ap2Br, fn, fn3, fnvs, fnBr, req, req1, inf, mdef
    , subj_, subjE, subj1_, class_, class1_, classE, ap_, ap1_, call_, call1_, callE, fn_
    , ph, n, f, t, v, vn, vf, vt, r, rv, rbrv, op, rtv, rtvbr
    }