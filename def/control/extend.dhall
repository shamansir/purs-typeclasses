let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Extend :: (Type -> Type) -> Constraint
-- class (Functor w) <= Extend w where

let extend : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "extend")
            "Extend"
            [ d.v "w" ]
            [ d.p (d.id "functor") "Functor" [ d.v "w" ] ]
            d.t2c
    , info = "Extend local computation to a global one"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , members =
        [
            { name = "extend"
            , def =
                -- m a -> (a -> m b) -> m b
                e.fn3
                    (e.ap2 (e.t "m") (e.n "a"))
                    (e.br (e.fn2 (e.n "a") (e.ap2 (e.f "m") (e.n "a"))))
                    (e.ap2 (e.t "m") (e.n "b"))
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
                                e.opc2
                                    (e.call1 "extend" (e.f "f"))
                                    "<<<"
                                    (e.call1 "extend" (e.f "g"))
                            , right =
                                -- extend (f <<< extend g)
                                e.call1 "extend" (e.br (e.opc2 (e.f "f") "<<<" (e.call1 "extend" (e.f "g"))))
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ,
            { name = "extendFlipped"
            , def =
                 -- Extend w => w a -> (w a -> b) -> w b
                e.req1
                    (e.subj1 "Extend" (e.t "w"))
                    (e.fn
                        [ e.ap2 (e.t "w") (e.n "a")
                        , e.br (e.fn2 (e.ap2 (e.t "w") (e.n "a")) (e.n "b"))
                        , e.ap2 (e.t "w") (e.n "b")
                        ]
                    )
            , belongs = tc.Belongs.No
            , op = Some "==>>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "composeCoKleisli"
            , def =
                -- Extend w => (w a -> b) -> (w b -> c) -> w a -> c
                e.req1
                    (e.subj1 "Extend" (e.t "w"))
                    (e.fn
                        [ e.br (e.fn2 (e.ap2 (e.t "w") (e.n "a")) (e.n "b"))
                        , e.br (e.fn2 (e.ap2 (e.t "w") (e.n "b")) (e.n "c"))
                        , e.ap2 (e.t "w") (e.n "a")
                        , e.n "c"
                        ]
                    )
            , belongs = tc.Belongs.No
            , op = Some "=>="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "composeCoKleisliFlipped"
            , def =
                -- Extend w => (w b -> c) -> (w a -> b) -> w a -> c
                e.req1
                    (e.subj1 "Extend" (e.t "w"))
                    (e.fn
                        [ e.br (e.fn2 (e.ap2 (e.t "w") (e.n "b")) (e.n "c"))
                        , e.br (e.fn2 (e.ap2 (e.t "w") (e.n "a")) (e.n "b"))
                        , e.ap2 (e.t "w") (e.n "a")
                        , e.n "c"
                        ]
                    )
            , belongs = tc.Belongs.No
            , op = Some "=<="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "duplicate"
            , def =
                -- Extend w => w a -> w (w a)
                e.req1
                    (e.subj1 "Extend" (e.t "w"))
                    (e.fn2
                        (e.ap2 (e.t "w") (e.n "a"))
                        (e.ap2 (e.t "w") (e.br (e.ap2 (e.t "w") (e.n "a"))))
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [  -- Semigroup w => Extend ((->) w)
          e.req1
            (e.class1 "Semigroup" (e.t "w"))
            (e.subj1 "Extend" (e.br (e.op_fn1 "->" (e.n "w"))))
        , i.instanceCl "Array"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in extend