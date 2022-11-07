let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let d = ./../../spec.dhall
let i = ./../../instances.dhall

-- class TraversableWithIndex :: Type -> (Type -> Type) -> Constraint
-- class (FunctorWithIndex i t, FoldableWithIndex i t, Traversable t) <= TraversableWithIndex i t | t -> i where

let traversableWithIndex : tc.TClass =
    { id = "traversablewithindex"
    , name = "TraversableWithIndex"
    , what = tc.What.Class_
    , vars = [ "t" ]
    , parents = [ "functorwithindex", "foldablewithindex", "traversable" ]
    , info = "A Traversable with an additional index"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-foldable-traversable" +6
    , link = "purescript-foldable-traversable/6.0.0/docs/Data.TraversableWithIndex"
    , spec =
        d.class_vpdc
            (d.id "traversablewithindex")
            "TraversableWithIndex"
            [ d.v "i", d.v "t" ]
            [ d.p (d.id "functorwithindex") "FunctorWithIndex" [ d.v "i", d.v "t" ]
            , d.p (d.id "foldablewithindex") "FoldableWithIndex" [ d.v "i", d.v "t" ]
            , d.p (d.id "traversable") "Traversable" [ d.v "t" ]
            ]
            (d.deps1 (d.v "t") (d.v "i"))
            d.tt2c
    , statements =
        [
            { left =
                e.call1 "traverse" (e.n "f")
                -- traverse f
            , right =
                e.call1 "traverseWithIndex" (e.br (e.call1 "const" (e.n "f")))
                -- traverseWithIndex (const f)
            }
        ,
            { left =
                e.call1 "foldMapWithIndex" (e.n "f")
                -- foldMapWithIndex f
            , right =
                e.opc2
                    (e.callE "unwrap")
                    "<<<"
                    (e.call1 "traverseWithIndex"
                        (e.br (e.lbd1 (e.av "i") (e.opc2 (e.classE "Const") "<<<" (e.ap2 (e.f "f") (e.n "i")))))
                    )
                -- unwrap <<< traverseWithIndex (\i -> Const <<< f i)
            }
        ,
            { left =
                e.call1 "mapWithIndex" (e.f "f")
                -- mapWithIndex f
            , right =
                e.opc2
                    (e.callE "unwrap")
                    "<<<"
                    (e.call1 "traverseWithIndex"
                        (e.br (e.lbd1 (e.av "i") (e.opc2 (e.classE "Identity") "<<<" (e.ap2 (e.f "f") (e.n "i")))))
                    )
                -- unwrap <<< traverseWithIndex (\i -> Identity <<< f i)
            }
        ]
    , members =
        [
            { name = "traverseWithIndex"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.t "m"))
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )
                -- Applicative m => (i -> a -> m b) -> t a -> m (t b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "traverseWithIndexDefault"
            , def =
                e.req
                    [ e.class "TraversableWithIndex" [ e.n "i", e.t "t" ]
                    , e.class1 "Applicative" (e.t "m")
                    ]
                    (e.fn3
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )
                -- TraversableWithIndex i t => Applicative m => (i -> a -> m b) -> t a -> m (t b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "forWithIndex"
            , def =
                e.req
                    [ e.class1 "Applicative" (e.t "m")
                    , e.class "TraversableWithIndex" [ e.n "i", e.t "t" ]
                    ]
                    (e.fn3
                        (e.ap2 (e.t "t") (e.n "a"))
                        (e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )

                -- Applicative m => TraversableWithIndex i t => t a -> (i -> a -> m b) -> m (t b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "scanlWithIndex"
            , def =
                e.req1
                    (e.class "TraversableWithIndex" [ e.n "i", e.t "t" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "i", e.n "b", e.n "a", e.n "b" ])
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.ap2 (e.t "f") (e.n "b")
                        ]
                    )
                -- TraversableWithIndex i f => (i -> b -> a -> b) -> b -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "scanrWithIndex"
            , def =
                e.req1
                    (e.class "TraversableWithIndex" [ e.n "i", e.t "t" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "i", e.n "a", e.n "b", e.n "b" ])
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.ap2 (e.t "f") (e.n "b")
                        ]
                    )
                -- TraversableWithIndex i f => (i -> a -> b -> b) -> b -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mapAccumLWithIndex"
            , def =
                e.req1
                    (e.class "TraversableWithIndex" [ e.n "i", e.t "t" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "i", e.n "s", e.n "a", e.class "Accum" [ e.n "s", e.n "b" ] ])
                        , e.n "s"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.class "Accum" [ e.n "s", e.br (e.ap2 (e.t "f") (e.n "b")) ]
                        ]
                    )
                -- TraversableWithIndex i f => (i -> s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mapAccumRWithIndex"
            , def =
                e.req1
                    (e.class "TraversableWithIndex" [ e.n "i", e.t "t" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "i", e.n "s", e.n "a", e.class "Accum" [ e.n "s", e.n "b" ] ])
                        , e.n "s"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.class "Accum" [ e.n "s", e.br (e.ap2 (e.t "f") (e.n "b")) ]
                        ]
                    )
                -- TraversableWithIndex i f => (i -> s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "traverseDefault"
            , def =
                e.req
                    [ e.class "TraversableWithIndex" [ e.n "i", e.t "t" ]
                    , e.class1 "Applicative" (e.t "m")
                    ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "t") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )
                -- TraversableWithIndex i t => Applicative m => (a -> m b) -> t a -> m (t b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj2 "Int" "Array" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Maybe" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "First" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Last" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Additive" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Dual" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Disj" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Conj" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Multiplicative" "TraversableWithIndex"
        , i.instanceClSubjA "Unit" "Either" "TraversableWithIndex"
        , i.instanceClSubjA "Unit" "Tuple" "TraversableWithIndex"
        , i.instanceSubj2 "Unit" "Identity" "TraversableWithIndex"
        , i.instanceClSubjA "Void" "Const" "TraversableWithIndex"
        , e.req
            [ e.subj "TraversableWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "TraversableWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "TraversableWithIndex"
                [ e.br (e.class "Either" [ e.n "a", e.n "b" ])
                , e.br (e.class "Product" [ e.f "f", e.f "g" ])
                ]
            ) -- (TraversableWithIndex a f, TraversableWithIndex b g) => TraversableWithIndex (Either a b) (Product f g)
        , e.req
            [ e.subj "TraversableWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "TraversableWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "TraversableWithIndex"
                [ e.br (e.class "Either" [ e.n "a", e.n "b" ])
                , e.br (e.class "Coproduct" [ e.f "f", e.f "g" ])
                ]
            ) -- (TraversableWithIndex a f, TraversableWithIndex b g) => TraversableWithIndex (Either a b) (Coproduct f g)
        , e.req
            [ e.subj "TraversableWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "TraversableWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "TraversableWithIndex"
                [ e.br (e.class "Tuple" [ e.n "a", e.n "b" ])
                , e.br (e.class "Compose" [ e.f "f", e.f "g" ])
                ]
            ) -- (TraversableWithIndex a f, TraversableWithIndex b g) => TraversableWithIndex (Tuple a b) (Compose f g)
        , e.req1
            (e.subj "TraversableWithIndex" [ e.n "a", e.f "f" ])
            (e.subj "TraversableWithIndex"
                [ e.n "a"
                , e.br (e.class1 "App" (e.f "f"))
                ]
            ) -- (TraversableWithIndex a f) => TraversableWithIndex a (App f)
        ]

    } /\ tc.aw /\ tc.noValues /\ tc.noLaws

in traversableWithIndex