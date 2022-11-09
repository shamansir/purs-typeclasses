let tc = ./../../typeclass.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Compose :: forall k1 k2. (k2 -> Type) -> (k1 -> k2) -> k1 -> Type
-- newtype Compose f g a

let compose : tc.TClass =
    { spec = d.nt_c (d.id "compose") "Compose" [ d.v "f", d.v "g", d.v "a" ] d.k12kt
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , members =
        [
            { name = "Compose"
            , def =
                e.subj1 "Compose" (e.br (e.ap2 (e.t "f") (e.br (e.ap2 (e.t "g") (e.n "a")))))
                -- Compose (f (g a))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bihoistCompose"
            , def =
                e.req1
                    (e.class1 "Functor" (e.t "f"))
                    (e.fn3
                        (e.br (e.opc2 (e.t "f") "~>" (e.t "h")))
                        (e.br (e.opc2 (e.t "g") "~>" (e.t "i")))
                        (e.opc2
                            (e.br (e.class "Compose" [ e.t "f", e.t "g" ]))
                            "~>"
                            (e.br (e.class "Compose" [ e.t "h", e.t "i" ]))
                        )
                    )
                -- Functor f => (f ~> h) -> (g ~> i) -> (Compose f g) ~> (Compose h i)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ e.class "Newtype" [ e.br (e.class "Compose" [ e.t "f", e.t "g", e.n "a" ]), e.ph ] -- Newtype (Compose f g a) _
        -- TODO
        -- (Eq1 f, Eq1 g, Eq a) => Eq (Compose f g a)
        -- (Eq1 f, Eq1 g) => Eq1 (Compose f g)
        -- (Ord1 f, Ord1 g, Ord a) => Ord (Compose f g a)
        -- (Ord1 f, Ord1 g) => Ord1 (Compose f g)
        -- (Show (f (g a))) => Show (Compose f g a)
        -- (Functor f, Functor g) => Functor (Compose f g)
        -- (FunctorWithIndex a f, FunctorWithIndex b g) => FunctorWithIndex (Tuple a b) (Compose f g)
        -- (Apply f, Apply g) => Apply (Compose f g)
        -- (Applicative f, Applicative g) => Applicative (Compose f g)
        -- (Foldable f, Foldable g) => Foldable (Compose f g)
        -- (FoldableWithIndex a f, FoldableWithIndex b g) => FoldableWithIndex (Tuple a b) (Compose f g)
        -- (Traversable f, Traversable g) => Traversable (Compose f g)
        -- (TraversableWithIndex a f, TraversableWithIndex b g) => TraversableWithIndex (Tuple a b) (Compose f g)
        -- (Alt f, Functor g) => Alt (Compose f g)
        -- (Plus f, Functor g) => Plus (Compose f g)
        -- (Alternative f, Applicative g) => Alternative (Compose f g)
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in compose