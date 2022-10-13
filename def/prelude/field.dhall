let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let field : tc.TClass =
    { id = "field"
    , info = "Commutative fields"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "euclidianring", "divisionring" ]
    , name = "Field"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Field"
    , laws =
        [
            { law = "non-zero multiplicative inverse"
            , examples = [
                tc.lr
                    { left = e.num "0" -- 0
                    , right = e.inf2 (e.n "a") "mod" (e.n "b") -- a `mod` b
                    }  --
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        ]

    } /\ tc.noValues /\ tc.noMembers /\ tc.noStatements

in field