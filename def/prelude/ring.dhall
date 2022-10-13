let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

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
            }
        ,
            { name = "negate"
            , def =
                e.req1
                    (e.subj1 "Ring" (e.n "a"))
                    (e.fn2 (e.n "a") (e.n "a"))
                -- Ring a => a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        , i.instanceCl "Unit"
        , i.instanceReqSubjArrow "Ring"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in ring