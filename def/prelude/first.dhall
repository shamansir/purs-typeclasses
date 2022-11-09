let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype First a

let first : tc.TClass =
    { spec = d.nt (d.id "first") "First" [ d.v "a" ]
    , info = "Semigroup where append always takes the first option"
    , module = [ "Data", "Semigroup" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "First"
            , def = e.subj1 "First" (e.n "a") -- First a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]
    , statements =
        [
            { left =
                e.opc2
                    (e.subj1 "First" (e.n "x"))
                    "<>"
                    (e.subj1 "First" (e.n "y"))
            , right =
                e.subj1 "First" (e.n "y")
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

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues

in first