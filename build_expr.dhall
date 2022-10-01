let Text/concatMapSep =
    https://prelude.dhall-lang.org/Text/concatMapSep


{- Expression builder -}

let tt = \(text : Text) -> Text/replace "  " " " text


let RenderedExpr = Text {-
    < Norm : Text
    | FVar : Text
    | TypeVar : Text
    | Raw : Text
    | RawBr : Text
    | PH
    > -}


let ApplyWhat =
    < Subject : Text
    | Class : Text
    | Function : Text
    | Type_ : Text
    -- | Constructor : Text
    | Constraint : Text
    >


let Apply_ = { what : ApplyWhat, arguments : List RenderedExpr }


let OperatorCall_ = { left : RenderedExpr, op : Text, right : RenderedExpr }


let Brackets_ = RenderedExpr


let Var_ = Text


let Operator_ = Text


let LetExpr_ = { bindings : List { what : Text, to : RenderedExpr }, _in : RenderedExpr }


let Constrained_ = { constraints : List RenderedExpr, expr : RenderedExpr }


let TypeDef_ = { items : List RenderedExpr }


let Expr =
    < Apply : Apply_
    | TypeDef : TypeDef_
    -- | Var : Var
    | OperatorCall : OperatorCall_
    | Brackets : Brackets_
    | LetExpr : LetExpr_
    -- | IfElse :
    | Var : Var_
    | Operator : Operator_
    | Constrained : Constrained_
    | PH
    >


-- let Infix = { op : Op_, left : Value, right : Value }


let noVarsE = [] : List Var

let var
    : Var -> Text
    = \(var : Var) ->
    merge
        { Norm = \(v : Text) -> "{{var:${v}}}"
        , FVar = \(f : Text) -> "{{fvar:${f}}}"
        , TypeVar = \(t : Text) -> "{{typevar:${t}}}"
        , Raw = \(r : Text) -> r
        , RawBr = \(r : Text) -> "(${r})"
        , PH = "{{var:_}}"
        }
        var

let val
    : Value -> Text
    = \(val : Value) ->
    merge
        { Class = \(c : Class_) -> "{{class:${c.cl}}} ${Text/concatMapSep " " Var var c.vars}"
        , Subj = \(s : Subj_) -> "{{subj:${s.subj}}} ${Text/concatMapSep " " Var var s.vars}"
        , Ap = \(a : Ap_) -> "${var a.what} ${Text/concatMapSep " " Var var a.vars}"
        , Call = \(c : Call_) -> "{{method:${c.method}}} ${Text/concatMapSep " " Var var c.vars}"
        , Var = \(v : Var) -> var v
        , Op = \(o : Text) -> "({{op:${o}}})"
        , Fn = \(fn : Fn_) -> tt "(${Text/concatMapSep " {{op:->}} " Var var fn.items})"
        }
        val


{- TO VAR -}

let ph
    : Var
    = Var.PH

-- norm Var: a, b etc.
let n
    : Text -> Var
    = \(v : Text) -> Var.Norm v

let testN = assert : var (n "v") ≡ "{{var:v}}"

-- functor-style Var: f, g, m, ...
let f
    : Text -> Var
    = \(f : Text) -> Var.FVar f

-- type-style Var: w, t, m, ...
let t
    : Text -> Var
    = \(t : Text) -> Var.TypeVar t

-- raw text Var
let r
    : Text -> Var
    = \(r : Text) -> Var.Raw r

-- (raw text) Var
let rbr
    : Text -> Var
    = \(r : Text) -> Var.RawBr r

-- raw text Var from Value
let rv
    : Value -> Var
    = \(rv : Value) -> Var.Raw (val rv)

-- (raw text) Var from Value
let rbrv
    : Value -> Var
    = \(rbrv : Value) -> Var.RawBr (val rbrv)


{- TO VALUE -}

-- Subject var1 var2 ...
let subj_
    : Text -> List Var -> Value
    = \(subj : Text) -> \(vars : List Var) ->
    Value.Subj { subj, vars }

-- Subject
let subjE
    : Text -> Value
    = \(subj : Text) ->
    Value.Subj { subj, vars = noVarsE }

-- Subect var
let subj1_
    : Text -> Var -> Value
    = \(subj : Text) -> \(var : Var) ->
    Value.Subj { subj, vars = [ var ]}

-- Class var1 var2 ...
let class_
    : Text -> List Var -> Value
    = \(cl : Text) -> \(vars : List Var) ->
    Value.Class { cl, vars }

-- Class var
let class1_
    : Text -> Var -> Value
    = \(cl : Text) -> \(var : Var) ->
    Value.Class { cl, vars = [ var ]}

-- Class
let classE
    : Text -> Value
    = \(cl : Text) ->
    Value.Class { cl, vars = noVarsE }

-- what var1 var2 ...
let ap_
    : Var -> List Var -> Value
    = \(what : Var) -> \(vars : List Var) -> Value.Ap { what, vars }


-- what var1
let ap1_
    : Var -> Var -> Value
    = \(what : Var) -> \(var : Var) -> Value.Ap { what, vars = [ var ]  }


-- method var1 var2 ...
let call_
    : Text -> List Var -> Value
    = \(method : Text) -> \(vars : List Var) -> Value.Call { method, vars }


-- method var
let call1_
    : Text -> Var -> Value
    = \(method : Text) -> \(var : Var) -> Value.Call { method, vars = [ var ]}


-- method
let callE
    : Text -> Value
    = \(method : Text) -> Value.Call { method, vars = noVarsE }

-- var1 -> var2 -> var3 -> ...
let fn_
    : List Var -> Value
    = \(items : List Var) -> Value.Fn { items }


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