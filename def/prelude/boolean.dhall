let tc = ./../../typeclass.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

let boolean : tc.TClass =
    { id = "boolean"
    , name = "Boolean"
    , what = tc.What.Internal_
    , info = "Helpers for boolean types"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Boolean"
    , spec = d.int (d.id "boolean") "Boolean"
    , members =
        [
            { name = "otherwise"
            , def = e.classE "Boolean"
            , belongs = tc.Belongs.No
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]

    } /\ tc.noInstances /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements /\ tc.noVars

in boolean