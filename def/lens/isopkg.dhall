let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let istab = e.class "Iso" [ e.n "s", e.n "t", e.n "a", e.n "b" ] -- Iso s t a b
let anistab = e.class "AnIso" [ e.n "s", e.n "t", e.n "a", e.n "b" ] -- AnIso s t a b
let anissttaabb = e.class "AnIso" [ e.n "ss", e.n "tt", e.n "aa", e.n "bb" ] -- AnIso ss tt aa bb

let isopkg : tc.TClass =
    { id = "isopkg"
    , name = "Lens.Iso"
    , what = tc.What.Package_
    , info = "Functions for working with isomorphisms"
    , module = [ "Data", "Lens", "Iso" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Common"
    , spec = d.pkg (d.id "isopkg") "Lens.Iso"
    , members =
        [
            { name = "iso"
            , def =
                e.fn3
                    (e.br (e.fn2 (e.n "s") (e.n "a")))
                    (e.br (e.fn2 (e.n "b") (e.n "t")))
                    istab
                -- (s -> a) -> (b -> t) -> Iso s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withIso"
            , def =
                e.fn3
                    anistab
                    (e.br (e.fn3
                        (e.br (e.fn2 (e.n "s") (e.n "a")))
                        (e.br (e.fn2 (e.n "b") (e.n "t")))
                        istab
                    ))
                    (e.n "r")
                -- AnIso s t a b -> ((s -> a) -> (b -> t) -> r) -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "cloneIso"
            , def = e.fn2 anistab istab
                -- AnIso s t a b -> Iso s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "re"
            , def =
                e.fn2
                    (e.class "Optic"
                        [ e.br (e.class "Re" [ e.n "p", e.n "a", e.n "b" ])
                        , e.n "s", e.n "t", e.n "a", e.n "b"
                        ])
                    (e.class "Optic" [ e.n "p" , e.n "s", e.n "t", e.n "a", e.n "b" ])
                -- Optic (Re p a b) s t a b -> Optic p b a t s
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "au"
            , def =
                e.fn
                    [ anistab
                    , e.br (e.fn3
                        (e.br (e.fn2 (e.n "b") (e.n "t")))
                        (e.n "e")
                        (e.n "s")
                    )
                    , e.n "e"
                    , e.n "a"
                    ]
                -- AnIso s t a b -> ((b -> t) -> e -> s) -> e -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "auf"
            , def =
                e.req1
                    (e.class1 "Profunctor" (e.t "p"))
                    (e.fn
                        [ anistab
                        , e.br (e.fn3
                            (e.ap3 (e.t "p") (e.n "r") (e.n "a"))
                            (e.n "e")
                            (e.n "b")
                        )
                        , e.ap3 (e.t "p") (e.n "r") (e.n "s")
                        , e.n "e"
                        , e.n "t"
                        ]
                    )
                -- Profunctor p => AnIso s t a b -> (p r a -> e -> b) -> p r s -> e -> t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "under"
            , def =
                e.fn
                    [ anistab
                    , e.br (e.fn2 (e.n "t") (e.n "s"))
                    , e.n "b"
                    , e.n "a"
                    ]
                -- AnIso s t a b -> (t -> s) -> b -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "non"
            , def =
                e.req1
                    (e.class1 "Eq" (e.n "a"))
                    (e.fn2
                        (e.n "a")
                        (e.class "Iso'" [ e.br (e.class1 "Maybe" (e.n "a")), e.n "a" ])
                    )
                -- Eq a => a -> Iso' (Maybe a) a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "curried"
            , def =
                e.class "Iso"
                    [ e.br (e.fn2 (e.class "Tuple" [ e.n "a", e.n "b" ]) (e.n "c"))
                    , e.br (e.fn2 (e.class "Tuple" [ e.n "d", e.n "e" ]) (e.n "f"))
                    , e.br (e.fn3 (e.n "a") (e.n "b") (e.n "c"))
                    , e.br (e.fn3 (e.n "d") (e.n "e") (e.n "f"))
                    ]
                -- Iso (Tuple a b -> c) (Tuple d e -> f) (a -> b -> c) (d -> e -> f)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "uncurried"
            , def =
                e.class "Iso"
                    [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "c"))
                    , e.br (e.fn3 (e.n "d") (e.n "e") (e.n "f"))
                    , e.br (e.fn2 (e.class "Tuple" [ e.n "a", e.n "b" ]) (e.n "c"))
                    , e.br (e.fn2 (e.class "Tuple" [ e.n "d", e.n "e" ]) (e.n "f"))
                    ]
                -- Iso (a -> b -> c) (d -> e -> f) (Tuple a b -> c) (Tuple d e -> f)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "flipped"
            , def =
                e.class "Iso"
                    [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "c"))
                    , e.br (e.fn3 (e.n "d") (e.n "e") (e.n "f"))
                    , e.br (e.fn3 (e.n "b") (e.n "a") (e.n "c"))
                    , e.br (e.fn3 (e.n "e") (e.n "d") (e.n "f"))
                    ]
                -- Iso (a -> b -> c) (d -> e -> f) (b -> a -> c) (e -> d -> f)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mapping"
            , def =
                e.reqseq
                    [ e.class1 "Functor" (e.f "f"), e.class1 "Functor" (e.f "g") ]
                    (e.fn2
                        anistab
                        (e.class "Iso"
                            [ e.br (e.ap2 (e.f "f") (e.n "s"))
                            , e.br (e.ap2 (e.f "g") (e.n "t"))
                            , e.br (e.ap2 (e.f "f") (e.n "a"))
                            , e.br (e.ap2 (e.f "g") (e.n "b"))
                            ]
                        )
                    )
                -- Functor f => Functor g => AnIso s t a b -> Iso (f s) (g t) (f a) (g b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "dimapping"
            , def =
                e.reqseq
                    [ e.class1 "Profunctor" (e.f "p"), e.class1 "Profunctor" (e.f "q") ]
                    (e.fn3
                        anistab
                        anissttaabb
                        (e.class "Iso"
                            [ e.br (e.ap3 (e.f "p") (e.n "a") (e.n "ss"))
                            , e.br (e.ap3 (e.f "q") (e.n "b") (e.n "tt"))
                            , e.br (e.ap3 (e.f "p") (e.n "s") (e.n "aa"))
                            , e.br (e.ap3 (e.f "q") (e.n "t") (e.n "bb"))
                            ]
                        )
                    )
                -- Profunctor p => Profunctor q => AnIso s t a b -> AnIso ss tt aa bb -> Iso (p a ss) (q b tt) (p s aa) (q t bb)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "coerced"
            , def =
                e.reqseq
                    [ e.class "Coercible" [ e.n "s", e.n "a" ], e.class "Coercible" [ e.n "t", e.n "b" ] ]
                    istab
                -- Coercible s a => Coercible t b => Iso s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- newtype UserId = UserId Int
            -- newtype DeletedUserId = DeletedUserId UserId

            -- `simple` is used to aid the type inference
            -- deletedUser :: DeletedUserId
            -- deletedUser = review (simple coerced) 42
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in isopkg