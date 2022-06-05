let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let traversable : tc.TClass =
    { id = "distributive"
    , name = "Distributive"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "functor" ]
    , info = "Categorical dual of Traversable"
    , module = [ "Data" ]
    , package = "purescript-distributive"
    , link = "purescript-distributive/5.0.0/docs/Data.Distributive#t:Distributive"
    , statements =
        [
            { left = "distribute" -- distribute
            , right = "collect identity" -- collect identity
            }
        ,
            { left = "distribute <<< distribute" -- distribute <<< distribute
            , right = "{{method:identity}}" -- identity
            }
        ,
            { left = "{{method:collect}} {{fvar:f}}" -- collect f
            , right = "distribute <<< map f" -- distribute <<< map f
            }
        ,
            { left = "map f" -- map f
            , right = "unwrap <<< collect (Identity <<< f)" -- unwrap <<< collect (Identity <<< f)
            }

        ,
            { left = "map f" -- map f
            , right = "map distribute <<< collect f = unwrap <<< collect (Compose <<< f)" -- distribute <<< map f
            }

        ]
    , members =
        [
            { name = "distribute"
            , def = "Functor g => g (f a) -> f (g a)" -- Functor g => g (f a) -> f (g a)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "collect"
            , def = "Functor g => (a -> f b) -> g a -> f (g b)" -- Functor g => (a -> f b) -> g a -> f (g b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "distributeDefault"
            , def = "Distributive f => Functor g => g (f a) -> f (g a)" -- Functor g => g (f a) -> f (g a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "collectDefault"
            , def = "Distributive f => Functor g => (a -> f b) -> g a -> f (g b)" -- Distributive f => Functor g => (a -> f b) -> g a -> f (g b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "cotraverse"
            , def = " Distributive f => Functor g => (g a -> b) -> g (f a) -> f b" --  Distributive f => Functor g => (g a -> b) -> g (f a) -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Identity" "Distributive"
        , "Distributive (Function e)" -- Distributive (Function e)
        , "(TypeEquals a Unit) => Distributive (Tuple a)" -- (TypeEquals a Unit) => Distributive (Tuple a)
        ]

    } /\ tc.noValues /\ tc.noLaws

in traversable