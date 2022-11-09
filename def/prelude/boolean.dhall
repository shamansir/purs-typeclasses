let tc = ./../../typeclass.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

let boolean : tc.TClass =
    { spec = d.int (d.id "boolean") "Boolean"
    , info = "Helpers for boolean types"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "otherwise"
            , def = e.classE "Boolean"
            , belongs = tc.Belongs.No
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]

    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in boolean