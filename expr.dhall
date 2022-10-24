-- let Text/concatMapSep =
--     https://prelude.dhall-lang.org/Text/concatMapSep

let Text/concatSep =
    https://prelude.dhall-lang.org/Text/concatSep

let List/map =
    https://prelude.dhall-lang.org/List/map


{- Expression builder -}

let tt = \(text : Text) -> Text/replace "  " " " text


let SealedSource = { markdown : Text, raw : Text }


let SealedExpr =
    < Source : SealedSource
    >


let SealedExpr/getSource
    : SealedExpr -> SealedSource
    = \(re : SealedExpr) ->
    merge
        { Source = \(src : SealedSource) -> src
        }
        re


let SealedExpr/unseal
    : SealedExpr -> Text
    = \(re : SealedExpr) ->
    merge
        { Source = \(text : SealedSource) -> text.markdown
        }
        re


let SealedExpr/unsealRaw
    : SealedExpr -> Text
    = \(re : SealedExpr) ->
    merge
        { Source = \(text : SealedSource) -> text.raw
        }
        re


let SealedExpr/unsealAll
    : List SealedExpr -> List Text
    = \(res : List SealedExpr) ->
    List/map
        SealedExpr
        Text
        SealedExpr/unseal
        res


let SealedExpr/unsealAllRaw
    : List SealedExpr -> List Text
    = \(res : List SealedExpr) ->
    List/map
        SealedExpr
        Text
        SealedExpr/unsealRaw
        res


let concatHelper
    : forall(a : Type) -> (a -> Text) -> Text -> List a -> Text
    = \(a : Type) -> \(render : a -> Text) -> \(sep : Text) -> \(res : List a) ->
        Text/concatSep sep (List/map a Text render res)


let concatExprs
    : Text -> List SealedExpr -> Text
    = \(sep : Text) -> \(res : List SealedExpr) ->
        concatHelper SealedExpr SealedExpr/unseal sep res


let concatExprsRaw
    : Text -> List SealedExpr -> Text
    = \(sep : Text) -> \(res : List SealedExpr) ->
        concatHelper SealedExpr SealedExpr/unsealRaw sep res


let What =
    < Subject : Text
    | Class : Text
    | Function : Text
    | Type_ : Text
    | FVar : Text -- TODO: rename
    -- | Constructor : Text
    | Constraint : Text
    >


let What/render
    : What -> Text
    = \(aw : What) ->
    merge
        { Subject = \(subj : Text) -> "{{subj:${subj}}}"
        , Class = \(class : Text) -> "{{class:${class}}}"
        , Function = \(fn : Text) -> "{{method:${fn}}}"
        , Type_ = \(type : Text) -> "{{typevar:${type}}}"
        , FVar = \(fvar : Text) -> "{{fvar:${fvar}}}"
        , Constraint = \(cns : Text) -> "{{class:${cns}}}"
        }
        aw


let What/renderRaw
    : What -> Text
    = \(aw : What) ->
    merge
        { Subject = \(subj : Text) -> subj
        , Class = \(class : Text) -> class
        , Function = \(fn : Text) -> fn
        , Type_ = \(type : Text) -> type
        , FVar = \(fvar : Text) -> fvar
        , Constraint = \(cns : Text) -> cns
        }
        aw


let Arg =
    < VarArg : Text
    >


let Arg/render
    : Arg -> Text
    = \(arg : Arg) ->
    merge
        { VarArg = \(var : Text) -> "{{var:${var}}}"
        }
        arg


let Arg/renderRaw
    : Arg -> Text
    = \(arg : Arg) ->
    merge
        { VarArg = \(var : Text) -> var
        }
        arg


let concatArgs
    : Text -> List Arg -> Text
    = \(sep : Text) -> \(args : List Arg) ->
        concatHelper Arg Arg/render sep args


let concatArgsRaw
    : Text -> List Arg -> Text
    = \(sep : Text) -> \(args : List Arg) ->
        concatHelper Arg Arg/renderRaw sep args



let Apply_ = { what : What, arguments : List SealedExpr }
let ApplyExp_ = { items : List SealedExpr }
let OperatorCall_ = { left : SealedExpr, op : Text, right : SealedExpr }
let InfixMethodCall_ = { left : SealedExpr, method : Text, right : SealedExpr }
let Brackets_ = SealedExpr
let Var_ = Text
let Val_ = Text
let Operator_ = Text
let Binding = { what : Arg, to : SealedExpr }
let LetExpr_ = { bindings : List Binding, _in : SealedExpr }
let Constrained_ = { constraints : List SealedExpr, expr : SealedExpr }
let ConstrainedSeq_ = { constraints : List SealedExpr, expr : SealedExpr }
let FnTypeDef_ = { items : List SealedExpr }
let FnDef_ = { fn : Text, items : List SealedExpr }
let OpDef_ = { op : Text, items : List SealedExpr }
let Lambda_ = { args : List Arg, body : SealedExpr }
let Forall_ = { args : List Arg, body : SealedExpr }
let Property = { mapKey : Text, mapValue : SealedExpr }
let Object_ = List Property


let CItem =
    < CType
    | CVar : Arg
    | CKind
    | CConstraint
    | CFn : List SealedExpr
    | CForall : Forall_
    | CBr : SealedExpr
    >


let Expr =
    < Apply : Apply_
    | ApplyExp : ApplyExp_
    | FnTypeDef : FnTypeDef_
    | FnDef : FnDef_
    | OpDef : OpDef_
    | OperatorCall : OperatorCall_
    | InfixMethodCall : InfixMethodCall_
    | Brackets : Brackets_
    | LetExpr : LetExpr_
    -- | IfElse :
    | Single : What
    | Var : Var_
    | Val : Val_
    | Operator : Operator_
    | Constrained : Constrained_
    | ConstrainedSeq : ConstrainedSeq_
    | Lambda : Lambda_
    | Forall : Forall_
    | PH
    | Raw : Text
    | Num : Text
    | Keyword : Text
    | Object : Object_
    -- | Constraint : Constraint_
    | ConstraintItem : CItem
    | Nothing
    >


let hasNone
    = \(t : Type) -> \(list : List t) -> Natural/isZero (List/length t list)


let CItem/render
    : CItem -> Text
    = \(citem : CItem) ->
    merge
        { CType = "{{kw:Type}}"
        , CConstraint = "{{kw:Constraint}}"
        , CKind = "{{kw:Kind}}"
        , CVar = \(arg : Arg) -> "{{${Arg/render arg}}}"
        , CFn = \(items : List SealedExpr) -> "${concatExprs " {{op:->}} " items}"
        , CBr = \(expr : SealedExpr) -> "(${SealedExpr/unseal expr})"
        , CForall
            =  \(forall_ : Forall_)
            -> tt "{{kw:forall}} ${concatArgs " " forall_.args}. ${SealedExpr/unseal forall_.body}"
        }
        citem


let CItem/renderRaw
    : CItem -> Text
    = \(citem : CItem) ->
    merge
        { CType = "Type"
        , CConstraint = "Constraint"
        , CKind = "Kind"
        , CVar = \(arg : Arg) -> Arg/renderRaw arg
        , CFn = \(items : List SealedExpr) -> concatExprsRaw " -> " items
        , CBr = \(expr : SealedExpr) -> "(${SealedExpr/unsealRaw expr})"
        , CForall
            =  \(forall_ : Forall_)
            -> tt "kw:forall ${concatArgsRaw " " forall_.args}. ${SealedExpr/unsealRaw forall_.body}"
        }
        citem


let CItem/toExpr
    : CItem -> Expr
    = Expr.ConstraintItem


let concatCItems
    : Text -> List CItem -> Text
    = \(sep : Text) -> \(citems : List CItem) ->
        concatHelper CItem CItem/render sep citems


let concatCItemsRaw
    : Text -> List CItem -> Text
    = \(sep : Text) -> \(citems : List CItem) ->
        concatHelper CItem CItem/renderRaw sep citems


let Expr/render
    : Expr -> Text
    = \(expr : Expr) ->
    merge
        { Apply
            =  \(ap : Apply_)
            -> if (hasNone SealedExpr ap.arguments) then What/render ap.what
                else "${What/render ap.what} ${concatExprs " " ap.arguments}"
        , ApplyExp
            =  \(ap : ApplyExp_)
            -> concatExprs " " ap.items
        , FnTypeDef
            =  \(td : FnTypeDef_)
            -> tt "${concatExprs " {{op:->}} " td.items}"
        , FnDef
            =  \(td : FnDef_)
            -> tt "{{method:${td.fn}}} {{op:::}} ${concatExprs " {{op:->}} " td.items}"
        , OpDef
            =  \(td : OpDef_)
            -> tt "({{op:${td.op}}}) {{op:::}} ${concatExprs " {{op:->}} " td.items}"
        , OperatorCall
            =  \(oc : OperatorCall_)
            -> tt "${SealedExpr/unseal oc.left} {{op:${oc.op}}} ${SealedExpr/unseal oc.right}"
        , InfixMethodCall
            =  \(imc : InfixMethodCall_)
            -> tt "${SealedExpr/unseal imc.left} `{{method:${imc.method}}}` ${SealedExpr/unseal imc.right}"
        , Brackets
            = \(expr : Brackets_)
            -> "(${SealedExpr/unseal expr})"
        , LetExpr
            =  \(le : LetExpr_)
            -> let Binding/render = \(b : Binding) -> "${Arg/render b.what} {{op:=}} ${SealedExpr/unseal b.to}"
               in tt "{{kw:let}} {{break}} ${concatHelper Binding Binding/render "{{break}}" le.bindings} {{break}} {{kw:in}}{{break}} ${SealedExpr/unseal le._in}"
        , Var
            =  \(v : Var_)
            -> "{{var:${v}}}"
        , Val
            =  \(v : Val_)
            -> "{{val:${v}}}"
        , Single
            =  \(aw : What)
            -> What/render aw
        , Operator
            =  \(o : Operator_)
            -> "{{op:${o}}}"
        , Constrained
            =  \(cs : Constrained_)
            -> tt "(${concatExprs ", " cs.constraints}) {{op:=>}} ${SealedExpr/unseal cs.expr}"
        , ConstrainedSeq
            =  \(cs : Constrained_)
            -> tt "${concatExprs " {{op:=>}} " cs.constraints} {{op:=>}} ${SealedExpr/unseal cs.expr}"
        , Lambda
            =  \(lambda : Lambda_)
            -> tt "\\${concatArgs " " lambda.args} {{op:->}} ${SealedExpr/unseal lambda.body}"
        , Forall
            =  \(forall_ : Forall_)
            -> tt "{{kw:forall}} ${concatArgs " " forall_.args}. ${SealedExpr/unseal forall_.body}"
        , PH = "{{var:_}}"
        , Object
            =  \(obj_ : Object_)
            -> let Property/render = \(prop : Property) -> "${prop.mapKey} {{op:::}} ${SealedExpr/unseal prop.mapValue}"
               in tt "{ ${concatHelper Property Property/render ", " obj_} }"
        , Raw = \(raw : Text) -> raw
        , Num = \(num : Text) -> "{{num:${num}}}"
        , Keyword = \(kw : Text) -> "{{kw:${kw}}}"
        , ConstraintItem = \(citem : CItem) -> CItem/render citem
        , Nothing = ""
        }
        expr


let Expr/renderRaw
    : Expr -> Text
    = \(expr : Expr) ->
    merge
        { Apply
            =  \(ap : Apply_)
            -> if (hasNone SealedExpr ap.arguments) then What/render ap.what
                else "${What/renderRaw ap.what} ${concatExprsRaw " " ap.arguments}"
        , ApplyExp
            =  \(ap : ApplyExp_)
            -> concatExprsRaw " " ap.items
        , FnTypeDef
            =  \(td : FnTypeDef_)
            -> tt "${concatExprsRaw " -> " td.items}"
        , FnDef
            =  \(td : FnDef_)
            -> tt "${td.fn} :: ${concatExprsRaw " -> " td.items}"
        , OpDef
            =  \(td : OpDef_)
            -> tt "(${td.op}) :: ${concatExprsRaw " -> " td.items}"
        , OperatorCall
            =  \(oc : OperatorCall_)
            -> tt "${SealedExpr/unsealRaw oc.left} ${oc.op} ${SealedExpr/unsealRaw oc.right}"
        , InfixMethodCall
            =  \(imc : InfixMethodCall_)
            -> tt "${SealedExpr/unsealRaw imc.left} `${imc.method}` ${SealedExpr/unsealRaw imc.right}"
        , Brackets
            = \(expr : Brackets_)
            -> "(${SealedExpr/unsealRaw expr})"
        , LetExpr
            =  \(le : LetExpr_)
            -> let Binding/renderRaw = \(b : Binding) -> "${Arg/renderRaw b.what} = ${SealedExpr/unsealRaw b.to}"
               in tt "let {{break}} ${concatHelper Binding Binding/renderRaw "{{break}}" le.bindings} {{break}} in {{break}} ${SealedExpr/unsealRaw le._in}"
        , Var
            =  \(v : Var_)
            -> v
        , Val
            =  \(v : Val_)
            -> v
        , Single
            =  \(aw : What)
            -> What/renderRaw aw
        , Operator
            =  \(o : Operator_)
            -> o
        , Constrained
            =  \(cs : Constrained_)
            -> tt "(${concatExprsRaw ", " cs.constraints}) => ${SealedExpr/unsealRaw cs.expr}"
        , ConstrainedSeq
            =  \(cs : Constrained_)
            -> tt "${concatExprsRaw " => " cs.constraints} => ${SealedExpr/unsealRaw cs.expr}"
        , Lambda
            =  \(lambda : Lambda_)
            -> tt "\\${concatArgsRaw " " lambda.args} -> ${SealedExpr/unsealRaw lambda.body}"
        , Forall
            =  \(forall_ : Forall_)
            -> tt "forall ${concatArgsRaw " " forall_.args}. ${SealedExpr/unsealRaw forall_.body}"
        , PH = "_"
        , Object
            =  \(obj_ : Object_)
            -> let Property/renderRaw = \(prop : Property) -> "${prop.mapKey} :: ${SealedExpr/unsealRaw prop.mapValue}"
               in tt "{ ${concatHelper Property Property/renderRaw ", " obj_} }"
        , Raw = \(raw : Text) -> raw
        , Num = \(num : Text) -> num
        , Keyword = \(kw : Text) -> kw
        , ConstraintItem = \(citem : CItem) -> CItem/renderRaw citem
        , Nothing = ""
        }
        expr


let Expr/seal
    : Expr -> SealedExpr
    = \(expr : Expr) -> SealedExpr.Source { markdown = Expr/render expr, raw = Expr/renderRaw expr }


let Expr/sealAll
    : List Expr -> List SealedExpr
    = \(es : List Expr)
    -> List/map
        Expr
        SealedExpr
        Expr/seal
        es


let Expr/none
    = [] : List Expr


let SealedExpr/none
    = [] : List SealedExpr


let test_apply_1 = assert
    : Expr/render
        (Expr.Apply
            { what = What.Subject "foo"
            , arguments = [] : List SealedExpr
            }
        )
    ≡ "{{subj:foo}}"


let test_apply_2 = assert
    : Expr/render
        (Expr.Apply
            { what = What.Subject "foo"
            , arguments =
                [ Expr/seal (Expr.Var "a")
                , Expr/seal
                    (Expr.Single (What.Function "f"))
                ]
            }
        )
    ≡ "{{subj:foo}} {{var:a}} {{method:f}}"


let test_apply_raw = assert
    : Expr/renderRaw
        (Expr.Apply
            { what = What.Subject "foo"
            , arguments =
                [ Expr/seal (Expr.Var "a")
                , Expr/seal
                    (Expr.Single (What.Function "f"))
                ]
            }
        )
    ≡ "foo a f"

in
    { What, Arg, Property, CItem, Expr, SealedSource
    , Expr/seal, Expr/sealAll, SealedExpr/getSource, CItem/toExpr
    , What/render, Arg/render, CItem/render, Expr/render
    , What/renderRaw, Arg/renderRaw, CItem/renderRaw, Expr/renderRaw
    , Expr/none
    }