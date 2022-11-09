let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- data Unit

let unit : tc.TClass =
    { spec = d.data_ce (d.id "unit") "Unit" d.t1
    , info = "No computation needed"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "unit"
            , def = e.subjE "Unit" -- Unit -- data Unit :: Type
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Show" "Unit"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in unit