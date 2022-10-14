let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class Invariant :: (Type -> Type) -> Constraint
-- class Invariant f where

let invariant : tc.TClass =
    { id = "invariant"
    , name = "Invariant"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pkmj "purescript-invariant" +5
    , link = "purescript-invariant/5.0.0/docs/Data.Functor.Invariant#t:Invariant"
    , members =
        [
            { name = "imap"
            , def =
                e.fn
                    [ e.br (e.fn2 (e.n "a") (e.n "b"))
                    , e.br (e.fn2 (e.n "b") (e.n "a"))
                    , e.ap2 (e.f "f") (e.n "a")
                    , e.ap2 (e.f "f") (e.n "b")
                    ]
                -- (a -> b) -> (b -> a) -> f a -> f b
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ,
            { name = "imapF"
            , def =
                e.req1
                    (e.subj1 "Functor" (e.f "f"))
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.n "b"))
                        , e.br (e.fn2 (e.n "b") (e.n "a"))
                        , e.ap2 (e.f "f") (e.n "a")
                        , e.ap2 (e.f "f") (e.n "b")
                        ]
                    )
                --  Functor f => (a -> b) -> (b -> a) -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubjA "Function" "Invariant"
        , i.instanceSubj "Array" "Invariant"
        , i.instanceSubj "Additive" "Invariant"
        , i.instanceSubj "Conj" "Invariant"
        , i.instanceSubj "Disj" "Invariant"
        , i.instanceSubj "Dual" "Invariant"
        , i.instanceSubjA2 "Endo" "Function" "Invariant"
        , i.instanceSubj "Multiplicative" "Invariant"
        , i.instanceReqASubj "Alternate" "Invariant"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in invariant