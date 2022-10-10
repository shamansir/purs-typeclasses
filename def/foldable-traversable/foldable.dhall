let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let foldable : tc.TClass =
    { id = "foldable"
    , name = "Foldable"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = "Represents data structures which can be folded."
    , module = [ "Data" ]
    , package = "purescript-foldable-traversable"
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.Foldable"
    , members =
        [
            { name = "foldr"
            , def =
                e.fn
                    [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "c"))
                    , e.n "b"
                    , e.ap2 (e.t "f") (e.n "a")
                    , e.n "b"
                    ]
                -- (a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldl"
            , def =
                e.fn
                    [ e.br (e.fn3 (e.n "b") (e.n "a") (e.n "b"))
                    , e.n "b"
                    , e.ap2 (e.t "f") (e.n "a")
                    , e.n "b"
                    ]
                -- (b -> a -> b) -> b -> f a -> b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldMap"
            , def =
                e.req1
                    (e.subj1 "Monoid" (e.t "m"))
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.t "m")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.t "m")
                    )
                -- Monoid m => (a -> m) -> f a -> m
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldrDefault"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "b"))
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.n "b"
                        ]
                    )
                -- Foldable f => (a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldlDefault"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "b") (e.n "a") (e.n "b"))
                        , e.n "b"
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.n "b"
                        ]
                    )
                -- Foldable f => (b -> a -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldMapDefaultL"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Monoid" (e.t "m") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.t "m")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.t "m")
                    )
                --  Foldable f => Monoid m => (a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldMapDefaultR"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Monoid" (e.t "m") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.t "m")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.t "m")
                    )
                --  Foldable f => Monoid m => (a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "fold"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Monoid" (e.t "m") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "m"))
                        (e.t "m")
                    )
             --  Foldable f => Monoid m => f m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldM"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Monoid" (e.t "m") ]
                    (e.br (e.fn3
                        (e.n "b")
                        (e.n "a")
                        (e.ap2 (e.t "m") (e.n "b"))
                    ))
                -- Foldable f => Monoid m => (b -> a -> m b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "traverse_"
            , def =
                e.reqseq
                    [ e.subj1 "Applicative" (e.t "m"), e.class1 "Foldable" (e.t "f") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "b"))))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
                -- Applicative m => Foldable f => (a -> m b) -> f a -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "for_"
            , def =
                e.reqseq
                    [ e.subj1 "Applicative" (e.t "m"), e.class1 "Foldable" (e.t "f") ]
                    (e.fn3
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "b"))))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
                -- Applicative m => Foldable f => f a -> (a -> m b) -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sequence_"
            , def =
                e.reqseq
                    [ e.subj1 "Applicative" (e.t "m"), e.class1 "Foldable" (e.t "f") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.br (e.ap2 (e.t "m") (e.n "a"))))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
                -- Applicative m => Foldable f => f (m a) -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "oneOf"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Plus" (e.t "g") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.br (e.ap2 (e.t "g") (e.n "a"))))
                        (e.ap2 (e.t "g") (e.n "a"))
                    )
                -- Foldable f => Plus g => f (g a) -> g a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "oneOfMap"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Plus" (e.t "g") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "g") (e.n "b"))))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.ap2 (e.t "g") (e.n "b"))
                    )
                -- Foldable f => Plus g => (a -> g b) -> f a -> g b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "intercalate"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Monoid" (e.t "m") ]
                    (e.fn3
                        (e.t "m")
                        (e.ap2 (e.t "f") (e.t "m"))
                        (e.t "m")
                    )
                -- Foldable f => Monoid m => m -> f m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "surroundMap"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Semigroup" (e.t "m") ]
                    (e.fn
                        [ e.t "m"
                        , e.br (e.fn2 (e.n "a") (e.t "m"))
                        , e.ap2 (e.t "f") (e.n "a")
                        , e.t "m"
                        ]
                    )
                -- Foldable f => Semigroup m => m -> (a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "surround"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Semigroup" (e.t "m") ]
                    (e.fn3
                        (e.t "m")
                        (e.ap2 (e.t "f") (e.t "m"))
                        (e.t "m")
                    )
                -- Foldable f => Semigroup m => m -> f m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "and"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "HeytingAlgebra" (e.t "a") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "a")
                    )
                -- Foldable f => HeytingAlgebra a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "or"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "HeytingAlgebra" (e.t "a") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "a")
                    )
                -- Foldable f => HeytingAlgebra a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "all"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "HeytingAlgebra" (e.t "b") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.t "b")))
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "b")
                    )
                -- Foldable f => HeytingAlgebra b => (a -> b) -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "any"
            , def =
                 e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "HeytingAlgebra" (e.t "b") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.t "b")))
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "b")
                    )
                 -- Foldable f => HeytingAlgebra b => (a -> b) -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sum"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Semiring" (e.t "a") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "a")
                    )
                -- Foldable f => Semiring a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "product"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Semiring" (e.t "a") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "a")
                    )
                -- Foldable f => Semiring a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "elem"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Eq" (e.t "a") ]
                    (e.fn3
                        (e.t "a")
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.classE "Boolean")
                    )
                -- Foldable f => Eq a => a -> f a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "notElem"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Eq" (e.t "a") ]
                    (e.fn3
                        (e.t "a")
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.classE "Boolean")
                    )
                -- Foldable f => Eq a => a -> f a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "indexl"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn3
                        (e.classE "Boolean")
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.class1 "Maybe" (e.n "a"))
                    )
                -- Foldable f => Int -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "indexr"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn3
                        (e.classE "Boolean")
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.class1 "Maybe" (e.n "a"))
                    )
                -- Foldable f => Int -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "find"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn3
                        (e.br (e.ap2 (e.n "a") (e.classE "Boolean")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.class1 "Maybe" (e.n "a"))
                    )
                -- Foldable f => (a -> Boolean) -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "findMap"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn3
                        (e.br (e.ap2 (e.n "a") (e.class1 "Maybe" (e.n "a"))))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.ap2 (e.classE "Maybe") (e.n "a"))
                    )
                -- Foldable f => (a -> Maybe b) -> f a -> Maybe b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "maximum"
            , def =
                e.reqseq
                    [ e.class1 "Ord" (e.t "a"), e.subj1 "Foldable" (e.t "f") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.ap2 (e.classE "Maybe") (e.t "a"))
                    )
                -- Ord a => Foldable f => f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "maximumBy"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn3
                        (e.br (e.fn3 (e.n "a") (e.n "a") (e.classE "Ordering")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.class1 "Maybe" (e.n "a"))
                    )
                -- Foldable f => (a -> a -> Ordering) -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "minimum"
            , def =
                e.reqseq
                    [ e.class1 "Ord" (e.t "a"), e.subj1 "Foldable" (e.t "f") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.ap2 (e.classE "Maybe") (e.t "a"))
                    )
                -- Ord a => Foldable f => f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "minimumBy"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn3
                        (e.br (e.fn3 (e.n "a") (e.n "a") (e.classE "Ordering")))
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.class1 "Maybe" (e.n "a"))
                    )
                -- Foldable f => (a -> a -> Ordering) -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "null"
            , def =
                e.req1
                    (e.subj1 "Foldable" (e.t "f"))
                    (e.fn2
                        (e.ap2 (e.t "f") (e.n "a"))
                        (e.classE "Boolean")
                    )
                -- Foldable f => f a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "length"
            , def =
                e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Semiring" (e.t "b") ]
                    (e.fn2
                        (e.ap2 (e.t "f") (e.t "a"))
                        (e.t "b")
                    )
                -- Foldable f => Semiring b => f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lookup"
            , def =
                 e.reqseq
                    [ e.subj1 "Foldable" (e.t "f"), e.class1 "Eq" (e.t "a") ]
                    (e.fn3
                        (e.t "a")
                        (e.ap2 (e.t "f") (e.br (e.class "Tuple" [ e.t "a", e.n "b" ])))
                        (e.class1 "Maybe" (e.t "b"))
                    )
                -- Foldable f => Eq a => a -> f (Tuple a b) -> Maybe b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Array" "Foldable"
        , i.instanceSubj "Maybe" "Foldable"
        , i.instanceSubj "First" "Foldable"
        , i.instanceSubj "Last" "Foldable"
        , i.instanceSubj "Additive" "Foldable"
        , i.instanceSubj "Dual" "Foldable"
        , i.instanceSubj "Disj" "Foldable"
        , i.instanceSubj "Conj" "Foldable"
        , i.instanceSubj "Multiplicative" "Foldable"
        , i.instanceSubjA "Either" "Foldable"
        , i.instanceSubjA "Tuple" "Foldable"
        , i.instanceSubj "Identity" "Foldable"
        , i.instanceSubjA "Const" "Foldable"
        , i.instanceReqFG "Product" "Foldable"
        , i.instanceReqFG "Coproduct" "Foldable"
        , i.instanceReqFG "Compose" "Foldable"
        , i.instanceReqASubj "App" "Foldable"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in foldable