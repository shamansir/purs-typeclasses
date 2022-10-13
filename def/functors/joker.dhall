let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

let joker : tc.TClass =
    { id = "joker"
    , name = "Joker"
    , what = tc.What.Newtype_
    , vars = [ "g", "a", "b" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Joker"
    , members =
        [
            { name = "Joker"
            , def = e.subj1 "Joker" (e.br (e.ap2 (e.f "g") (e.n "b"))) -- Joker (g b)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistJoker"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.f "f") "~>" (e.f "g")))
                    (e.subj "Joker" [ e.f "f", e.n "a", e.n "b" ])
                    (e.subj "Joker" [ e.f "g", e.n "a", e.n "b" ])
                -- (f ~> g) -> Joker f a b -> Joker g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ e.class "Newtype" [ e.br (e.class "Joker" [ e.t "f", e.n "a", e.n "b" ]), e.ph ] -- Newtype (Joker f a b) _
        -- (Eq (f b)) => Eq (Joker f a b)
        -- (Ord (f b)) => Ord (Joker f a b)
        -- (Show (f b)) => Show (Joker f a b)
        -- (Functor f) => Functor (Joker f a)
        -- (Apply f) => Apply (Joker f a)
        -- (Applicative f) => Applicative (Joker f a)
        -- (Bind f) => Bind (Joker f a)
        -- (Monad m) => Monad (Joker m a)
        -- (Functor g) => Bifunctor (Joker g)
        -- (Apply g) => Biapply (Joker g)
        -- (Applicative g) => Biapplicative (Joker g)
        -- (Functor f) => Profunctor (Joker f)
        -- (Functor f) => Choice (Joker f)
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in joker