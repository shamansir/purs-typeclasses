let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let void : tc.TClass =
    { id = "void"
    , name = "Void"
    , what = tc.What.Newtype_
    , info = "Uninhabited data type"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Void"
    , members =
        [
            { name = "absurd"
            , def = e.fn2 (e.subjE "Void") (e.n "a") -- Void -> a
            , belongs = tc.Belongs.No
            , op = tc.noOp
            , opEmoji = Some "💣"
            } /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Show" "Void"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements /\ tc.noVars

in void