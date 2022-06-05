let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let first : tc.TClass =
    { id = "first"
    , name = "First"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "Semigroup where append always takes the first option"
    , module = [ "Data", "Semigroup" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Semigroup.First"
    , members =
        [
            { name = "First"
            , def = "{{subj:First}} {{var:a}}" -- First a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left = "{{subj:First}} {{var:x}} {{op:<>}} {{subj:First}} {{var:y}}" -- First x <> First y
            , right = "{{subj:First}} {{var:y}}" -- First y
            }
        ]
    , instances =
        [ i.instanceReqA "Eq" "First"
        , i.instance "Eq1" "First"
        , i.instanceReqA "Ord" "First"
        , i.instance "Ord1" "First"
        , i.instanceReqA "Bounded" "First"
        , i.instanceReqA "Show" "First"
        , i.instance "Functor" "First"
        , i.instance "Apply" "First"
        , i.instance "Applicative" "First"
        , i.instance "Bind" "First"
        , i.instance "Monad" "First"
        , i.instanceA "Semigroup" "First"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in first