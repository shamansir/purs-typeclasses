let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class (EuclideanRing a, DivisionRing a) <= Field a

let field : tc.TClass =
    { id = "field"
    , info = "Commutative fields"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "euclideanring", "divisionring" ]
    , name = "Field"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Field"
    , spec =
        d.class_vp
            (d.id "field")
            "Field"
            [ d.v "a" ]
            [ d.p (d.id "euclideanring") "EuclideanRing" [ d.v "a" ]
            , d.p (d.id "divisionring") "DivisionRing" [ d.v "a" ]
            ]
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

    } /\ tc.aw /\ tc.noValues /\ tc.noMembers /\ tc.noStatements

in field