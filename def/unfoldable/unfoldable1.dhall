let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Unfoldable1 :: (Type -> Type) -> Constraint
-- class Unfoldable1 t where

let unfoldable1 : tc.TClass =
    { id = "unfoldable1"
    , name = "Unfoldable1"
    , what = tc.What.Class_
    , vars = [ "t" ]
    , info = "This class identifies data structures which can be unfolded with guarantee not to be empty."
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-unfoldable" +6
    , link = "purescript-unfoldable/6.0.0/docs/Data.Unfoldable1"
    , spec =
        d.class_vc
            (d.id "unfoldable1")
            "Unfoldable1"
            [ d.v "t" ]
            d.t2c
    , members =
        [
            { name = "unfoldr1"
            , def =
                e.fn3
                    (e.br
                        (e.fn2
                            (e.n "b")
                            (e.class "Tuple" [ e.n "a", e.br (e.class1 "Maybe" (e.n "b")) ])
                        )
                    )
                    (e.n "b")
                    (e.ap2 (e.t "t") (e.n "a"))
                -- (b -> Tuple a (Maybe b)) -> b -> t a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "function"
                    , examples =
                        [ tc.lrc
                            { left = e.call "unfoldr" [ e.f "f", e.n "b" ] -- unfoldr1 f b
                            , right = e.call1 "singleton" (e.n "a") -- singleton a
                            , conditions =
                                [ e.opc2 (e.ap2 (e.f "f") (e.n "b")) "==" (e.class "Tuple" [ e.n "a", e.classE "Nothing" ]) ] -- f b == Tuple a Nothing
                            }
                        , tc.lrc
                            { left = e.call "unfoldr1" [ e.f "f", e.n "b" ] -- unfoldr1 f b
                            , right = e.opc2 (e.n "a") "::" (e.call "unfoldr1" [ e.f "f", e.n "b1" ]) -- a :: unfoldr1 f b1
                            , conditions =
                                [ e.opc2 (e.ap2 (e.f "f") (e.n "b")) "==" (e.class "Tuple" [ e.n "a", e.br (e.class1 "Just" (e.n "b1")) ]) ] -- f b == Tuple a (Just b1)
                            }
                        ]
                    }
                ]
            } /\ tc.noOps /\ tc.noExamples
        ,
            { name = "replicate1"
            , def =
                e.req1
                    (e.subj1 "Unfoldable1" (e.t "f"))
                    (e.fn3
                        (e.classE "Int")
                        (e.n "a")
                        (e.ap2 (e.t "f") (e.n "a"))
                    )
                -- Unfoldable1 f => Int -> a -> f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "replicate1A"
            , def =
                e.reqseq
                    [ e.class1 "Apply" (e.t "m"), e.subj1 "Unfoldable1" (e.t "f"), e.subj1 "Traversable1" (e.t "f") ]
                    (e.fn3
                        (e.classE "Int")
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "f") (e.n "a"))))
                    )
                -- Apply m => Unfoldable1 f => Traversable1 f => Int -> m a -> m (f a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "singleton"
            , def =
                e.req1
                    (e.subj1 "Unfoldable1" (e.t "f"))
                    (e.fn2
                        (e.n "a")
                        (e.ap2 (e.t "f") (e.n "a"))
                    )
                -- Unfoldable1 f => a -> f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "range"
            , def =
                e.req1
                    (e.subj1 "Unfoldable1" (e.t "f"))
                    (e.fn3
                        (e.classE "Int")
                        (e.classE "Int")
                        (e.ap2 (e.t "f") (e.classE "Int"))
                    )
                -- Unfoldable1 f => Int -> Int -> f Int
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "iterateN"
            , def =
                e.req1
                    (e.subj1 "Unfoldable1" (e.t "f"))
                    (e.fn
                        [ e.classE "Int"
                        , e.br (e.fn2 (e.n "a") (e.n "a"))
                        , e.n "a"
                        , e.ap2 (e.t "f") (e.classE "a")
                        ]
                    )
                -- Unfoldable1 f => Int -> (a -> a) -> a -> f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Array" "Unfoldable"
        , i.instanceSubj "Maybe" "Unfoldable"
        ]

    } /\ tc.noParents /\ tc.noStatements /\ tc.noValues /\ tc.noLaws

in unfoldable1