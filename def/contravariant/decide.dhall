let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Decide :: (Type -> Type) -> Constraint
-- class (Divide f) <= Decide f where

let decide : tc.TClass =
    { id = "decide"
    , name = "Decide"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "divide" ]
    , info = "Contravariant analogue of Alt"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Decide"
    , spec =
        d.class_vpc
            (d.id "decide")
            "Decide"
            [ d.v "f" ]
            [ d.p (d.id "divide") "Divide" [ d.v "f" ] ]
            d.t2c
    , members =
        [
            { name = "choose"
            , def =
                -- (a -> Either b c) -> f b -> f c -> f a
                e.fn
                    [ e.br (e.fn2 (e.n "a") (e.class "Either" [ e.n "b", e.n "c" ]))
                    , e.ap2 (e.f "f") (e.n "b")
                    , e.ap2 (e.f "f") (e.n "c")
                    , e.ap2 (e.f "f") (e.n "a")
                    ]
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "chosen"
            , def =
                -- Decide f => f a -> f b -> f (Either a b)
                e.req1
                    (e.subj1 "Decide" (e.n "f"))
                    (e.fn
                        [ e.ap2 (e.f "f") (e.n "b")
                        , e.ap2 (e.f "f") (e.n "a")
                        , e.ap2 (e.n "a") (e.br (e.class "Either" [ e.n "a", e.n "b" ]))
                        ]
                    )
            , belongs = tc.Belongs.No
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lr
                            { left =
                                 -- chosen
                                e.callE "chosen"
                            , right =
                                -- chose id
                                e.call1 "chose" (e.callE "identity")
                            }
                        ]
                    }
                ]
            } /\ tc.noOps /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Decide" "Comparison"
        , i.instanceSubj "Decide" "Equivalence"
        , i.instanceSubj "Decide" "Predicate"
        , e.req1
            (e.br (e.class1 "Semigroup" (e.n "r" )))
            (e.subj1 "Decide" (e.br (e.class1 "Op" (e.n "r")))) -- (Semigroup r) => Decide (Op r)
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in decide