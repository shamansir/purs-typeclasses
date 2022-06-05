let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let unit : tc.TClass =
    { id = "unit"
    , name = "Unit"
    , what = tc.What.Type_ -- data Unit :: Type
    , info = "No computation needed"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Unit"
    , members =
        [
            { name = "unit"
            , def = "{{subj:Unit}}" -- Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Show" "Unit"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements /\ tc.noVars

in unit