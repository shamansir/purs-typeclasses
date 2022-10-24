let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- class Bifunctor :: (Type -> Type -> Type) -> Constraint
-- class Bifunctor f where

let bifunctor : tc.TClass =
    { id = "bifunctor"
    , name = "Bifunctor"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = "Functor from the Pair category"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-bifunctors" +5
    , link = "purescript-bifunctors/5.0.0/docs/Data.Bifunctor"
    , def =
        d.class_vc
            (d.id "bifunctor")
            "Bifunctor"
            [ d.v "w" ]
            [ d.cfn_br d.cctype3, d.ccon ]
    , laws =
        [
            { law = "identity"
            , examples =
                [ tc.lr
                    { left = e.call "bimap" [ e.callE "idenity", e.callE "identity" ]  -- bimap identity identity
                    , right = e.callE "identity" -- identity
                    }
                ]
            }
        ,
            { law = "composition"
            , examples =
                [ tc.lr
                    { left =
                        -- bimap f1 g1 <<< bimap f2 g2
                        e.opc2
                            (e.call "bimap" [ e.f "f1", e.f "g1" ])
                            "<<<"
                            (e.call "bimap" [ e.f "f2", e.f "g2" ])
                    , right =
                         -- bimap (f1 <<< f2) (g1 <<< g2)
                        e.call
                            "bimap"
                            [ e.br (e.opc2 (e.f "f1") "<<<" (e.f "f2"))
                            , e.br (e.opc2 (e.f "g1") "<<<" (e.f "g2"))
                            ]
                    }
                ]
            }
        ]
    , members =
        [
            { name = "bimap"
            , def =
                -- (a -> b) -> (c -> d) -> f a c -> f b d
                (e.fn
                    [ e.br (e.fn [ e.n "a", e.n "b" ])
                    , e.br (e.fn [ e.n "c", e.n "d" ])
                    , e.ap (e.f "f") [ e.n "a", e.n "c" ]
                    , e.ap (e.f "f") [ e.n "b", e.n "d" ]
                    ]
                )
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ,
            { name = "lmap"
            , def =
                -- Bifunctor f => (a -> b) -> f a c -> f b c
                e.req1
                    (e.subj "Bifunctor" [ e.f "f" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "a", e.n "b" ])
                        , e.ap (e.f "f") [ e.n "a", e.n "c" ]
                        , e.ap (e.f "f") [ e.n "b", e.n "c" ]
                        ]
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "rmap"
            , def =
                -- Bifunctor f => (b -> c) -> f a b -> f a c
                e.req1
                    (e.subj "Bifunctor" [ e.f "f" ])
                    (e.fn
                        [ e.br (e.fn [ e.n "b", e.n "c" ])
                        , e.ap (e.f "f") [ e.n "a", e.n "b" ]
                        , e.ap (e.f "f") [ e.n "a", e.n "c" ]
                        ]
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Either" "Bifunctor"
        , i.instanceSubj "Tuple" "Bifunctor"
        , i.instanceSubj "Const" "Bifunctor"
        ]

    } /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in bifunctor