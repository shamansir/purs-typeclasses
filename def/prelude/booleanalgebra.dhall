let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class (HeytingAlgebra a) <= BooleanAlgebra a

let booleanAlgebra : tc.TClass =
    { id = "booleanalgebra"
    , name = "BooleanAlgebra"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "heytingalgebra" ]
    , info = "Behave like boolean"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.BooleanAlgebra"
    , laws =
        [
            { law = "excluded middle"
            , examples =
                [ tc.of
                    { fact =
                        e.opc2 (e.opc2 (e.n "a") "||" (e.call1 "not" (e.n "a"))) "==" (e.n "tt")
                        -- a || not a == tt
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