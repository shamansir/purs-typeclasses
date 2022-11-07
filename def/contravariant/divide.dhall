let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Divide :: (Type -> Type) -> Constraint
-- class (Contravariant f) <= Divide f where

let divide : tc.TClass =
    { id = "divide"
    , name = "Divide"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "contravariant" ]
    , info = "Contravariant analogue of Apply"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Divide"
    , spec =
        d.class_vpc
            (d.id "divide")
            "Divide"
            [ d.v "f" ]
            [ d.p (d.id "contravariant") "Contravariant" [ d.v "f" ] ]
            d.t2c
    , members =
        [
            { name = "divide"
            , def =
                -- (a -> Tuple b c) -> f b -> f c -> f a
                e.fn
                    [ e.fn2 (e.n "a") (e.br (e.class "Tuple" [ e.n "b", e.n "c" ]))
                    , e.ap2 (e.f "f") (e.n "b")
                    , e.ap2 (e.f "f") (e.n "c")
                    , e.ap2 (e.f "f") (e.n "a")
                    ]
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "divided"
            , def =
                -- Divided f => f a -> f b -> f (Tuple a b)
                e.req1
                    (e.class1 "Decide" (e.n "f"))
                    (e.fn
                        [ e.ap2 (e.f "f") (e.n "b")
                        , e.ap2 (e.f "f") (e.n "a")
                        , e.ap2 (e.f "f") (e.br (e.class "Tuple" [ e.n "a", e.n "b" ]))
                        ]
                    )
            , belongs = tc.Belongs.No
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lr
                            { left =
                                 -- divided
                                e.callE "divided"
                            , right =
                                -- divide id
                                e.call1 "divide" (e.callE "idenity")
                            }
                        ]
                    }
                ]
            } /\ tc.noOps /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Divide" "Comparison"
        , i.instanceSubj "Divide" "Equivalence"
        , i.instanceSubj "Divide" "Predicate"
        , e.req1
            (e.class1 "Semigroup" (e.n "r"))
            (e.subj1 "Divide" (e.br (e.class1 "Op" (e.n "r")))) -- (Semigroup r) => Divide (Op r)
        ]
    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in divide