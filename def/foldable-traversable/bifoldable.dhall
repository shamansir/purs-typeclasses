let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Bifoldable :: (Type -> Type -> Type) -> Constraint
-- class Bifoldable p where

let bifoldable : tc.TClass =
    { spec =
        d.class_vc
            (d.id "bifoldable")
            "Bifoldable"
            [ d.v "p" ]
            d.t3c
    , info = "Represents data structures with two type arguments which can be folded."
    , module = [ "Control" ]
    , package = tc.pk "purescript-foldable-traversable" +5 +0 +1
    , members =
        [
            { name = "bifoldr"
            , def =
                e.fn
                    [ e.br (e.fn [ e.n "a", e.n "c", e.n "c" ])
                    , e.br (e.fn [ e.n "b", e.n "c", e.n "c" ])
                    , e.n "c"
                    , e.ap3 (e.t "p") (e.n "a") (e.n "b")
                    , e.n "c"
                    ]
                -- (a -> c -> c) -> (b -> c -> c) -> c -> p a b -> c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifoldl"
            , def =
                e.fn
                    [ e.br (e.fn [ e.n "c", e.n "a", e.n "c" ])
                    , e.br (e.fn [ e.n "c", e.n "b", e.n "c" ])
                    , e.n "c"
                    , e.ap3 (e.t "p") (e.n "a") (e.n "b")
                    , e.n "c"
                    ]
                -- (c -> a -> c) -> (c -> b -> c) -> c -> p a b -> c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifoldMap"
            , def =
                e.req1
                    (e.class1 "Monoid" (e.t "m"))
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.n "m"))
                        , e.br (e.fn2 (e.n "b") (e.n "m"))
                        , e.ap3 (e.t "p") (e.n "a") (e.n "b")
                        , e.t "m"
                        ]
                    )
                -- Monoid m => (a -> m) -> (b -> m) -> p a b -> m
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifoldrDefault"
            , def =
                e.req1
                    (e.subj1 "Bifoldable" (e.t "p"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "a") (e.n "c") (e.n "c"))
                        , e.br (e.fn3 (e.n "b") (e.n "c") (e.n "c"))
                        , e.n "c"
                        , e.ap3 (e.t "p") (e.n "a") (e.n "b")
                        , e.n "c"
                        ]
                    )
                -- Foldable f => (a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifoldlDefault"
            , def =
                e.req1
                    (e.subj1 "Bifoldable" (e.t "p"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "c") (e.n "a") (e.n "c"))
                        , e.br (e.fn3 (e.n "c") (e.n "b") (e.n "c"))
                        , e.n "c"
                        , e.ap3 (e.t "p") (e.n "a") (e.n "b")
                        , e.n "c"
                        ]
                    )
                -- Bifoldable p => (c -> a -> c) -> (c -> b -> c) -> c -> p a b -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifoldMapDefaultL"
            , def =
                e.reqseq
                    [ e.subj1 "Bifoldable" (e.t "p"), e.class1 "Monoid" (e.t "m") ]
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.t "m"))
                        , e.br (e.fn2 (e.n "b") (e.t "m"))
                        , e.ap3 (e.t "p") (e.n "a") (e.n "b")
                        , e.t "m"
                        ]
                    )
                --  Bifoldable p => Monoid m => (a -> m) -> (b -> m) -> p a b -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifold"
            , def =
                e.reqseq
                    [ e.subj1 "Bifoldable" (e.t "t"), e.class1 "Monoid" (e.t "m") ]
                    (e.fn2
                        (e.ap3 (e.t "t") (e.t "m") (e.t "m"))
                        (e.t "m")
                    )
                -- Bifoldable t => Monoid m => t m m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bitraverse_"
            , def =
                e.reqseq
                    [ e.subj1 "Bifoldable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.ap2 (e.t "f") (e.n "c")))
                        , e.br (e.fn2 (e.n "b") (e.ap2 (e.t "f") (e.n "d")))
                        , e.ap3 (e.t "t") (e.n "a") (e.n "b")
                        , e.ap2 (e.t "f") (e.classE "Unit")
                        ]
                    )
                -- Bifoldable t => Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bifor_"
            , def =
                e.reqseq
                    [ e.subj1 "Bifoldable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn
                        [ e.ap3 (e.t "t") (e.n "a") (e.n "b")
                        , e.br (e.fn2 (e.n "a") (e.ap2 (e.t "f") (e.n "c")))
                        , e.br (e.fn2 (e.n "b") (e.ap2 (e.t "f") (e.n "d")))
                        , e.ap2 (e.t "f") (e.classE "Unit")
                        ]
                    )
                -- Bifoldable t => Applicative f => t a b -> (a -> f c) -> (b -> f d) -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bisequence_"
            , def =
                e.reqseq
                    [ e.subj1 "Bifoldable" (e.t "t"), e.class1 "Applicative" (e.t "f") ]
                    (e.fn2
                        (e.ap3 (e.t "t") (e.br (e.ap2 (e.t "f") (e.t "a"))) (e.br (e.ap2 (e.t "f") (e.t "b"))))
                        (e.ap2 (e.t "f") (e.classE "Unit"))
                    )
                -- Bifoldable t => Applicative f => t (f a) (f b) -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "biany"
            , def =
                e.reqseq
                    [ e.subj1 "Bifoldable" (e.t "t"), e.class1 "BooleanAlgebra" (e.t "c") ]
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.t "c"))
                        , e.br (e.fn2 (e.n "b") (e.t "c"))
                        , e.ap3 (e.t "t") (e.n "a") (e.n "b")
                        , e.t "c"
                        ]
                    )
                -- Bifoldable t => BooleanAlgebra c => (a -> c) -> (b -> c) -> t a b -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "biall"
            , def =
                e.reqseq
                    [ e.subj1 "Bifoldable" (e.t "t"), e.class1 "BooleanAlgebra" (e.t "c") ]
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.t "c"))
                        , e.br (e.fn2 (e.n "b") (e.t "c"))
                        , e.ap3 (e.t "t") (e.n "a") (e.n "b")
                        , e.t "c"
                        ]
                    )
                -- Bifoldable t => BooleanAlgebra c => (a -> c) -> (b -> c) -> t a b -> c"
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceReqF2_ "Foldable" "Clown" "Bifoldable"
        , i.instanceReqF2_ "Foldable" "Joker" "Bifoldable"
        , i.instanceReqPSubj "Flip" "Bifoldable"
        , i.instanceReqFG "Product2" "Bifoldable"
        , i.instanceSubj "Either" "Bifoldable"
        , i.instanceSubj "Tuple" "Bifoldable"
        , i.instanceSubj "Const" "Bifoldable"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in bifoldable