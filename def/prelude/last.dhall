let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let last : tc.TClass =
    { id = "last"
    , name = "Last"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "Semigroup where append always takes the second option"
    , module = [ "Data", "Semigroup" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Semigroup.Last"
    , members =
        [
            { name = "Last"
            , def = "{{subj:Last}} {{var:a}}" -- Last a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left = "{{subj:Last}} {{var:x}} {{op:<>}} {{subj:Last}} {{var:y}}" -- Last x <> Last y
            , right = "{{subj:Last}} {{var:y}}" -- Last y
            }
        ]
    , instances =
        [ i.instanceReqA "Eq" "Last"
        , i.instance "Eq1" "Last"
        , i.instanceReqA "Ord" "Last"
        , i.instance "Ord1" "Last"
        , i.instanceReqA "Bounded" "Last"
        , i.instanceReqA "Show" "Last"
        , i.instance "Functor" "Last"
        , i.instance "Apply" "Last"
        , i.instance "Applicative" "Last"
        , i.instance "Bind" "Last"
        , i.instance "Monad" "Last"
        , i.instanceA "Semigroup" "Last"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in last