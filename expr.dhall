-- let Text/concatMapSep =
--     https://prelude.dhall-lang.org/Text/concatMapSep

let Text/concatSep =
    https://prelude.dhall-lang.org/Text/concatSep

let List/map =
    https://prelude.dhall-lang.org/List/map


{- Expression builder -}

let tt = \(text : Text) -> Text/replace "  " " " text


let SealedExpr =
    < Source : Text
    >


let SealedExpr/unseal
    : SealedExpr -> Text
    = \(re : SealedExpr) ->
    merge
        { Source = \(text : Text) -> text
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


let concatExprs
    : Text -> List SealedExpr -> Text
    = \(sep : Text) -> \(res : List SealedExpr) ->
        Text/concatSep sep (SealedExpr/unsealAll res)


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


let concatArgs
    : Text -> List Arg -> Text
    = \(sep : Text) -> \(args : List Arg) ->
        Text/concatSep sep (List/map Arg Text Arg/render args)


let Apply_ = { what : What, arguments : List SealedExpr }


let ApplyExp_ = { items : List SealedExpr }


let OperatorCall_ = { left : SealedExpr, op : Text, right : SealedExpr }


let Brackets_ = SealedExpr


let Var_ = Text


let Operator_ = Text


let LetExpr_ = { bindings : List { what : Text, to : SealedExpr }, _in : SealedExpr }


let Constrained_ = { constraints : List SealedExpr, expr : SealedExpr }


let ConstrainedSeq_ = { constraints : List SealedExpr, expr : SealedExpr }


let FnTypeDef_ = { items : List SealedExpr }


let FnDef_ = { fn : Text, items : List SealedExpr }


let Lambda_ = { args : List Arg, body : SealedExpr }


let Expr =
    < Apply : Apply_
    | ApplyExp : ApplyExp_
    | FnTypeDef : FnTypeDef_
    | FnDef : FnDef_
    | OperatorCall : OperatorCall_
    | Brackets : Brackets_
    | LetExpr : LetExpr_
    -- | IfElse :
    | Single : What
    | Var : Var_
    | Operator : Operator_
    | Constrained : Constrained_
    | ConstrainedSeq : ConstrainedSeq_
    | Lambda_ : Lambda_
    | PH
    | Raw : Text
    | Num : Text
    | Nothing
    >


let hasNone
    = \(t : Type) -> \(list : List t) -> Natural/isZero (List/length t list)


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
        , OperatorCall
            =  \(oc : OperatorCall_)
            -> tt "${SealedExpr/unseal oc.left} {{op:${oc.op}}} ${SealedExpr/unseal oc.right}"
        , Brackets
            = \(expr : Brackets_)
            -> "(${SealedExpr/unseal expr})"
        , LetExpr
            =  \(le : LetExpr_)
            -> "" -- FIXME
        , Var
            =  \(v : Var_)
            -> "{{var:${v}}}"
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
        , Lambda_
            =  \(lambda : Lambda_)
            -> tt "\\${concatArgs " " lambda.args} {{op:->}} ${SealedExpr/unseal lambda.body}"
        , PH = "{{var:_}}"
        , Raw = \(raw : Text) -> raw
        , Num = \(num : Text) -> "{{num:${num}}}"
        , Nothing = ""
        }
        expr


let Expr/seal
    : Expr -> SealedExpr
    = \(expr : Expr) -> SealedExpr.Source (Expr/render expr)


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


in
    { What, Arg, Expr
    , What/render, Arg/render, Expr/render, Expr/seal, Expr/sealAll, Expr/none
    }