let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let d = ./../../spec.dhall
let i = ./../../instances.dhall

-- class FoldableWithIndex :: Type -> (Type -> Type) -> Constraint
-- class (Foldable f) <= FoldableWithIndex i f | f -> i where

let foldableWithIndex : tc.TClass =
    { id = "foldablewithindex"
    , name = "FoldableWithIndex"
    , what = tc.What.Class_
    , vars = [ "i", "f" ]
    , info = "A Foldable with an additional index."
    , module = [ "Data" ]
    , package = tc.pk "purescript-foldable-traversable" +5 +0 +1
    , parents = [ "foldable" ]
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.FoldableWithIndex"
    , spec =
        d.class_vpdc
            (d.id "foldablewithindex")
            "FoldableWithIndex"
            [ d.v "i", d.v "f" ]
            [ d.p (d.id "foldable") "Foldable" [ d.v "f" ] ]
            (d.deps1 (d.v "f") (d.v "i"))
            d.tt2c
    , statements =
        [
            { left = e.call1 "foldr" (e.f "f") -- foldr f
            , right = e.call1 "foldrWithIndex" (e.br (e.call1 "const" (e.f "f"))) -- foldrWithIndex (const f)
            }
        ,
            { left = e.call1 "foldl" (e.f "f") -- foldl f
            , right = e.call1 "foldlWithIndex" (e.br (e.call1 "const" (e.f "f")))  -- foldlWithIndex (const f)
            }
        ,
            { left = e.call1 "foldMap" (e.f "f") -- foldMap f
            , right = e.call1 "foldMapWithIndex" (e.br (e.call1 "const" (e.f "f")))  -- foldMapWithIndex (const f)
            }
        ]
    , members =
        [
            { name = "foldrWithIndex"
            , def =
                e.fn
                    [ e.br (e.fn [ e.n "i", e.n "a", e.n "b", e.n "b"])
                    , e.n "b"
                    , e.ap2 (e.t "f") (e.n "a")
                    , e.n "b"
                    ]
                -- (i -> a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldlWithIndex"
            , def =
                e.fn
                    [ e.br (e.fn [ e.n "i", e.n "b", e.n "a", e.n "b"])
                    , e.n "b"
                    , e.ap2 (e.t "f") (e.n "a")
                    , e.n "b"
                    ]
                -- (i -> b -> a -> b) -> b -> f a -> b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldMapWithIndex"
            , def =
                e.req1
                    (e.subj1 "Monoid" (e.t "m"))
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.t "m")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.t "m")
                    )
                -- Monoid m => (i -> a -> m) -> f a -> m
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldrWithIndexDefault"
            , def =
                e.req1
                    (e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "i", e.n "a", e.n "b", e.n "b"])
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.n "b"
                        ]
                    )
                -- FoldableWithIndex i f => (i -> a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldlWithIndexDefault"
            , def =
                e.req1
                    (e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "i", e.n "b", e.n "a", e.n "b"])
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.n "b"
                        ]
                    )
                -- FoldableWithIndex i f => (i -> b -> a -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldMapWithIndexDefaultR"
            , def =
                e.reqseq
                    [ e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ], e.class1 "Monoid" (e.t "m") ]
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.t "m")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.t "m")
                    )
                -- FoldableWithIndex i f => Monoid m => (i -> a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldMapDefaultL"
            , def =
                e.reqseq
                    [ e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ], e.class1 "Monoid" (e.t "m") ]
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.t "m")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.t "m")
                    )
                -- FoldableWithIndex i f => Monoid m => (i -> a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldWithIndexM"
            , def =
                e.reqseq
                    [ e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ], e.class1 "Monad" (e.t "m") ]
                    (e.fn
                        [ e.br (e.fn
                            [ e.n "i"
                            , e.n "b"
                            , e.n "a"
                            , e.ap2 (e.t "m") (e.n "b")
                            ])
                        , e.n "a"
                        , e.ap2 (e.t "f") (e.n "b")
                        , e.ap2 (e.t "m") (e.n "a")
                        ]
                    )
                -- FoldableWithIndex i f => Monad m => (i -> a -> b -> m a) -> a -> f b -> m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "traverseWithIndex_"
            , def =
                e.reqseq
                    [ e.class1 "Applicative" (e.t "m"), e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ] ]
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.t "m") (e.n "b"))))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
                -- Applicative m => FoldableWithIndex i f => (i -> a -> m b) -> f a -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "forWithIndex_"
            , def =
                e.reqseq
                    [ e.class1 "Applicative" (e.t "m"), e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ] ]
                    (e.fn3
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.t "m") (e.n "b"))))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
                -- Applicative m => FoldableWithIndex i f => f a -> (i -> a -> m b) -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "surroundMapWithIndex"
            , def =
                e.reqseq
                    [ e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ], e.class1 "Semigroup" (e.t "m") ]
                    (e.fn
                        [ e.t "m"
                        , e.br (e.fn3 (e.n "i") (e.n "a") (e.t "m"))
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.t "m"
                        ]
                    )
                -- FoldableWithIndex i f => Semigroup m => m -> (i -> a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "allWithIndex"
            , def =
                e.reqseq
                    [ e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ], e.class1 "HeytingAlgebra" (e.t "b") ]
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.t "b")))
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "b")
                    )
                -- FoldableWithIndex i f => HeytingAlgebra b => (i -> a -> b) -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "anyWithIndex"
            , def =
                 e.reqseq
                    [ e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ], e.class1 "HeytingAlgebra" (e.t "b") ]
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.t "b")))
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "b")
                    )
                -- FoldableWithIndex i f => HeytingAlgebra b => (i -> a -> b) -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "findWithIndex"
            , def =
                e.req1
                    (e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ])
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.classE "Boolean")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.class1 "Maybe" (e.obj (toMap { index = e.n "i", value = e.n "a" })))
                    )
                -- FoldableWithIndex i f => (i -> a -> Boolean) -> f a -> Maybe { index :: i, value :: a }
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "findMapWithIndex"
            , def =
                e.req1
                    (e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ])
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.class1 "Maybe" (e.n "b"))))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.ap2 (e.classE "Maybe") (e.n "b"))
                    )
                -- FoldableWithIndex i f => (i -> a -> Maybe b) -> f a -> Maybe b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldrDefault"
            , def =
                e.req1
                    (e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ])
                    (e.fn
                        [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "b"))
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.n "b"
                        ]
                    )
                -- FoldableWithIndex i f => (a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldlDefault"
            , def =
                e.req1
                    (e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ])
                    (e.fn
                        [ e.br (e.fn3 (e.n "b") (e.n "a") (e.n "b"))
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.n "b"
                        ]
                    )
                -- FoldableWithIndex i f => (b -> a -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldMapDefault"
            , def =
                e.reqseq
                    [ e.subj "FoldableWithIndex" [ e.n "i", e.t "f" ], e.class1 "Monoid" (e.t "m") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.t "m")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.t "m")
                    )
                -- FoldableWithIndex i f => Monoid m => (a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj2 "Int" "Array" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Maybe" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "First" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Last" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Additive" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Dual" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Disj" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Conj" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Multiplicative" "FoldableWithIndex"
        , i.instanceClSubjA "Unit" "Either" "FoldableWithIndex"
        , i.instanceClSubjA "Unit" "Tuple" "FoldableWithIndex"
        , i.instanceSubj2 "Unit" "Identity" "FoldableWithIndex"
        , i.instanceClSubjA "Void" "Const" "FoldableWithIndex"
        , e.req
            [ e.subj "FoldableWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "FoldableWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "FoldableWithIndex"
                [ e.br (e.class "Either" [ e.n "a", e.n "b" ])
                , e.br (e.class "Product" [ e.f "f", e.f "g" ])
                ]
            ) -- (FoldableWithIndex a f, FoldableWithIndex b g) => FoldableWithIndex (Either a b) (Product f g)
        , e.req
            [ e.subj "FoldableWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "FoldableWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "FoldableWithIndex"
                [ e.br (e.class "Either" [ e.n "a", e.n "b" ])
                , e.br (e.class "Coproduct" [ e.f "f", e.f "g" ])
                ]
            ) -- (FoldableWithIndex a f, FoldableWithIndex b g) => FoldableWithIndex (Either a b) (Coproduct f g)
        , e.req
            [ e.subj "FoldableWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "FoldableWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "FoldableWithIndex"
                [ e.br (e.class "Tuple" [ e.n "a", e.n "b" ])
                , e.br (e.class "Compose" [ e.f "f", e.f "g" ])
                ]
            ) -- (FoldableWithIndex a f, FoldableWithIndex b g) => FoldableWithIndex (Tuple a b) (Compose f g)
        , e.req1
            (e.subj "FoldableWithIndex" [ e.n "a", e.f "f" ])
            (e.subj "FoldableWithIndex"
                [ e.n "a"
                , e.br (e.class1 "App" (e.f "f"))
                ]
            ) -- (FoldableWithIndex a f) => FoldableWithIndex a (App f)
        ]

    } /\ tc.noLaws /\ tc.noValues

in foldableWithIndex