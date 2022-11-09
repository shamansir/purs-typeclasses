let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let fstab = \(first : e_.Expr) -> e.class "Fold" [ first, e.n "s", e.n "t", e.n "a", e.n "b" ] -- Fold <first> s t a b
let fstab_br = \(first : e_.Expr) -> fstab (e.br first)                                        -- Fold (<first>) s t a b
let fastab = fstab (e.n "a")                                                                   -- Fold a s t a b
let frstab = fstab (e.n "r")                                                                   -- Fold r s t a b
let frabat = e.class "Fold" [ e.n "r", e.n "a", e.n "b", e.n "a", e.n "t" ]                    -- Fold r a b a t
let frgabat = e.class "Fold" [ e.n "r", e.br (e.ap2 (e.f "g") (e.n "a")), e.n "b", e.n "a", e.n "t" ]                    -- Fold r (g a) b a t
let fstfab = \(first : e_.Expr) -> e.class "Fold" [ first, e.n "s", e.n "t", e.br (e.ap2 (e.f "f") (e.n "a")), e.n "b" ] -- Fold <first> s t (f a) b
let fstfab_br = \(first : e_.Expr) -> fstfab (e.br first)                                      -- Fold (<first>) s t (f a) b
let ifistab = \(first : e_.Expr) -> e.class "IndexedFold" [ first, e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ] -- IndexedFold <first> i s t a b
let ifistab_br = \(first : e_.Expr) -> ifistab (e.br first)                                    -- IndexedFold (<first>) i s t a b
let ifristab = ifistab (e.n "r")                                                               -- IndexedFold r i s t a b

let foldpkg : tc.TClass =
    { spec = d.pkg (d.id "foldpkg") "Lens.Fold"
    , info = "Lenses for folds"
    , module = [ "Data", "Lens", "Fold" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "previewOn"
            , def =
                e.fn3
                    (e.n "s")
                    (fstab_br (e.class1 "First" (e.n "a")))
                    (e.class1 "Maybe" (e.n "a"))
                -- s -> Fold (First a) s t a b -> Maybe a
            , belongs = tc.Belongs.No
            , op = Some "^?"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "toListOfOn"
            , def =
                e.fn3
                    (e.n "s")
                    (fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "List" (e.n "a")) ]))
                    (e.class1 "List" (e.n "a"))
                -- s -> Fold (Endo Function (List a)) s t a b -> List a
            , belongs = tc.Belongs.No
            , op = Some "^.."
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "preview"
            , def =
                e.fn3
                    (fstab_br (e.class1 "First" (e.n "a")))
                    (e.n "s")
                    (e.class1 "Maybe" (e.n "a"))
                -- Fold (First a) s t a b -> s -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldOf"
            , def = e.fn3 fastab (e.n "s") (e.n "a")
                -- Fold a s t a b -> s -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldMapOf"
            , def = e.fn [ frstab, e.br (e.fn2 (e.n "a") (e.n "r")), e.n "s", e.n "r" ]
                -- Fold r s t a b -> (a -> r) -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldrOf"
            , def = e.fn [ fstab_br (e.class "Endo" [ e.classE "Function", e.n "r" ]), e.br (e.fn3 (e.n "a") (e.n "r") (e.n "r")), e.n "r", e.n "s", e.n "r" ]
                -- Fold (Endo Function r) s t a b -> (a -> r -> r) -> r -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "foldlOf"
            , def = e.fn [ fstab_br (e.class1 "Dual" (e.br (e.class "Endo" [ e.classE "Function", e.n "r" ]))), e.br (e.fn3 (e.n "r") (e.n "a") (e.n "r")), e.n "r", e.n "s", e.n "r" ]
                -- Fold (Dual (Endo Function r)) s t a b -> (r -> a -> r) -> r -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "toListOf"
            , def =
                e.fn3
                    (fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "List" (e.n "a")) ]))
                    (e.n "s")
                    (e.class1 "List" (e.n "a"))
                -- Fold (Endo Function (List a)) s t a b -> s -> List a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "firstOf"
            , def =
                e.fn3
                    (fstab_br (e.class1 "First" (e.n "a")))
                    (e.n "s")
                    (e.class1 "Maybe" (e.n "a"))
                -- Fold (First a) s t a b -> s -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lastOf"
            , def =
                e.fn3
                    (fstab_br (e.class1 "Last" (e.n "a")))
                    (e.n "s")
                    (e.class1 "Maybe" (e.n "a"))
                -- Fold (Last a) s t a b -> s -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "maximumOf"
            , def =
                e.req1
                    (e.class1 "Ord" (e.n "a"))
                    (e.fn3
                        (fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "Maybe" (e.n "a")) ]))
                        (e.n "s")
                        (e.class1 "Maybe" (e.n "a"))
                    )
                -- Ord a => Fold (Endo Function (Maybe a)) s t a b -> s -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "minimumOf"
            , def =
                e.req1
                    (e.class1 "Ord" (e.n "a"))
                    (e.fn3
                        (fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "Maybe" (e.n "a")) ]))
                        (e.n "s")
                        (e.class1 "Maybe" (e.n "a"))
                    )
                -- Ord a => Fold (Endo Function (Maybe a)) s t a b -> s -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "allOf"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn
                        [ fstab_br (e.class1 "Conj" (e.n "r"))
                        , e.br (e.fn2 (e.n "a") (e.n "r"))
                        , e.n "s"
                        , e.n "r"
                        ]
                    )
                -- HeytingAlgebra r => Fold (Conj r) s t a b -> (a -> r) -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "anyOf"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn
                        [ fstab_br (e.class1 "Disj" (e.n "r"))
                        , e.br (e.fn2 (e.n "a") (e.n "r"))
                        , e.n "s"
                        , e.n "r"
                        ]
                    )
                -- HeytingAlgebra r => Fold (Disj r) s t a b -> (a -> r) -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "andOf"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn
                        [ fstab_br (e.class1 "Conj" (e.n "a"))
                        , e.n "s"
                        , e.n "a"
                        ]
                    )
                -- HeytingAlgebra a => Fold (Conj a) s t a b -> s -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "orOf"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn
                        [ fstab_br (e.class1 "Disj" (e.n "a"))
                        , e.n "s"
                        , e.n "a"
                        ]
                    )
                -- HeytingAlgebra a => Fold (Disj a) s t a b -> s -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "elemOf"
            , def =
                e.req1
                    (e.class1 "Eq" (e.n "a"))
                    (e.fn
                        [ fstab_br (e.class1 "Disj" (e.classE "Boolean"))
                        , e.n "a"
                        , e.n "s"
                        , e.classE "Boolean"
                        ]
                    )
                -- Eq a => Fold (Disj Boolean) s t a b -> a -> s -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "notElemOf"
            , def =
                e.req1
                    (e.class1 "Eq" (e.n "a"))
                    (e.fn
                        [ fstab_br (e.class1 "Conj" (e.classE "Boolean"))
                        , e.n "a"
                        , e.n "s"
                        , e.classE "Boolean"
                        ]
                    )
                -- Eq a => Fold (Conj Boolean) s t a b -> a -> s -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sumOf"
            , def =
                e.req1
                    (e.class1 "Semiring" (e.n "a"))
                    (e.fn
                        [ fstab_br (e.class1 "Additive" (e.n "a"))
                        , e.n "s"
                        , e.n "a"
                        ]
                    )
                -- Semiring a => Fold (Additive a) s t a b -> s -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "productOf"
            , def =
                e.req1
                    (e.class1 "Semiring" (e.n "a"))
                    (e.fn
                        [ fstab_br (e.class1 "Multiplicative" (e.n "a"))
                        , e.n "s"
                        , e.n "a"
                        ]
                    )
                -- Semiring a => Fold (Multiplicative a) s t a b -> s -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lengthOf"
            , def =
                e.fn
                    [ fstab_br (e.class1 "Additive" (e.classE "Int"))
                    , e.n "s"
                    , e.classE "Int"
                    ]
                -- Fold (Additive Int) s t a b -> s -> Int
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "findOf"
            , def =
                e.fn
                    [ fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "Maybe" (e.n "a")) ])
                    , e.br (e.fn2 (e.n "a") (e.classE "Boolean"))
                    , e.n "s"
                    , e.class1 "Maybe" (e.n "a")
                    ]
                -- Fold (Endo Function (Maybe a)) s t a b -> (a -> Boolean) -> s -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sequenceOf_"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.f "f"))
                    (e.fn
                        [ fstfab_br (e.class "Endo" [ e.classE "Function", e.br (e.ap2 (e.f "f") (e.classE "Unit")) ])
                        , e.n "s"
                        , e.ap2 (e.f "f") (e.classE "Unit")
                        ]
                    )
                -- Applicative f => Fold (Endo Function (f Unit)) s t (f a) b -> s -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "traverseOf_"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.f "f"))
                    (e.fn
                        [ fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.ap2 (e.f "f") (e.classE "Unit")) ])
                        , e.br (e.fn2 (e.n "a") (e.ap2 (e.f "f") (e.n "r")))
                        , e.n "s"
                        , e.ap2 (e.f "f") (e.classE "Unit")
                        ]
                    )
                -- Applicative f => Fold (Endo Function (f Unit)) s t a b -> (a -> f r) -> s -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "has"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn
                        [ fstab_br (e.class1 "Disj" (e.n "r"))
                        , e.n "s"
                        , e.n "r"
                        ]
                    )
                -- HeytingAlgebra r => Fold (Disj r) s t a b -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hasn't"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn
                        [ fstab_br (e.class1 "Conj" (e.n "r"))
                        , e.n "s"
                        , e.n "r"
                        ]
                    )
                -- HeytingAlgebra r => Fold (Conj r) s t a b -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "replicated"
            , def =
                e.req1
                    (e.class1 "Monoid" (e.n "r"))
                    (e.fn2 (e.classE "Int") frabat)
                -- Monoid r => Int -> Fold r a b a t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "filtered"
            , def =
                e.req1
                    (e.class1 "Choice" (e.n "p"))
                    (e.fn2
                        (e.br (e.fn2 (e.n "a") (e.classE "Boolean")))
                        (e.class "Optic'" [ e.n "p", e.n "a", e.n "a" ])
                    )
                -- Choice p => (a -> Boolean) -> Optic' p a a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "folded"
            , def =
                e.reqseq
                    [ e.class1 "Monoid" (e.n "r"), e.class1 "Foldable" (e.f "g") ]
                    frgabat
                -- Monoid r => Foldable g => Fold r (g a) b a t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unfolded"
            , def =
                e.req1
                    (e.class1 "Monoid" (e.n "r"))
                    (e.fn2
                        (e.br (e.fn2 (e.n "s") (e.class1 "Maybe" (e.br (e.class "Tuple" [ e.n "a", e.n "s" ])))))
                        frstab
                    )
                -- Monoid r => (s -> Maybe (Tuple a s)) -> Fold r s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "toArrayOf"
            , def =
                e.fn3
                    (fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "List" (e.n "a")) ]))
                    (e.n "s")
                    (e.class1 "Array" (e.n "a"))
                -- Fold (Endo Function (List a)) s t a b -> s -> Array a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "toArrayOfOn"
            , def =
                e.fn3
                    (e.n "s")
                    (fstab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "List" (e.n "a")) ]))
                    (e.class1 "Array" (e.n "a"))
                -- s -> Fold (Endo Function (List a)) s t a b -> Array a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ifoldMapOf"
            , def =
                e.fn
                    [ ifristab
                    , e.br (e.fn3 (e.n "i") (e.n "a") (e.n "r"))
                    , e.n "s"
                    , e.n "r"
                    ]
                -- IndexedFold r i s t a b -> (i -> a -> r) -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ifoldrOf"
            , def =
                e.fn
                    [ ifistab_br (e.class "Endo" [ e.classE "Function", e.n "r" ])
                    , e.br (e.fn [ e.n "i", e.n "a", e.n "r", e.n "r" ])
                    , e.n "r"
                    , e.n "s"
                    , e.n "r"
                    ]
                -- IndexedFold (Endo Function r) i s t a b -> (i -> a -> r -> r) -> r -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ifoldlOf"
            , def =
                e.fn
                    [ ifistab_br (e.class1 "Dual" (e.br (e.class "Endo" [ e.classE "Function", e.n "r" ])))
                    , e.br (e.fn [ e.n "i", e.n "r", e.n "a", e.n "r" ])
                    , e.n "r"
                    , e.n "s"
                    , e.n "r"
                    ]
                -- IndexedFold (Dual (Endo Function r)) i s t a b -> (i -> r -> a -> r) -> r -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "iallOf"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn
                        [ ifistab (e.class1 "Conj" (e.n "r"))
                        , e.br (e.fn [ e.n "i", e.n "a", e.n "r" ])
                        , e.n "r"
                        , e.n "s"
                        , e.n "r"
                        ]
                    )
                -- HeytingAlgebra r => IndexedFold (Conj r) i s t a b -> (i -> a -> r) -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ifindOf"
            , def =
                e.fn
                    [ ifistab_br (e.class "Endo" [ e.classE "Function", e.br (e.class1 "Maybe" (e.n "a")) ])
                    , e.br (e.fn3 (e.n "i") (e.n "a") (e.classE "Boolean"))
                    , e.n "s"
                    , e.class1 "Maybe" (e.n "a")
                    ]
                -- IndexedFold (Endo Function (Maybe a)) i s t a b -> (i -> a -> Boolean) -> s -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "itoListOf"
            , def =
                e.fn
                    [ ifistab_br
                        (e.class "Endo"
                            [ e.classE "Function", e.br (e.class1 "List" (e.n "a"))
                            , e.class1 "List" (e.br (e.class "Tuple" [ e.n "i", e.n "a" ]))
                            ]
                        )
                    , e.n "s"
                    , e.class1 "List" (e.br (e.class "Tuple" [ e.n "i", e.n "a" ]))
                    ]
                -- IndexedFold (Endo Function (List (Tuple i a))) i s t a b -> s -> List (Tuple i a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "itraverseOf_"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.f "f"))
                    (e.fn
                        [ ifistab_br (e.class "Endo" [ e.classE "Function", e.br (e.ap2 (e.f "f") (e.classE "Unit")) ])
                        , e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.f "f") (e.n "r")))
                        , e.n "s"
                        , e.ap2 (e.f "f") (e.classE "Unit")
                        ]
                    )
                -- Applicative f => IndexedFold (Endo Function (f Unit)) i s t a b -> (i -> a -> f r) -> s -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "iforOf_"
            , def =
                e.req1
                    (e.class1 "Applicative" (e.f "f"))
                    (e.fn
                        [ ifistab_br (e.class "Endo" [ e.classE "Function", e.br (e.ap2 (e.f "f") (e.classE "Unit")) ])
                        , e.n "s"
                        , e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.f "f") (e.n "r")))
                        , e.ap2 (e.f "f") (e.classE "Unit")
                        ]
                    )
                -- Applicative f => IndexedFold (Endo Function (f Unit)) i s t a b -> s -> (i -> a -> f r) -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unsafeView"
            , def =
                e.req1
                    (e.classE "Partial")
                    (e.fn3
                        (e.n "s")
                        (fstab_br (e.class1 "First" (e.n "a")))
                        (e.n "a")
                    )
                -- Partial => s -> Fold (First a) s t a b -> a
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Fold", "Partial" ]
            , op = Some "^?!"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unsafeIndexedFold"
            , def =
                e.req1
                    (e.classE "Partial")
                    (e.fn3
                        (e.n "s")
                        (ifistab_br (e.class1 "First" (e.br (e.class "Tuple" [ e.n "i", e.n "a" ]))))
                        (e.class "Tuple" [ e.n "i", e.n "a" ])
                    )
                -- Partial => s -> IndexedFold (First (Tuple i a)) i s t a b -> Tuple i a
            , op = Some "^@?!"
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Fold", "Partial" ]
            } /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in foldpkg