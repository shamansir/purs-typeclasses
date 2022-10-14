let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- data Unit

let unit : tc.TClass =
    { id = "unit"
    , name = "Unit"
    , what = tc.What.Type_ -- data Unit :: Type
    , info = "No computation needed"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Unit"
    , members =
        [
            { name = "unit"
            , def = e.subjE "Unit" -- Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Show" "Unit"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements /\ tc.noVars

in unit