let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall


-- class (Ord a) <= Bounded a where

let bounded : tc.TClass =
    { spec =
        d.class_vp
            (d.id "bounded")
            "Bounded"
            [ d.v "a" ]
            [ d.p (d.id "ord") "Ord" [ d.v "a" ] ]
    , info = "Have upper and lower boundary"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , laws =
        [
            { law = "bounded"
            , examples =
                [ tc.of
                    { fact =
                        e.opc3 (e.callE "bottom") "<=" (e.n "a") "<=" (e.callE "top")
                        -- bottom <= a <= top
                    }
                ]
            }

        ]
    , members =
        [
            { name = "top"
            , def = e.n "a"
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bottom"
            , def = e.n "a"
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Int"
        , i.instanceCl "Char"
        , i.instanceCl "Ordering"
        , i.instanceCl "Unit"
        ]

    } /\ tc.aw /\ tc.noValues /\ tc.noStatements

in bounded