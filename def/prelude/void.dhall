let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Void

let void : tc.TClass =
    { spec = d.nt_e (d.id "void") "Void"
    , info = "Uninhabited data type"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "absurd"
            , def = e.fn2 (e.subjE "Void") (e.n "a") -- Void -> a
            , belongs = tc.Belongs.No
            , op = tc.noOp
            , opEmoji = Some "💣"
            } /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Show" "Void"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in void