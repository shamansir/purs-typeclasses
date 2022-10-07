let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
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
            , def = e.subj1 "Conj" (e.n "a") -- Conj a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left =
                e.opc2
                    (e.subj1 "Conj" (e.n "x"))
                    "<>"
                    (e.subj1 "Conj" (e.n "y"))
                -- Conj x <> Conj y
            , right =
                e.subj1
                    "Conj"
                    (e.br (e.opc2 (e.n "x") "&&" (e.n "y")))
                -- Conj (x && y)
            }
        ,
            { left =
                e.mdef1 "mempty" (e.subj1 "Conj" e.ph)
                -- mempty :: Conj _
            , right =
                e.subj1 "Conj" (e.callE "top")
                    -- Conj top
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