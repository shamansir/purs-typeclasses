let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let divisionRing : tc.TClass =
    { id = "divisionring"
    , name = "DivisionRing"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "ring" ]
    , info = "Non-zero rings in which every non-zero element has a multiplicative inverse / skew fields"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.DivisionRing"
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
                                e.inf2 (e.callE "one") "/=" (e.callE "zero") -- one /= zero
                            }
                        ]
                    }
                ,
                    { law = "Non-zero multplicative inverse"
                    , examples =
                        [ tc.lmr
                            { left =
                                e.inf2 (e.call1 "recip" (e.n "a")) "*" (e.n "a")
                                -- recip a * a
                            , middle =
                                e.inf2 (e.n "a") "*" (e.call1 "recip" (e.n "a"))
                                -- a * recip a
                            , right =
                                e.inf2
                                    (e.ap3 (e.callE "one") (e.kw "forall") (e.n "a"))
                                    "/="
                                    (e.num "0")
                                -- one forall a /= 0
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
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
            } /\ tc.noOps /\ tc.noLaws
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
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances = [ i.instanceSubj "Number" "DivisionRing" ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in divisionRing