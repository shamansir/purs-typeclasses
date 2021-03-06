let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let multiplicative : tc.TClass =
    { id = "multiplicative"
    , name = "Multiplicative"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "May be multiplied on something"
    , module = [ "Data", "Monoid"]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Multiplicative"
    , members =
        [
            { name = "Multiplicative"
            , def = "{{subj:Multiplicative}} {{var:a}}" -- Multiplicative a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left = "{{subj:Multiplicative}} {{var:x}} {{op:<>}} {{subj:Multiplicative}} {{var:y}}" -- Multiplicative x <> Multiplicative y
            , right = "{{subj:Multiplicative}} ({{var:x}} {{op:*}} {{var:y}})" -- Multiplicative (x * y)
            }
        ,
            { left = "{{method:mempty}} {{op:::}} {{subj:Multiplicative}} {{var:_}}" -- mempty :: Multiplicative _
            , right = "{{subj:Multiplicative}} {{method:one}}" -- Multiplicative one
            }
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Multiplicative"
        , i.instanceReqA "Eq" "Multiplicative"
        , i.instanceReqA "Ord" "Multiplicative"
        , i.instanceReqA "Bounded" "Multiplicative"
        , i.instance "Functor" "Multiplicative"
        , i.instance "Invariant" "Multiplicative"
        , i.instance "Apply" "Multiplicative"
        , i.instance "Applicative" "Multiplicative"
        , i.instance "Bind" "Multiplicative"
        , i.instance "Monad" "Multiplicative"
        , i.instance "Extend" "Multiplicative"
        , i.instance "Comonad" "Multiplicative"
        , i.instanceReqA "Show" "Multiplicative"
        , i.instanceReqA2 "Semiring" "Semigroup" "Multiplicative"
        , i.instanceReqA2 "Semiring" "Monoid" "Multiplicative"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in multiplicative