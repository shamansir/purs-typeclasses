let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

let product2 : tc.TClass =
    { id = "product2"
    , name = "Product2"
    , what = tc.What.Data_
    , vars = [ "f", "g", "a", "b" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Product2"
    , members =
        [
            { name = "Product2"
            , def =
                e.subj
                    "Product2"
                    [ e.br (e.ap3 (e.f "f") (e.n "a") (e.n "b"))
                    , e.br (e.ap3 (e.f "g") (e.n "a") (e.n "b"))
                    ]
                -- Product2 (f a b) (g a b)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ e.req
            [ e.class1 "Eq" (e.br (e.ap3 (e.f "f") (e.n "a") (e.n "b")))
            , e.class1 "Eq" (e.br (e.ap3 (e.f "g") (e.n "a") (e.n "b")))
            ]
            (e.class1 "Eq" (e.br (e.subj "Product2" [ e.f "f", e.f "g", e.n "a", e.n "b" ])))
            -- (Eq (f a b), Eq (g a b)) => Eq (Product2 f g a b)
        -- (Eq (f a b), Eq (g a b)) => Eq (Product2 f g a b)
        -- (Ord (f a b), Ord (g a b)) => Ord (Product2 f g a b)
        -- (Show (f a b), Show (g a b)) => Show (Product2 f g a b)
        -- (Functor (f a), Functor (g a)) => Functor (Product2 f g a)
        -- (Bifunctor f, Bifunctor g) => Bifunctor (Product2 f g)
        -- (Biapply f, Biapply g) => Biapply (Product2 f g)
        -- (Biapplicative f, Biapplicative g) => Biapplicative (Product2 f g)
        -- (Profunctor f, Profunctor g) => Profunctor (Product2 f g)
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in product2