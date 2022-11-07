let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Last a

let last : tc.TClass =
    { id = "last"
    , name = "Last"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "Semigroup where append always takes the second option"
    , module = [ "Data", "Semigroup" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Semigroup.Last"
    , spec = d.nt (d.id "last") "Last" [ d.v "a" ]
    , members =
        [
            { name = "Last"
            , def = e.subj1 "Last" (e.n "a") -- Last a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]
    , statements =
        [
            { left =
                e.opc2
                    (e.subj1 "Last" (e.n "x"))
                    "<>"
                    (e.subj1 "Last" (e.n "y"))
                -- Last x <> Last y
            , right = e.subj1 "Last" (e.n "y") -- Last y
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

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in last