let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall


-- newtype Additive a

let additive : tc.TClass =
    { id = "additive"
    , name = "Additive"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "May be added to something"
    , module = [ "Data", "Monoid" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Additive#t:Additive"
    , def = d.nt (d.id "additive") "Additive" [ d.v "a" ]
    , members =
        [
            { name = "Additive"
            , def = e.subj1 "Additive" (e.n "a") -- Additive a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]
    , statements =
        [
            { left = e.opc2 (e.subj1 "Additive" (e.n "x")) "<>" (e.subj1 "Additive" (e.n "y")) -- Additive x <> Additive y
            , right = e.subj1 "Additive" (e.br (e.opc2 (e.n "x") "+" (e.n "y"))) -- Additive (x + y)
            }
        ,
            { left = e.mdef1 "mempty" (e.subj1 "Additive" e.ph)  -- mempty :: Additive _
            , right = e.subj1 "Additive" (e.callE "zero") -- Additive zero
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
    : tc.TClass

in additive