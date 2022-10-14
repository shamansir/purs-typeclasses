let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class FunctorWithIndex :: Type -> (Type -> Type) -> Constraint
-- class (Functor f) <= FunctorWithIndex i f | f -> i where

let functorWithIndex : tc.TClass =
    { id = "functorwithindex"
    , name = "FunctorWithIndex"
    , what = tc.What.Class_
    , vars = [ "i", "f" ]
    , info = "A Functor with an additional index."
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-foldable-traversable" +6
    , parents = [ "functor" ]
    , link = "purescript-foldable-traversable/6.0.0/docs/Data.FunctorWithIndex"
    , statements =
        [
            { left = e.call1 "mapWithIndex" (e.br (e.lbd [ e.av "_", e.av "a" ] (e.n "a"))) -- mapWithIndex (\_ a -> a)
            , right = e.callE "identity" -- identity
            }
        ,
            { left = e.opc2 (e.call1 "mapWithIndex" (e.f "f")) "." (e.call1 "mapWithIndex" (e.f "g")) -- mapWithIndex f . mapWithIndex g
            , right =
                e.call1 "mapWithIndex"
                    (e.br
                        (e.lbd1 (e.av "i")
                            (e.opc2 (e.ap2 (e.f "f") (e.n "i")) "<<<" (e.ap2 (e.f "g") (e.n "i")))
                        )
                    )
                     -- mapWithIndex (\i -> f i <<< g i)
            }
        ,
            { left = e.call1 "map" (e.f "f") -- map f
            , right = e.call1 "mapWithIndex" (e.br (e.call1 "const" (e.f "f"))) -- mapWithIndex (const f)
            }
        ]
    , members =
        [
            { name = "mapWithIndex"
            , def =
                e.fn
                    [ e.br (e.fn3 (e.n "i") (e.n "a") (e.n "b"))
                    , e.n "b"
                    , e.ap2 (e.t "f") (e.n "a")
                    , e.ap2 (e.t "f") (e.n "b")
                    ]
                -- (i -> a -> b) -> b -> f a -> f b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mapDefault"
            , def =
                e.req1
                    (e.subj1 "FunctorWithIndex" (e.f "f"))
                    (e.fn3
                            (e.br (e.fn2 (e.n "a") (e.n "b")))
                            (e.ap2 (e.t "f") (e.n "a"))
                            (e.ap2 (e.t "f") (e.n "b"))
                    )
                -- FunctorWithIndex f => (a -> b) -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj2 "Int" "Array" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Maybe" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "First" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Last" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Additive" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Dual" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Disj" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Conj" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Multiplicative" "FunctorWithIndex"
        , i.instanceClSubjA "Unit" "Either" "FunctorWithIndex"
        , i.instanceClSubjA "Unit" "Tuple" "FunctorWithIndex"
        , i.instanceSubj2 "Unit" "Identity" "FunctorWithIndex"
        , i.instanceClSubjA "Void" "Const" "FunctorWithIndex"
        , e.req
            [ e.subj "FunctorWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "FunctorWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "FunctorWithIndex"
                [ e.br (e.class "Either" [ e.n "a", e.n "b" ])
                , e.br (e.class "Product" [ e.f "f", e.f "g" ])
                ]
            ) -- (FunctorWithIndex a f, FunctorWithIndex b g) => FunctorWithIndex (Either a b) (Product f g)
        , e.req
            [ e.subj "FunctorWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "FunctorWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "FunctorWithIndex"
                [ e.br (e.class "Either" [ e.n "a", e.n "b" ])
                , e.br (e.class "Coproduct" [ e.f "f", e.f "g" ])
                ]
            ) -- (FunctorWithIndex a f, FunctorWithIndex b g) => FunctorWithIndex (Either a b) (Coproduct f g)
        , e.req
            [ e.subj "FunctorWithIndex" [ e.n "a", e.f "f" ]
            , e.subj "FunctorWithIndex" [ e.n "b", e.f "g" ]
            ]
            (e.subj "FunctorWithIndex"
                [ e.br (e.class "Tuple" [ e.n "a", e.n "b" ])
                , e.br (e.class "Compose" [ e.f "f", e.f "g" ])
                ]
            ) -- (FunctorWithIndex a f, FunctorWithIndex b g) => FunctorWithIndex (Tuple a b) (Compose f g)
        , e.req
            [ e.subj "FunctorWithIndex" [ e.n "a", e.f "f" ]
            ]
            (e.subj "FunctorWithIndex"
                [ e.n "a"
                , e.br (e.class1 "App" (e.f "f"))
                ]
            ) -- (FunctorWithIndex a f) => FunctorWithIndex a (App f)
        ]

    } /\ tc.noLaws /\ tc.noValues

in functorWithIndex