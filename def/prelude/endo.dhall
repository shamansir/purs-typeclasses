let tc = ./../../typeclass.dhall

let endo : tc.TClass =
    { id = "endo"
    , name = "Endo"
    , what = tc.What.Newtype_
    , vars = [ "c", "a" ]
    , info = "By itself"
    , module = [ "Data", "Monoid" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Endo"
    , statements =
        [
            { left = "{{subj:Endo}} {{fvar:f}} {{op:<>}} {{subj:Endo}} {{fvar:g}}" -- Endo f <> Endo g
            , right = "{{subj:Endo}} ({{fvar:f}} {{op:<<<}} {{fvar:g}})" -- Endo (f <<< g)
            }
        ,
            { left = "{{method:mempty}} {{op:::}} {{subj:Endo}} {{var:_}}" -- mempty :: Endo _
            , right = "{{subj:Endo}} {{method:identity}}" -- Endo id
            }
        ]
    , members =
        [
            { name = "Endo"
            , def = "{{subj:Endo}} ({{typevar:c}} {{var:a}} {{var:a}})" -- Endo (c a a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "({{class:Eq}} ({{typevar:c}} {{var:a}} {{var:a}})) {{op:=>}} {{class:Eq}} ({{subj:Endo}} {{typevar:c}} {{var:a}})" -- (Eq (c a a)) => Eq (Endo c a)
        , "({{class:Ord}} ({{typevar:c}} {{var:a}} {{var:a}})) {{op:=>}} {{class:Ord}} ({{subj:Endo}} {{typevar:c}} {{var:a}})" -- (Ord (c a a)) => Ord (Endo c a)
        , "({{class:Bounded}} ({{typevar:c}} {{var:a}} {{var:a}})) {{op:=>}} {{class:Bounded}} ({{subj:Endo}} {{typevar:c}} {{var:a}})" -- (Bounded (c a a)) => Bounded (Endo c a)
        , "({{class:Show}} ({{typevar:c}} {{var:a}} {{var:a}})) {{op:=>}} {{class:Show}} ({{subj:Endo}} {{typevar:c}} {{var:a}})" -- (Show (c a a)) => Show (Endo c a)
        , "({{class:Semigroupoid}} {{typevar:c}}) {{op:=>}} {{class:Semigroup}} ({{subj:Endo}} {{var:c}} {{var:a}})" -- (Semigroupoid c) => Semigroup (Endo c a)
        , "({{class:Category}} {{typevar:c}}) {{op:=>}} {{class:Monoid}} ({{subj:Endo}} {{typevar:c}} {{var:a}})" -- (Category c) => Monoid (Endo c a)
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in endo