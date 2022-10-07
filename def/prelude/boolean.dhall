let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

let boolean : tc.TClass =
    { id = "boolean"
    , name = "Boolean"
    , what = tc.What.Internal_
    , info = "Helpers for boolean types"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Boolean"
    , members =
        [
            { name = "otherwise"
            , def = e.classE "Boolean"
            , belongs = tc.Belongs.No
            } /\ tc.noLaws /\ tc.noOps
        ]

    } /\ tc.noInstances /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements /\ tc.noVars

in boolean