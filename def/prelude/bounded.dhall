let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let bounded : tc.TClass =
    { id = "bounded"
    , name = "Bounded"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "ord" ]
    , info = "Have upper and lower boundary"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Bounded"
    , laws =
        [
            { law = "bounded"
            , examples =
                [ tc.of
                    { fact = "{{method:bottom}} {{op:<=}} {{var:a}} {{op:<=}} {{method:top}}" -- bottom <= a <= top
                    }
                ]
            }

        ]
    , members =
        [
            { name = "top"
            , def = "{{var:a}}" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bottom"
            , def = "{{var:a}}" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Int"
        , i.instanceCl "Char"
        , i.instanceCl "Ordering"
        , i.instanceCl "Unit"
        ]

    } /\ tc.noValues /\ tc.noStatements

in bounded