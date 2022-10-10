let tc = ./../../typeclass.dhall

let joker : tc.TClass =
    { id = "joker"
    , name = "Joker"
    , what = tc.What.Newtype_
    , vars = [ "g", "a", "b" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Joker"
    , members =
        [
            { name = "Joker"
            , def = "{{subj:Joker}} ({{fvar:g}} {{var:b}})" -- Joker (g b)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistJoker"
            , def = "({{fvar:f}} {{op:~>}} {{fvar:g}}) {{op:->}} {{subj:Joker}} {{fvar:f}} {{var:a}} {{var:b}} {{op:->}} {{subj:Joker}} {{fvar:g}} {{var:a}} {{var:b}}" -- (f ~> g) -> Joker f a b -> Joker g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Compose}} {{fvar:f}} {{var:a}} {{var:b}}) {{var:_}}" -- Newtype (Joker f a b) _
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