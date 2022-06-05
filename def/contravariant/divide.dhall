let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let divide : tc.TClass =
    { id = "divide"
    , name = "Divide"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "contravariant" ]
    , info = "Contravariant analogue of Apply"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Divide"
    , members =
        [
            { name = "divide"
            , def =
                -- (a -> Tuple b c) -> f b -> f c -> f a
                (e.fnvs
                    [ e.fn_ [ e.n "a", e.rv (e.class_ "Tuple" [ e.n "b", e.n "c" ]) ]
                    , e.ap1_ (e.f "f") (e.n "b")
                    , e.ap1_ (e.f "f") (e.n "c")
                    , e.ap1_ (e.f "f") (e.n "a")
                    ]
                )
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "divided"
            , def =
                -- Divided f => f a -> f b -> f (Tuple a b)
                e.req1
                    (e.class_ "Decide" [ e.n "f" ])
                    (e.rtv
                        (e.fnvs
                            [ e.ap1_ (e.f "f") (e.n "b")
                            , e.ap1_ (e.f "f") (e.n "a")
                            , e.ap1_ (e.n "a") (e.rv (e.class_ "Tuple" [ e.n "a", e.n "b" ]))
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lr
                            { left =
                                 -- divided
                                e.val
                                    (e.callE "divided")
                            , right =
                                -- divide id
                                e.val
                                    (e.call1_ "divide" (e.rv (e.callE "idenity")))
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ]
    , instances =
        [ i.instanceSubj "Divide" "Comparison"
        , i.instanceSubj "Divide" "Equivalence"
        , i.instanceSubj "Divide" "Predicate"
        , e.req1
            (e.class_ "Semigroup" [ e.n "r" ])
            (e.subj_ "Divide" [ e.rv (e.class1_ "Op" (e.n "r")) ]) -- (Semigroup r) => Divide (Op r)
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in divide