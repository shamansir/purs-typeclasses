let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall


-- class (Ring a) <= CommutativeRing a

let commutativeRing : tc.TClass =
    { spec =
        d.class_vp
            (d.id "commutativering")
            "CommutativeRing"
            [ d.v "a" ]
            [ d.p (d.id "ring") "Ring" [ d.v "a" ] ]
    , info = "Multiplication behaves commutatively"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , laws =
        [
            { law = "commutative"
            , examples =
                [ tc.lr
                    { left = e.opc2 (e.n "a") "*" (e.n "b") -- a * b
                    , right = e.opc2 (e.n "b") "*" (e.n "a") -- b * a
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        , i.instanceCl "Unit"
        , i.instanceReqSubjArrow "CommutativeRing"
        ]

    } /\ tc.w 1.05 /\ tc.noMembers /\ tc.noValues /\ tc.noStatements

in commutativeRing