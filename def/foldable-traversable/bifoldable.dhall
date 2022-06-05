let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let bifoldable : tc.TClass =
    { id = "bifoldable"
    , name = "Bifoldable"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , info = "Represents data structures with two type arguments which can be folded."
    , module = [ "Control" ]
    , package = "purescript-foldable-traversable"
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.Bifoldable"
    , members =
        [
            { name = "bifoldr"
            , def = "(a -> c -> c) -> (b -> c -> c) -> c -> p a b -> c" -- (a -> c -> c) -> (b -> c -> c) -> c -> p a b -> c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifoldl"
            , def = "(c -> a -> c) -> (c -> b -> c) -> c -> p a b -> c" -- (c -> a -> c) -> (c -> b -> c) -> c -> p a b -> c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifoldMap"
            , def = "Monoid m => (a -> m) -> (b -> m) -> p a b -> m" -- Monoid m => (a -> m) -> (b -> m) -> p a b -> m
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifoldrDefault"
            , def = "Bifoldable p => (a -> c -> c) -> (b -> c -> c) -> c -> p a b -> c" -- Foldable f => (a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifoldlDefault"
            , def = "Bifoldable p => (c -> a -> c) -> (c -> b -> c) -> c -> p a b -> c" -- Bifoldable p => (c -> a -> c) -> (c -> b -> c) -> c -> p a b -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifoldMapDefaultL"
            , def = "Bifoldable p => Monoid m => (a -> m) -> (b -> m) -> p a b -> m" --  Bifoldable p => Monoid m => (a -> m) -> (b -> m) -> p a b -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifold"
            , def = "Bifoldable t => Monoid m => t m m -> m" -- Bifoldable t => Monoid m => t m m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bitraverse_"
            , def = "Bifoldable t => Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f Unit" -- Bifoldable t => Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifor_"
            , def = "Bifoldable t => Applicative f => t a b -> (a -> f c) -> (b -> f d) -> f Unit" -- Bifoldable t => Applicative f => t a b -> (a -> f c) -> (b -> f d) -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bisequence_"
            , def = "Bifoldable t => Applicative f => t (f a) (f b) -> f Unit" -- Bifoldable t => Applicative f => t (f a) (f b) -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "biany"
            , def = "Bifoldable t => BooleanAlgebra c => (a -> c) -> (b -> c) -> t a b -> c" -- Bifoldable t => BooleanAlgebra c => (a -> c) -> (b -> c) -> t a b -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "biall"
            , def = "Bifoldable t => BooleanAlgebra c => (a -> c) -> (b -> c) -> t a b -> c" -- Bifoldable t => BooleanAlgebra c => (a -> c) -> (b -> c) -> t a b -> c"
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceReqF2_ "Foldable" "Clown" "Bifoldable"
        , i.instanceReqF2_ "Foldable" "Joker" "Bifoldable"
        , i.instanceReqPSubj "Flip" "Bifoldable"
        , i.instanceReqFG "Product2" "Bifoldable"
        , i.instanceSubj "Either" "Bifoldable"
        , i.instanceSubj "Tuple" "Bifoldable"
        , i.instanceSubj "Const" "Bifoldable"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in bifoldable