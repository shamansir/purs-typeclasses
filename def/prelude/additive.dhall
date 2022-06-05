let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let additive : tc.TClass =
    { id = "additive"
    , name = "Additive"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "May be added to something"
    , module = [ "Data", "Monoid" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Additive#t:Additive"
    , members =
        [
            { name = "Additive"
            , def = "{{subj:Additive}} {{var:a}}" -- Additive a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left = "{{subj:Additive}} {{var:x}} {{op:<>}} {{subj:Additive}} {{var:y}}" -- Additive x <> Additive y
            , right = "{{subj:Additive}} ({{var:x}} {{op:+}} {{var:y}})" -- Additive (x + y)
            }
        ,
            { left = "{{method:mempty}} {{op:::}} {{subj:Additive}} {{var:_}}" -- mempty :: Additive _
            , right = "{{subj:Additive}} {{var:zero}}" -- Additive zero
            }
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Additive"
        , i.instanceReqA "Eq" "Additive"
        , i.instanceReqA "Ord" "Additive"
        , i.instanceReqA "Bounded" "Additive"
        , i.instance "Functor" "Additive"
        , i.instance "Invariant" "Additive"
        , i.instance "Apply" "Additive"
        , i.instance "Applicative" "Additive"
        , i.instance "Bind" "Additive"
        , i.instance "Monad" "Additive"
        , i.instance "Extend" "Additive"
        , i.instance "Comonad" "Additive"
        , i.instanceReqA "Show" "Additive"
        , i.instanceReqA2 "Semiring" "Semigroup" "Additive"
        , i.instanceReqA2 "Semiring" "Monoid" "Additive"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in additive