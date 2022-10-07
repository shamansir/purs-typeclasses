let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

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
            , def = e.subj1 "Additive" (e.n "a") -- Additive a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left = e.inf2 (e.subj1 "Additive" (e.n "x")) "<>" (e.subj1 "Additive" (e.n "y")) -- Additive x <> Additive y
            , right = e.subj1 "Additive" (e.br (e.inf2 (e.n "x") "+" (e.n "y"))) -- Additive (x + y)
            }
        ,
            { left = e.mdef1 "mempty" (e.subj1 "Additive" e.ph)  -- mempty :: Additive _
            , right = e.subj1 "Additive" (e.f "zero") -- Additive zero
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