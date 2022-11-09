let tc = ./../../typeclass.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Coproduct :: forall k. (k -> Type) -> (k -> Type) -> k -> Type
-- newtype Coproduct f g a

let coproduct : tc.TClass =
    { spec = d.nt_c (d.id "coproduct") "Coproduct" [ d.v "f", d.v "g", d.v "a" ] d.kt_kt_kt
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , members =
        [
            { name = "Coproduct"
            , def =
                e.subj1
                    "Coproduct"
                    (e.br
                        (e.class "Either"
                            [ e.br (e.ap2 (e.f "f") (e.n "a"))
                            , e.br (e.ap2 (e.f "g") (e.n "a"))
                            ]
                        )
                    )
                -- Coproduct (Either (f a) (g a))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "left"
            , def =
                e.fn2
                    (e.ap2 (e.f "f") (e.n "a"))
                    (e.subj "Coproduct" [ e.f "f", e.f "g", e.n "a" ])
                -- f a -> Coproduct f g a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "right"
            , def =
                e.fn2
                    (e.ap2 (e.f "g") (e.n "a"))
                    (e.subj "Coproduct" [ e.f "f", e.f "g", e.n "a" ])
                -- g a -> Coproduct f g a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "coproduct"
            , def =
                e.fn
                    [ e.br (e.fn2 (e.ap2 (e.f "f") (e.n "a")) (e.n "b"))
                    , e.br (e.fn2 (e.ap2 (e.f "g") (e.n "a")) (e.n "b"))
                    , e.subj "Coproduct" [ e.f "f", e.f "g", e.n "a" ]
                    , e.n "b"
                    ]
                -- (f a -> b) -> (g a -> b) -> Coproduct f g a -> b
            , belongs = tc.Belongs.No
            , op = Some "<\\/>" -- defined in Data.Functor.Coproduct.Nested
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bihoistCoproduct"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.t "f") "~>" (e.t "h")))
                    (e.br (e.opc2 (e.t "g") "~>" (e.t "i")))
                    (e.opc2
                        (e.br (e.class "Coproduct" [ e.t "f", e.t "g" ]))
                        "~>"
                        (e.br (e.class "Coproduct" [ e.t "h", e.t "i" ]))
                    )
                -- (f ~> h) -> (g ~> i) -> (Coproduct f g) ~> (Coproduct h i)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ e.class "Newtype" [ e.br (e.class "Coproduct" [ e.t "f", e.t "g", e.n "a" ]), e.ph ] -- Newtype (Coproduct f g a) _
        -- TODO
        -- (Eq1 f, Eq1 g, Eq a) => Eq (Coproduct f g a)
        -- (Eq1 f, Eq1 g) => Eq1 (Coproduct f g)
        -- (Ord1 f, Ord1 g, Ord a) => Ord (Coproduct f g a)
        -- (Ord1 f, Ord1 g) => Ord1 (Coproduct f g)
        -- (Show (f a), Show (g a)) => Show (Coproduct f g a)
        -- (Functor f, Functor g) => Functor (Coproduct f g)
        -- (FunctorWithIndex a f, FunctorWithIndex b g) => FunctorWithIndex (Either a b) (Coproduct f g)
        -- (Extend f, Extend g) => Extend (Coproduct f g)
        -- (Comonad f, Comonad g) => Comonad (Coproduct f g)
        -- (Foldable f, Foldable g) => Foldable (Coproduct f g)
        -- (FoldableWithIndex a f, FoldableWithIndex b g) => FoldableWithIndex (Either a b) (Coproduct f g)
        -- (Traversable f, Traversable g) => Traversable (Coproduct f g)
        -- (TraversableWithIndex a f, TraversableWithIndex b g) => TraversableWithIndex (Either a b) (Coproduct f g)
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in coproduct