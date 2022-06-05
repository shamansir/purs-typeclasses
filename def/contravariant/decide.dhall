let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let decide : tc.TClass =
    { id = "decide"
    , name = "Decide"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "divide" ]
    , info = "Contravariant analogue of Alt"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Decide"
    , members =
        [
            { name = "choose"
            , def =
                -- (a -> Either b c) -> f b -> f c -> f a
                (e.fnvs
                    [ e.fn_ [ e.n "a", e.rv (e.class_ "Either" [ e.n "b", e.n "c" ]) ]
                    , e.ap1_ (e.f "f") (e.n "b")
                    , e.ap1_ (e.f "f") (e.n "c")
                    , e.ap1_ (e.f "f") (e.n "a")
                    ]
                )
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "chosen"
            , def =
                -- Decide f => f a -> f b -> f (Either a b)
                e.req1
                    (e.class_ "Decide" [ e.n "f" ])
                    (e.rtv
                        (e.fnvs
                            [ e.ap1_ (e.f "f") (e.n "b")
                            , e.ap1_ (e.f "f") (e.n "a")
                            , e.ap1_ (e.n "a") (e.rv (e.class_ "Either" [ e.n "a", e.n "b" ]))
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
                                 -- chosen
                                e.val
                                    (e.callE "chosen")
                            , right =
                                -- chose id
                                e.val
                                    (e.call1_ "chose" (e.rv (e.callE "idenity")))
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ]
    , instances =
        [ i.instanceSubj "Decide" "Comparison"
        , i.instanceSubj "Decide" "Equivalence"
        , i.instanceSubj "Decide" "Predicate"
        , e.req1
            (e.class_ "Semigroup" [ e.n "r" ])
            (e.subj_ "Decide" [ e.rv (e.class1_ "Op" (e.n "r")) ]) -- (Semigroup r) => Decide (Op r)
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in decide