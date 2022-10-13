let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let traversable : tc.TClass =
    { id = "distributive"
    , name = "Distributive"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "functor" ]
    , info = "Categorical dual of Traversable"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-distributive" +5
    , link = "purescript-distributive/5.0.0/docs/Data.Distributive#t:Distributive"
    , statements =
        [
            { left = e.callE "distribute" -- distribute
            , right = e.call1 "collect" (e.callE "identity") -- collect identity
            }
        ,
            { left = e.opc2 (e.callE "distribute") "<<<" (e.callE "distribute") -- distribute <<< distribute
            , right = e.callE "identity" -- identity
            }
        ,
            { left = e.call1 "collect" (e.f "f") -- collect f
            , right = e.opc2 (e.callE "distribute") "<<<" (e.call1 "map" (e.f "f"))  -- distribute <<< map f
            }
        ,
            { left = e.call1 "map" (e.f "f") -- map f
            , right =
                e.opc2 (e.callE "unwrap") "<<<" (e.call1 "collect" (e.br (e.opc2 (e.classE "Identity") "<<<" (e.f "f"))))
                -- unwrap <<< collect (Identity <<< f)
            }
        ,
            { left =
                e.opc2 (e.call1 "map" (e.callE "distribute")) "<<<" (e.call1 "collect" (e.f "f"))
                -- map distribute <<< collect f
            , right =
                e.opc2 (e.callE "unwrap") "<<<" (e.call1 "collect" (e.br (e.opc2 (e.classE "Compose") "<<<" (e.f "f"))))
                 -- unwrap <<< collect (Compose <<< f)
            }

        ]
    , members =
        [
            { name = "distribute"
            , def =
                e.req1
                    (e.class1 "Functor" (e.f "g"))
                    (e.fn2
                        (e.ap2 (e.f "g") (e.br (e.ap2 (e.f "f") (e.n "a"))))
                        (e.ap2 (e.f "f") (e.br (e.ap2 (e.f "g") (e.n "a"))))
                    )
                -- Functor g => g (f a) -> f (g a)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "collect"
            , def =
                e.req1
                    (e.class1 "Functor" (e.f "g"))
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.f "f") (e.n "b")) ))
                        (e.ap2 (e.f "g") (e.n "a"))
                        (e.ap2 (e.f "f") (e.br (e.ap2 (e.f "g") (e.n "a"))))
                    )
                -- Functor g => (a -> f b) -> g a -> f (g b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "distributeDefault"
            , def =
                e.req
                    [ e.subj1 "Distributive" (e.f "f"), e.class1 "Functor" (e.f "g") ]
                    (e.fn2
                        (e.ap2 (e.f "g") (e.br (e.ap2 (e.f "f") (e.n "a"))))
                        (e.ap2 (e.f "f") (e.br (e.ap2 (e.f "g") (e.n "a"))))
                    )
                -- Distributive f => Functor g => g (f a) -> f (g a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "collectDefault"
            , def =
                e.req
                    [ e.subj1 "Distributive" (e.f "f"), e.class1 "Functor" (e.f "g") ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.f "f") (e.n "b")) ))
                        (e.ap2 (e.f "g") (e.n "a"))
                        (e.ap2 (e.f "f") (e.br (e.ap2 (e.f "g") (e.n "a"))))
                    )
                -- Distributive f => Functor g => (a -> f b) -> g a -> f (g b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "cotraverse"
            , def =
                e.req
                    [ e.subj1 "Distributive" (e.f "f"), e.class1 "Functor" (e.f "g") ]
                    (e.fn3
                        (e.br (e.fn2 (e.ap2 (e.f "g") (e.n "a")) (e.n "b") ))
                        (e.ap2 (e.f "g") (e.br (e.ap2 (e.f "f") (e.n "a"))))
                        (e.ap2 (e.f "f") (e.n "b"))
                    )
                -- Distributive f => Functor g => (g a -> b) -> g (f a) -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Identity" "Distributive"
        , e.subj1 "Distributive" (e.br (e.class1 "Function" (e.n "e"))) -- Distributive (Function e)
        , e.req1
            (e.br (e.class "TypEquals" [ e.n "a", e.classE "Unit" ]))
            (e.subj1 "Distributive" (e.br (e.class1 "Tuple" (e.n "e"))))
        -- (TypeEquals a Unit) => Distributive (Tuple a)
        ]

    } /\ tc.noValues /\ tc.noLaws

in traversable