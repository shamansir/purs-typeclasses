let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class (HeytingAlgebra a) <= BooleanAlgebra a

let booleanAlgebra : tc.TClass =
    { spec =
        d.class_vp
            (d.id "booleanalgebra")
            "BooleanAlgebra"
            [ d.v "a" ]
            [ d.p (d.id "heytingalgebra") "HeytingAlgebra" [ d.v "a" ] ]
    , info = "Behave like boolean"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
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

    } /\ tc.aw /\ tc.noMembers /\ tc.noValues /\ tc.noStatements

in booleanAlgebra