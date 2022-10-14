let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

-- newtype Flip :: forall k1 k2. (k1 -> k2 -> Type) -> k2 -> k1 -> Type
-- newtype Flip p a b

let flip : tc.TClass =
    { id = "fllip"
    , name = "Flip"
    , what = tc.What.Newtype_
    , vars = [ "p", "a", "b" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Flip"
    , members =
        [
            { name = "Flip"
            , def =
                e.subj1 "Flip" (e.br (e.ap3 (e.t "p") (e.t "b") (e.n "a")))
                -- Flip (p b a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ e.class "Newtype" [ e.br (e.class "Flip" [ e.t "p", e.n "a", e.n "b" ]), e.ph ] -- Newtype (Flip p a b) _
        -- (Eq (p b a)) => Eq (Flip p a b)
        -- (Ord (p b a)) => Ord (Flip p a b)
        -- (Show (p a b)) => Show (Flip p b a)
        -- (Bifunctor p) => Functor (Flip p a)
        -- (Bifunctor p) => Bifunctor (Flip p)
        -- (Biapply p) => Biapply (Flip p)
        -- (Biapplicative p) => Biapplicative (Flip p)
        -- (Profunctor p) => Contravariant (Flip p b)
        -- (Semigroupoid p) => Semigroupoid (Flip p)
        -- (Category p) => Category (Flip p)
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in flip