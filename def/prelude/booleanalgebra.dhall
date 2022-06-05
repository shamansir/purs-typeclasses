let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let booleanAlgebra : tc.TClass =
    { id = "booleanalgebra"
    , name = "BooleanAlgebra"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "heytingalgebra" ]
    , info = "Behave like boolean"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.BooleanAlgebra"
    , laws =
        [
            { law = "excluded middle"
            , examples =
                [ tc.of
                    { fact = "{{var:a}} {{op:||}} {{method:not}} {{var:a}} {{op:==}} {{var:tt}}" -- a || not a == tt
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Unit"
        , i.instanceReqSubjArrow "BooleanAlgebra"
        ]

    } /\ tc.noMembers /\ tc.noValues /\ tc.noStatements

in booleanAlgebra