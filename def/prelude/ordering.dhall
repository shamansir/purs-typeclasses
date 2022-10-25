let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- data Ordering

let ordering : tc.TClass =
    { id = "ordering"
    , name = "Ordering"
    , what = tc.What.Data_
    , values = [ "LT", "GT", "EQ" ]
    , info = "Just to know the order"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Ordering"
    , spec = d.data_e (d.id "ordering") "Ordering"
    , members =
        [
            { name = "invert"
            , def = e.fn2 (e.classE "Ordering") (e.classE "Ordering") -- Ordering -> Ordering
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Eq" "Ordering"
        , i.instance "Semigroup" "Ordering"
        , i.instance "Show" "Ordering"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noVars

in ordering