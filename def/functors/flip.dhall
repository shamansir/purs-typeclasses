let tc = ./../../typeclass.dhall

let flip : tc.TClass =
    { id = "fllip"
    , name = "Flip"
    , what = tc.What.Newtype_
    , vars = [ "p", "a", "b" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Flip"
    , members =
        [
            { name = "Flip"
            , def = "{{subj:Flip}} ({{fvar:p}} {{var:b}} {{var:a}})" -- Flip (p b a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Flip}} {{fvar:p]}} {{var:a}} {{var:b}}) {{var:_}}" -- Newtype (Flip p a b) _
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