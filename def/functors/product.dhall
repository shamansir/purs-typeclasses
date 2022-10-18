let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

-- newtype Product :: forall k. (k -> Type) -> (k -> Type) -> k -> Type
-- newtype Product f g a

let product : tc.TClass =
    { id = "product"
    , name = "Product"
    , what = tc.What.Newtype_
    , vars = [ "f", "g", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Product"
    , members =
        [
            { name = "Product"
            , def =
                e.subj1
                    "Product"
                    (e.br
                        (e.class "Tuple"
                            [ e.br (e.ap2 (e.f "f") (e.n "a"))
                            , e.br (e.ap2 (e.f "g") (e.n "a"))
                            ]
                        )
                    )
                -- Product (Tuple (f a) (g a))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "product"
            , def =
                e.fn3
                    (e.ap2 (e.f "f") (e.n "a"))
                    (e.ap2 (e.f "g") (e.n "a"))
                    (e.subj "Product" [ e.f "f", e.f "g", e.n "a" ])
                -- f a -> g a -> Product f g a
            , belongs = tc.Belongs.No
            , op = Some "</\\>" -- defined in Data.Functor.Product.Nested
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "bihoistProduct"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.t "f") "~>" (e.t "h")))
                    (e.br (e.opc2 (e.t "g") "~>" (e.t "i")))
                    (e.opc2
                        (e.br (e.class "Product" [ e.t "f", e.t "g" ]))
                        "~>"
                        (e.br (e.class "Product" [ e.t "h", e.t "i" ]))
                    )
                -- (f ~> h) -> (g ~> i) -> (Product f g) ~> (Product h i)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ e.class "Newtype" [ e.br (e.class "Product" [ e.t "f", e.n "g", e.n "a" ]), e.ph ]  -- Newtype (Product f g a) _
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