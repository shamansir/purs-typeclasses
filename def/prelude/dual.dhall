let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Dual a

let dual : tc.TClass =
    { id = "dual"
    , name = "Dual"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "Monoid under dualism"
    , module = [ "Data", "Monoid" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Dual"
    , spec = d.nt (d.id "dual") "Dual" [ d.v "a" ]
    , members =
        [
            { name = "Dual a"
            , def = e.subj1 "Dual" (e.n "a") -- Dual a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]
    , statements =
        [
            { left =
                e.opc2
                    (e.subj1 "Dual" (e.n "x"))
                    "<>"
                    (e.subj1 "Dual" (e.n "y"))
                -- Dual x <> Dual y
            , right =
                e.subj1
                    "Dual"
                    (e.br (e.opc2 (e.n "x") "<>" (e.n "y")))
                -- Dual (y <> x)
            }
        ,
            { left =
                e.mdef1 "mempty" (e.subj1 "Dual" e.ph)
                -- mempty :: Dual _
            , right =
                e.subj1 "Dual" (e.callE "mempty")
                -- Dual mempty
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