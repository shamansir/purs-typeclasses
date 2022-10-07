let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let disj : tc.TClass =
    { id = "disj"
    , name = "Disj"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "Monoid under disjunction"
    , module = [ "Data", "Monoid" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Disj"
    , members =
        [
            { name = "Disj a"
            , def =  e.subj1 "Disj" (e.n "a") -- Disj a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left =
                e.inf2
                    (e.subj1 "Disj" (e.n "x"))
                    "<>"
                    (e.subj1 "Disj" (e.n "y"))
                    -- Disj x <> Disj y
            , right =
                e.subj1
                    "Disj"
                    (e.br (e.inf2 (e.n "x") "||" (e.n "y")))
                -- Disj (x || y)
            }
        ,
            { left =
                e.mdef1 "mempty" (e.subj1 "Disj" e.ph)
                -- mempty :: Disj _
            , right =
                e.subj1 "Disj" (e.callE "bottom")
            }
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Disj"
        , i.instanceReqA "Eq" "Disj"
        , i.instanceReqA "Ord" "Disj"
        , i.instanceReqA "Bounded" "Disj"
        , i.instance "Functor" "Disj"
        , i.instance "Invariant" "Disj"
        , i.instance "Apply" "Disj"
        , i.instance "Applicative" "Disj"
        , i.instance "Bind" "Disj"
        , i.instance "Monad" "Disj"
        , i.instance "Extend" "Disj"
        , i.instance "Comonad" "Disj"
        , i.instanceReqA "Show" "Disj"
        , i.instanceReqA2 "HeytingAlgebra" "Semigroup" "Disj"
        , i.instanceReqA2 "HeytingAlgebra" "Monoid" "Disj"
        , i.instanceReqA2 "HeytingAlgebra" "Semiring" "Disj"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in disj