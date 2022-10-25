let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let traversalpkg : tc.TClass =
    { id = "traversalpkg"
    , name = "Lens.Traversal"
    , what = tc.What.Package_
    , info = "Traversal is an optic that focuses on zero or more values"
    , module = [ "Data", "Lens", "Traversal" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Traversal"
    , spec = d.pkg (d.id "traversalpkg") "Lens.Traversal"
    -- over    traversed negate [1, 2, 3] == [-1, -2, -3]
    -- preview traversed [1, 2, 3] == Just 1
    -- firstOf traversed [1, 2, 3] == Just 1  -- same as `preview`
    -- lastOf  traversed [1, 2, 3] == Just 3
    --
    -- view traversed ["D", "a", "w", "n"] == "Dawn"
    , members =
        [
            { name = "traversed"
            , def =
                e.req1
                    (e.class1 "Traversable" (e.n "t"))
                    (e.class "Traversal"
                        [ e.br (e.ap2 (e.t "t") (e.n "a"))
                        , e.br (e.ap2 (e.t "t") (e.n "b"))
                        , e.n "a"
                        , e.n "b"
                        ]
                    )
                -- Traversable t => Traversal (t a) (t b) a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "element"
            , def =
                e.req1
                    (e.class1 "Wander" (e.n "p"))
                    (e.fn3
                        (e.classE "Int")
                        (e.class "Traversal" [ e.n "s", e.n "t", e.n "a", e.n "a" ])
                        (e.class "Optic" [ e.n "p", e.n "s", e.n "t", e.n "a", e.n "a" ])
                    )
                -- Wander p => Int -> Traversal s t a a -> Optic p s t a a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- set     (element 2 traversed) 8888 [0, 0, 3] == [0, 0, 8888]
            -- preview (element 2 traversed)      [0, 0, 3] == Just 3
        ,
            { name = "traverseOf"
            , def =
                e.fn
                    [ e.class "Optic" [ e.br (e.class1 "Star" (e.n "f")), e.n "s", e.n "t", e.n "a", e.n "a" ]
                    , e.br (e.fn2 (e.n "a") (e.ap2 (e.f "f") (e.n "b")))
                    , e.n "s"
                    , e.ap2 (e.f "f") (e.n "t")
                    ]
                -- Optic (Star f) s t a b -> (a -> f b) -> s -> f t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sequenceOf"
            , def =
                e.fn
                    [ e.class "Optic" [ e.br (e.class1 "Star" (e.n "f")), e.n "s", e.n "t", e.br (e.fn2 (e.n "a") (e.ap2 (e.f "f") (e.n "a"))), e.n "a" ]
                    , e.n "s"
                    , e.ap2 (e.f "f") (e.n "t")
                    ]
                -- Optic (Star f) s t (f a) a -> s -> f t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- sequenceOf traversed (Just [1, 2]) == [Just 1, Just 2]
            -- sequence             (Just [1, 2]) == [Just 1, Just 2]
            -- An example with effects:

            -- > array = [random, random]
            -- > :t array
            -- Array (Eff ... Number)

            -- > effect = sequenceOf traversed array
            -- > :t effect
            -- Eff ... (Array Number)

            -- > effect >>= logShow
            -- [0.15556037108154985,0.28500369615270515]
            -- unit
        ,
            { name = "failover"
            , def =
                e.req1
                    (e.class1 "Alternative" (e.n "f"))
                    (e.fn
                        [ e.class "Optic"
                            [ e.br (e.class1 "Star" (e.br (e.class1 "Tuple" (e.br (e.class1 "Disj" (e.classE "Boolean"))))))
                            , e.n "s", e.n "t", e.n "a", e.n "a"
                            ]
                        , e.br (e.fn2 (e.n "a") (e.n "b"))
                        , e.n "s"
                        , e.ap2 (e.f "f") (e.n "t")
                        ]
                    )
                -- Alternative f => Optic (Star (Tuple (Disj Boolean))) s t a b -> (a -> b) -> s -> f t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "elementsOf"
            , def =
                e.req1
                    (e.class1 "Wander" (e.n "p"))
                    (e.fn
                        [ e.class "IndexedTraversal" [ e.n "i", e.n "s", e.n "t", e.n "a", e.n "a" ]
                        , e.br (e.fn2 (e.n "i") (e.classE "Boolean"))
                        , e.class "IndexedTraversal" [ e.n "p", e.n "i", e.n "s", e.n "t", e.n "a", e.n "a" ]
                        ]
                    )
                -- Wander p => IndexedTraversal i s t a a -> (i -> Boolean) -> IndexedOptic p i s t a a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "itraverseOf"
            , def =
                e.fn
                    [ e.class "IndexedTraversal" [ e.br (e.class1 "Star" (e.f "f")), e.n "s", e.n "t", e.n "a", e.n "a" ]
                    , e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.n "f") (e.n "b")))
                    , e.n "s"
                    , e.ap2 (e.f "f") (e.n "t")
                    ]
                -- IndexedOptic (Star f) i s t a b -> (i -> a -> f b) -> s -> f t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "iforOf"
            , def =
                e.fn
                    [ e.class "IndexedTraversal" [ e.br (e.class1 "Star" (e.f "f")), e.n "s", e.n "t", e.n "a", e.n "a" ]
                    , e.n "s"
                    , e.br (e.fn3 (e.n "i") (e.n "a") (e.ap2 (e.n "f") (e.n "b")))
                    , e.ap2 (e.f "f") (e.n "t")
                    ]
                -- IndexedOptic (Star f) i s t a b -> s -> (i -> a -> f b) -> f t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "cloneTraversal"
            , def =
                e.ap2
                    (e.class "ATraversal" [ e.n "s", e.n "t", e.n "a", e.n "a" ])
                    (e.class "Traversal" [ e.n "s", e.n "t", e.n "a", e.n "a" ])
                -- ATraversal s t a b -> Traversal s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "both"
            , def =
                e.req1
                    (e.class1 "Bitraversable" (e.n "r"))
                    (e.class "Traversal"
                        [ e.br (e.ap3 (e.n "r") (e.n "a") (e.n "a"))
                        , e.br (e.ap3 (e.n "r") (e.n "b") (e.n "b"))
                        , e.n "a"
                        , e.n "b"
                        ])
                -- Bitraversable r => Traversal (r a a) (r b b) a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in traversalpkg