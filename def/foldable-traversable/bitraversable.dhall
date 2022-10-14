let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class Bitraversable :: (Type -> Type -> Type) -> Constraint
-- class (Bifunctor t, Bifoldable t) <= Bitraversable t where

let bitraversable : tc.TClass =
    { id = "bitraversable"
    , name = "Bitraversable"
    , what = tc.What.Class_
    , vars = [ "t" ]
    , parents = [ "bifunctor", "bifoldable" ]
    , info = "Data structures with two arguments which can be traversed"
    , module = [ "Data" ]
    , package = tc.pk "purescript-foldable-traversable" +5 +0 +1
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.Bitraversable"
    , members =
        [
            { name = "bitraverse"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.t "f"))
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.ap2 (e.n "f") (e.n "c")))
                        , e.br (e.fn2 (e.n "b") (e.ap2 (e.n "f") (e.n "d")))
                        , e.ap3 (e.t "f") (e.n "a") (e.n "b")
                        , e.ap2 (e.t "f") (e.br (e.ap3 (e.t "t") (e.n "c") (e.n "d")))
                        ]
                    )
                -- Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f (t c d)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bisequence"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.t "f"))
                    (e.fn2
                        (e.ap3 (e.t "t") (e.br (e.ap2 (e.t "f") (e.n "a"))) (e.br (e.ap2 (e.t "f") (e.n "b"))))
                        (e.ap2 (e.t "f") (e.br (e.ap3 (e.t "t") (e.n "a") (e.n "b"))))
                    )
                -- Applicative f => t (f a) (f b) -> f (t a b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bitraverseDefault"
            , def =
                e.reqseq
                    [ e.class1 "Bitraversable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.ap2 (e.n "f") (e.n "c")))
                        , e.br (e.fn2 (e.n "b") (e.ap2 (e.n "f") (e.n "d")))
                        , e.ap3 (e.t "f") (e.n "a") (e.n "b")
                        , e.ap2 (e.t "f") (e.br (e.ap3 (e.t "t") (e.n "c") (e.n "d")))
                        ]
                    )
                -- Bitraversable t => Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f (t c d)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bisequenceDefault"
            , def =
                e.reqseq
                    [ e.class1 "Bitraversable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn2
                        (e.ap3 (e.t "t") (e.br (e.ap2 (e.t "f") (e.n "a"))) (e.br (e.ap2 (e.t "f") (e.n "b"))))
                        (e.ap2 (e.t "f") (e.br (e.ap3 (e.t "t") (e.n "a") (e.n "b"))))
                    )
                -- Bitraversable t => Applicative f => t (f a) (f b) -> f (t a b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifor"
            , def =
                e.reqseq
                    [ e.class1 "Bitraversable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn
                        [ e.ap3 (e.t "t") (e.n "a") (e.n "b")
                        , e.br (e.fn2 (e.n "a") (e.ap2 (e.n "f") (e.n "c")))
                        , e.br (e.fn2 (e.n "b") (e.ap2 (e.n "f") (e.n "d")))
                        , e.ap3 (e.t "f") (e.n "a") (e.n "b")
                        , e.ap2 (e.t "f") (e.br (e.ap3 (e.t "t") (e.n "c") (e.n "d")))
                        ]
                    )
                -- Bitraversable t => Applicative f => t a b -> (a -> f c) -> (b -> f d) -> f (t c d)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lfor"
            , def =
                e.reqseq
                    [ e.class1 "Bitraversable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn
                        [ e.ap3 (e.t "t") (e.n "a") (e.n "b")
                        , e.br (e.fn2 (e.n "a") (e.ap2 (e.n "f") (e.n "c")))
                        , e.ap2 (e.t "f") (e.br (e.ap3 (e.t "t") (e.n "c") (e.n "b")))
                        ]
                    )
                -- Bitraversable t => Applicative f => t a b -> (a -> f c) -> f (t c b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "rfor"
            , def =
                e.reqseq
                    [ e.class1 "Bitraversable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn
                        [ e.ap3 (e.t "t") (e.n "a") (e.n "b")
                        , e.br (e.fn2 (e.n "b") (e.ap2 (e.n "f") (e.n "c")))
                        , e.ap2 (e.t "f") (e.br (e.ap3 (e.t "t") (e.n "a") (e.n "c")))
                        ]
                    )
                -- Bitraversable t => Applicative f => t a b -> (b -> f c) -> f (t a c)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceReqF2_ "Traversable" "Clown" "Bitraversable"
        , i.instanceReqF2_ "Traversable" "Joker" "Bitraversable"
        , i.instanceReqPSubj "Flip" "Bitraversable"
        , i.instanceReqFG "Product2" "Bitraversable"
        , i.instanceSubj "Either" "Bitraversable"
        , i.instanceSubj "Tuple" "Bitraversable"
        , i.instanceSubj "Const" "Bitraversable"
        ]

    } /\ tc.noStatements /\ tc.noValues /\ tc.noLaws

in bitraversable