let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class (Semiring a) <= Ring a where

let ring : tc.TClass =
    { id = "ring"
    , name = "Ring"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "semiring" ]
    , info = "Subtraction"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Ring"
    , spec =
        d.class_vp
            (d.id "ring")
            "Ring"
            [ d.v "a" ]
            [ d.p (d.id "semiring") "Semiring" [ d.v "a" ] ]
    , members =
        [
            { name = "sub"
            , def = e.fn3 (e.n "a") (e.n "a") (e.n "a") -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "-"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "Additive inverse"
                    , examples =
                        [ tc.lmr
                            { left =  e.opc2 (e.n "a") "-" (e.n "a") -- a - a
                            , middle = e.opc2 (e.callE "zero") "-" (e.n "a") -- zero - a
                            , right = e.callE "zero" -- zero
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ,
            { name = "negate"
            , def =
                e.req1
                    (e.subj1 "Ring" (e.n "a"))
                    (e.fn2 (e.n "a") (e.n "a"))
                -- Ring a => a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        , i.instanceCl "Unit"
        , i.instanceReqSubjArrow "Ring"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in ring