let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let extend : tc.TClass =
    { id = "extend"
    , name = "Extend"
    , what = tc.What.Class_
    , vars = [ "w" ]
    , info = "Extend local computation to a global one"
    , parents = [ "functor" ]
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.Extend"
    , members =
        [
            { name = "extend"
            , def =
                -- m a -> (a -> m b) -> m b
                e.fn3
                    (e.ap_ (e.t "m") [ e.n "a" ])
                    (e.rtv (e.fn (e.vn "a") (e.ap1_ (e.f "m") (e.n "a"))))
                    (e.ap_ (e.t "m") [ e.n "b" ])
            , belongs = tc.Belongs.Yes
            , op = Some "<<=="
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- extend f <<< extend g
                                e.inf
                                    "<<<"
                                    (e.call1_ "extend" (e.f "f"))
                                    (e.call1_ "extend" (e.f "g"))
                            , right =
                                -- extend (f <<< extend g)
                                e.val
                                    (e.call1_ "extend" (e.r
                                        (e.inf "<<<" (e.vf "f") (e.call1_ "extend" (e.f "g")))
                                    ))
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "extendFlipped"
            , def =
                 -- Extend w => w a -> (w a -> b) -> w b
                e.req1
                    (e.subj_ "Extend" [ e.t "w" ])
                    (e.rtv
                        (e.fnvs
                            [ e.ap1_ (e.t "w") (e.n "a")
                            , e.rtvbr (e.fn (e.ap1_ (e.t "w") (e.n "a")) (e.vn "b"))
                            , e.ap1_ (e.t "w") (e.n "b")
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            , op = Some "==>>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "composeCoKleisli"
            , def =
                -- Extend w => (w a -> b) -> (w b -> c) -> w a -> c
                e.req1
                    (e.subj_ "Extend" [ e.t "w" ])
                    (e.rtv
                        (e.fnvs
                            [ e.rtvbr (e.fn (e.ap1_ (e.t "w") (e.n "a")) (e.vn "b"))
                            , e.rtvbr (e.fn (e.ap1_ (e.t "w") (e.n "b")) (e.vn "c"))
                            , e.ap1_ (e.t "w") (e.n "a")
                            , e.vn "c"
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            , op = Some "=>="
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "composeCoKleisliFlipped"
            , def =
                -- Extend w => (w b -> c) -> (w a -> b) -> w a -> c
                e.req1
                    (e.subj_ "Extend" [ e.t "w" ])
                    (e.rtv
                        (e.fnvs
                            [ e.rtvbr (e.fn (e.ap1_ (e.t "w") (e.n "b")) (e.vn "c"))
                            , e.rtvbr (e.fn (e.ap1_ (e.t "w") (e.n "a")) (e.vn "b"))
                            , e.ap1_ (e.t "w") (e.n "a")
                            , e.vn "c"
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            , op = Some "=<="
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "duplicate"
            , def =
                -- Extend w => w a -> w (w a)
                e.req1
                    (e.subj_ "Extend" [ e.t "w" ])
                    (e.rtv
                        (e.fnvs
                            [ e.ap1_ (e.t "w") (e.n "a")
                            , e.ap1_ (e.t "w") (e.rbrv (e.ap1_ (e.t "w") (e.n "a")))
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [  -- Semigroup w => Extend ((->) w)
          e.req1
            (e.class_ "Semigroup" [ e.t "w" ])
            (e.subj_ "Extend"
                [ e.rv (e.ap1_ (e.rv (e.op "->")) (e.t "w"))
                ]
            )
        , i.instanceCl "Array"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in extend