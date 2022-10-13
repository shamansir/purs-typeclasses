let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let traversable : tc.TClass =
    { id = "traversable"
    , name = "Traversable"
    , what = tc.What.Class_
    , vars = [ "t" ]
    , parents = [ "functor", "foldable" ]
    , info = "Data structures which can be traversed, accumulate in Applicative Functor"
    , module = [ "Data" ]
    , package = tc.pk "purescript-foldable-traversable" +5 +0 +1
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.Traversable"
    , statements =
        [
            { left =
                e.call "traverse" [ e.n "f", e.n "xs" ]
                -- traverse f xs
            , right =
                e.call1 "sequence" (e.br (e.opc2 (e.f "f") "<$>" (e.n "xs")))
                -- sequence (f <$> xs)
            }
        ,
            { left =
                e.callE "sequence"
                -- sequence
            , right =
                e.call1 "traverse" (e.callE "identity")
                -- traverse identity
            }
        ,
            { left =
                e.call1 "foldMap" (e.f "f")
                -- foldMap f
            , right =
                e.opc2 (e.callE "runConst") "<<<" (e.call1 "traverse" (e.br (e.opc2 (e.classE "Const") "<<<" (e.f "f"))))
                -- runConst <<< traverse (Const <<< f)
            }
        ]
    , members =
        [
            { name = "traverse"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.t "m"))
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )
                -- Applicative m => (a -> m b) -> t a -> m (t b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sequence"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.t "m"))
                    (e.fn2
                        (e.ap2 (e.t "t") (e.br (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )
                -- Applicative m => t (m a) -> m (t a)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "traverseDefault"
            , def =
                e.req
                    [ e.class1 "Traversable" (e.t "t")
                    , e.class1 "Applicative" (e.t "m")
                    ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "t") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )
                -- Traversable t => Applicative m => (a -> m b) -> t a -> m (t b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sequenceDefault"
            , def =
                e.req
                    [ e.class1 "Traversable" (e.t "t")
                    , e.class1 "Applicative" (e.t "m")
                    ]
                    (e.fn2
                        (e.ap2 (e.t "t") (e.br (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "a"))))
                    )
                -- Traversable t => Applicative m => t (m a) -> m (t a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "for"
            , def =
                e.req
                    [ e.class1 "Applicative" (e.t "m")
                    , e.class1 "Traversable" (e.t "t")
                    ]
                    (e.fn3
                        (e.ap2 (e.t "t") (e.n "a"))
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "t") (e.n "b"))))
                    )
                -- Applicative m => Traversable t => t a -> (a -> m b) -> m (t b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "scanl"
            , def =
                e.req1
                    (e.class1 "Traversable" (e.t "f"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "b") (e.n "a") (e.n "b"))
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.ap2 (e.t "f") (e.n "b")
                        ]
                    )
                -- Traversable f => (b -> a -> b) -> b -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "scanr"
            , def =
                e.req1
                    (e.class1 "Traversable" (e.t "f"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "b"))
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.ap2 (e.t "f") (e.n "b")
                        ]
                    )
                -- Traversable f => (a -> b -> b) -> b -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "mapAccumL"
            , def =
                e.req1
                    (e.class1 "Traversable" (e.t "f"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "s") (e.n "a") (e.class "Accum" [ e.n "s", e.n "b" ]))
                        , e.n "s"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.class "Accum" [ e.n "s", e.br (e.ap2 (e.t "f") (e.n "b")) ]
                        ]
                    )
                -- Traversable f => (s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "mapAccumR"
            , def =
                e.req1
                    (e.class1 "Traversable" (e.t "f"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "s") (e.n "a") (e.class "Accum" [ e.n "s", e.n "b" ]))
                        , e.n "s"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.class "Accum" [ e.n "s", e.br (e.ap2 (e.t "f") (e.n "b")) ]
                        ]
                    )
                -- Traversable f => (s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Array" "Traversable"
        , i.instanceSubj "Maybe" "Traversable"
        , i.instanceSubj "First" "Traversable"
        , i.instanceSubj "Last" "Traversable"
        , i.instanceSubj "Additive" "Traversable"
        , i.instanceSubj "Dual" "Traversable"
        , i.instanceSubj "Disj" "Traversable"
        , i.instanceSubj "Conj" "Traversable"
        , i.instanceSubj "Multiplicative" "Traversable"
        , i.instanceSubjA "Either" "Traversable"
        , i.instanceSubjA "Tuple" "Traversable"
        , i.instanceSubj "Identity" "Traversable"
        , i.instanceSubjA "Const" "Traversable"
        , i.instanceReqFG "Product" "Traversable"
        , i.instanceReqFG "Coproduct" "Traversable"
        , i.instanceReqFG "Compose" "Traversable"
        , i.instanceReqASubj "App" "Traversable"
        ]

    } /\ tc.noValues /\ tc.noLaws

in traversable