let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class (Ring a) <= DivisionRing a where

let divisionRing : tc.TClass =
    { spec =
        d.class_vp
            (d.id "divisionring")
            "DivisionRing"
            [ d.v "a" ]
            [ d.p (d.id "ring") "Ring" [ d.v "a" ] ]
    , info = "Non-zero rings in which every non-zero element has a multiplicative inverse / skew fields"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "recip"
            , def =
                e.fn2 (e.n "a") (e.n "a")
                -- a -> a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "Non-zero Ring"
                    , examples =
                        [ tc.of
                            { fact =
                                e.opc2 (e.callE "one") "/=" (e.callE "zero") -- one /= zero
                            }
                        ]
                    }
                ,
                    { law = "Non-zero multplicative inverse"
                    , examples =
                        [ tc.lmr
                            { left =
                                e.opc2 (e.call1 "recip" (e.n "a")) "*" (e.n "a")
                                -- recip a * a
                            , middle =
                                e.opc2 (e.n "a") "*" (e.call1 "recip" (e.n "a"))
                                -- a * recip a
                            , right =
                                e.opc2
                                    (e.ap3 (e.callE "one") (e.kw "forall") (e.n "a"))
                                    "/="
                                    (e.num "0")
                                -- one forall a /= 0
                            }
                        ]
                    }
                ]
            } /\ tc.noOps /\ tc.noExamples
        ,
            { name = "leftDiv"
            , def =
                e.req1
                    (e.subj1 "DivisionRing" (e.n "a"))
                    (e.fn3
                        (e.n "a")
                        (e.n "a")
                        (e.n "a")
                    )
                -- DivisionRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "rightDiv"
            , def =
                e.req1
                    (e.subj1 "DivisionRing" (e.n "a"))
                    (e.fn3
                        (e.n "a")
                        (e.n "a")
                        (e.n "a")
                    )
                -- DivisionRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances = [ i.instanceSubj "Number" "DivisionRing" ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in divisionRing