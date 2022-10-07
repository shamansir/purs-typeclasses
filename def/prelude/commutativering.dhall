let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let commutativeRing : tc.TClass =
    { id = "commutativering"
    , name = "CommutativeRing"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "ring" ]
    , info = "Multiplication behaves commutatively"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.CommutativeRing"
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

    } /\ tc.noMembers /\ tc.noValues /\ tc.noStatements

in commutativeRing