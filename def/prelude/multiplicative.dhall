let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Multiplicative a

let multiplicative : tc.TClass =
    { id = "multiplicative"
    , name = "Multiplicative"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "May be multiplied on something"
    , module = [ "Data", "Monoid"]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Multiplicative"
    , spec = d.nt (d.id "multiplicative") "Multiplicative" [ d.v "a" ]
    , members =
        [
            { name = "Multiplicative"
            , def = e.subj1 "Multiplicative" (e.n "a") -- Multiplicative a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]
    , statements =
        [
            { left = e.opc2 (e.subj1 "Multiplicative" (e.n "x")) "<>" (e.subj1 "Multiplicative" (e.n "y")) -- Multiplicative x <> Multiplicative y
            , right = e.subj1 "Multiplicative" (e.br (e.opc2 (e.n "x") "*" (e.n "y"))) -- Multiplicative (x * y)
            }
        ,
            { left = e.mdef1 "mempty" (e.subj1 "Multiplicative" e.ph) -- mempty :: Multiplicative _
            , right = e.subj1 "Multiplicative" (e.callE "one") -- Multiplicative one
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