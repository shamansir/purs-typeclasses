let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let dual : tc.TClass =
    { id = "dual"
    , name = "Dual"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "Monoid under dualism"
    , module = [ "Data", "Monoid" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Dual"
    , members =
        [
            { name = "Dual a"
            , def = "{{subj:Dual}} {{var:a}}" -- Dual a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left = "{{subj:Dual}} {{var:x}} {{op:<>}} {{subj:Dual}} {{var:y}}" -- Dual x <> Dual y
            , right = "{{subj:Dual}} ({{var:y}} {{op:<>}} {{var:x}})" -- Dual (y <> x)
            }
        ,
            { left = "{{method:mempty}} {{op:::}} {{subj:Dual}} {{var:_}}" -- mempty :: Dual _
            , right = "{{subj:Dual}} {{method:mempty}}" -- Dual mempty
            }
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Dual"
        , i.instanceReqA "Eq" "Dual"
        , i.instanceReqA "Ord" "Dual"
        , i.instanceReqA "Bounded" "Dual"
        , i.instance "Functor" "Dual"
        , i.instance "Invariant" "Dual"
        , i.instance "Apply" "Dual"
        , i.instance "Applicative" "Dual"
        , i.instance "Bind" "Dual"
        , i.instance "Monad" "Dual"
        , i.instance "Extend" "Dual"
        , i.instance "Comonad" "Dual"
        , i.instanceReqA "Show" "Dual"
        , i.instanceReqA "Semigroup" "Dual"
        , i.instanceReqA "Monoid" "Dual"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in dual