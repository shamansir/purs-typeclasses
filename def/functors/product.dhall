let tc = ./../../typeclass.dhall

let product : tc.TClass =
    { id = "product"
    , name = "Product"
    , what = tc.What.Newtype_
    , vars = [ "f", "g", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Product"
    , members =
        [
            { name = "Product"
            , def = "{{subj:Product}} ({{class:Tuple}} ({{fvar:f}} {{fvar:a}}) ({{fvar:g}} {{var:a}}))" -- Product (Tuple (f a) (g a))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "product"
            , def = "{{fvar:f}} {{var:a}} {{op:->}} {{fvar:g}} {{var:a}} {{op:->}} {{subj:Coproduct}} {{fvar:f}} {{fvar:g}} {{var:a}}" -- f a -> g a -> Product f g a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bihoistProduct"
            , def = "(f ~> h) -> (g ~> i) -> (Product f g) ~> (Product h i)" -- (f ~> h) -> (g ~> i) -> (Product f g) ~> (Product h i)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Product}} {{fvar:f}} {{fvar:g}} {{var:a}}) {{var:_}}" -- Newtype (Product f g a) _
        -- (Eq1 f, Eq1 g, Eq a) => Eq (Product f g a)
        -- (Eq1 f, Eq1 g) => Eq1 (Product f g)
        -- (Ord1 f, Ord1 g, Ord a) => Ord (Product f g a)
        -- (Ord1 f, Ord1 g) => Ord1 (Product f g)
        -- (Show (f a), Show (g a)) => Show (Product f g a)
        -- (Functor f, Functor g) => Functor (Product f g)
        -- (Apply f, Apply g) => Apply (Product f g)
        -- (Applicative f, Applicative g) => Applicative (Product f g)
        -- (Bind f, Bind g) => Bind (Product f g)
        -- (Monad f, Monad g) => Monad (Product f g)
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in product