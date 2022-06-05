let tc = ./../../typeclass.dhall

let join : tc.TClass =
    { id = "join"
    , name = "Join"
    , what = tc.What.Newtype_
    , vars = [ "p", "a" ]
    , info = ""
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Join"
    , members =
        [
            { name = "Join"
            , def = "{{subj:Join}} ({{typevar:p}} {{var:a}} {{var:a}})" -- Join (p a a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Join}} {{typevar:p}} {{var:a}}) {{var:_}}" -- Newtype (Join p a) _
        , "({{class:Eq}} ({{typevar:p}} {{var:a}} {{var:a}})) {{op:=>}} {{class:Eq}} ({{subj:Join}} {{typevar:p}} {{var:a}})" -- (Eq (p a a)) => Eq (Join p a)
        , "({{class:Ord}} ({{typevar:p}} {{var:a}} {{var:a}})) {{op:=>}} {{class:Ord}} ({{subj:Join}} {{typevar:p}} {{var:a}})" -- (Ord (p a a)) => Ord (Join p a)
        , "({{class:Show}} ({{typevar:p}} {{var:a}} {{var:a}})) {{op:=>}} {{class:Show}} ({{subj:Join}} {{typevar:p}} {{var:a}})" -- (Show (p a a)) => Show (Join p a)
        , "({{class:Semigroupoid}} {{typevar:p}}) {{op:=>}} {{class:Semigroup}} ({{subj:Join}} {{var:p}} {{var:a}})" -- (Semigroupoid p) => Semigroup (Join p a)
        , "({{class:Category}} {{typevar:p}}) {{op:=>}} {{class:Monoid}} ({{subj:Join}} {{typevar:p}} {{var:a}})" -- (Category p) => Monoid (Join p a)
        , "({{class:Profunctor}} {{typevar:p}}) {{op:=>}} {{class:Invariant}} ({{subj:Join}} {{typevar:p}})" -- (Profunctor p) => Invariant (Join p)
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents /\ tc.noStatements

in join