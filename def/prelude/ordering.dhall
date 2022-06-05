let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let ordering : tc.TClass =
    { id = "ordering"
    , name = "Ordering"
    , what = tc.What.Data_
    , values = [ "LT", "GT", "EQ" ]
    , info = "Just to know the order"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Ordering"
    , members =
        [
            { name = "invert"
            , def = "{{class:Ordering}} {{op:->}} {{class:Ordering}}" -- Ordering -> Ordering
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Eq" "Ordering"
        , i.instance "Semigroup" "Ordering"
        , i.instance "Show" "Ordering"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noVars

in ordering