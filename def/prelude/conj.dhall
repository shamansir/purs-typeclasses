let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let conj : tc.TClass =
    { id = "conj"
    , name = "Conj"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "Monoid under conjunction"
    , module = [ "Data", "Monoid" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Conj"
    , members =
        [
            { name = "Conj a"
            , def = "{{subj:Conj}} {{var:a}}" -- Conj a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left = "{{subj:Conj}} {{var:x}} {{op:<>}} {{subj:Conj}} {{var:y}}" -- Conj x <> Conj y
            , right = "{{subj:Conj}} ({{var:x}} {{op:&&}} {{var:y}})" -- Conj (x && y)
            }
        ,
            { left = "{{method:mempty}} {{op:::}} {{subj:Conj}} {{var:_}}" -- mempty :: Conj _
            , right = "{{subj:Conj}} {{method:top}}" -- Conj top
            }
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Conj"
        , i.instanceReqA "Eq" "Conj"
        , i.instanceReqA "Ord" "Conj"
        , i.instanceReqA "Bounded" "Conj"
        , i.instance "Functor" "Conj"
        , i.instance "Invariant" "Conj"
        , i.instance "Apply" "Conj"
        , i.instance "Applicative" "Conj"
        , i.instance "Bind" "Conj"
        , i.instance "Monad" "Conj"
        , i.instance "Extend" "Conj"
        , i.instance "Comonad" "Conj"
        , i.instanceReqA "Show" "Conj"
        , i.instanceReqA2 "HeytingAlgebra" "Semigroup" "Conj"
        , i.instanceReqA2 "HeytingAlgebra" "Monoid" "Conj"
        , i.instanceReqA2 "HeytingAlgebra" "Semiring" "Conj"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in conj