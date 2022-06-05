let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let bitraversable : tc.TClass =
    { id = "bitraversable"
    , name = "Bitraversable"
    , what = tc.What.Class_
    , vars = [ "t" ]
    , parents = [ "bifunctor", "bifoldable" ]
    , info = "Data structures with two arguments which can be traversed"
    , module = [ "Data" ]
    , package = "purescript-foldable-traversable"
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.Bitraversable"
    , members =
        [
            { name = "bitraverse"
            , def = "Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f (t c d)" -- Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f (t c d)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bisequence"
            , def = "Applicative f => t (f a) (f b) -> f (t a b)" -- Applicative f => t (f a) (f b) -> f (t a b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bitraverseDefault"
            , def = "Bitraversable t => Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f (t c d)" -- Bitraversable t => Applicative f => (a -> f c) -> (b -> f d) -> t a b -> f (t c d)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bisequenceDefault"
            , def = "Applicative f => t (f a) (f b) -> f (t a b)" -- Bitraversable t => Applicative f => t (f a) (f b) -> f (t a b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bifor"
            , def = "Bitraversable t => Applicative f => t a b -> (a -> f c) -> (b -> f d) -> f (t c d)" -- Bitraversable t => Applicative f => t a b -> (a -> f c) -> (b -> f d) -> f (t c d)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lfor"
            , def = "Bitraversable t => Applicative f => t a b -> (a -> f c) -> f (t c b)" -- Bitraversable t => Applicative f => t a b -> (a -> f c) -> f (t c b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "rfor"
            , def = "Bitraversable t => Applicative f => t a b -> (b -> f c) -> f (t a c)" -- Bitraversable t => Applicative f => t a b -> (b -> f c) -> f (t a c)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceReqF2_ "Traversable" "Clown" "Bitraversable"
        , i.instanceReqF2_ "Traversable" "Joker" "Bitraversable"
        , i.instanceReqPSubj "Flip" "Bitraversable"
        , i.instanceReqFG "Product2" "Bitraversable"
        , i.instanceSubj "Either" "Bitraversable"
        , i.instanceSubj "Tuple" "Bitraversable"
        , i.instanceSubj "Const" "Bitraversable"
        ]

    } /\ tc.noStatements /\ tc.noValues /\ tc.noLaws

in bitraversable