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
        -- TODO
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in product