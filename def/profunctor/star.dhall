let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let star : tc.TClass =
    { id = "star"
    , name = "Star"
    , what = tc.What.Newtype_
    , vars = [ "f", "a", "b" ]
    , info = ""
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Star"
    , members =
        [
            { name = "Star"
            , def = "{{subj:Star}} ({{var:a}} {{op:->}} {{fvar:f}} {{var:b}})" -- Star (a -> f b)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistStar"
            , def = "({{fvar:f}} {{op:~>}} {{fvar:g}}) {{op:->}} {{subj:Star}} {{fvar:f}} {{var:a}} {{var:b}} {{op:->}} {{subj:Star}} {{fvar:g}} {{var:a}} {{var:b}}" -- (f ~> g) -> Star f a b -> Star g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Star}} {{fvar:f}} {{var:a}} {{var:b}}) {{var:_}}" -- Newtype (Star f a b) _
        , i.instanceReqF2 "Bind" "Semigroupoid" "Star"
        , i.instanceReqF2 "Monad" "Category" "Star"
        , i.instanceReqFA "Functor" "Star"
        , i.instanceReqFA "Invariant" "Star"
        , i.instanceReqFA "Apply" "Star"
        , i.instanceReqFA "Applicative" "Star"
        , i.instanceReqFA "Bind" "Star"
        , i.instanceReqFA "Monad" "Star"
        , i.instanceReqFA "Alt" "Star"
        , i.instanceReqFA "Plus" "Star"
        , i.instanceReqFA "Alternative" "Star"
        , i.instanceReqFA "MonadZero" "Star"
        , i.instanceReqFA "MonadPlus" "Star"
        , i.instanceReqFA "Distributive" "Star"
        , i.instanceReqF2 "Functor" "Profunctor" "Star"
        , i.instanceReqF2 "Functor" "Strong" "Star"
        , i.instanceReqF2 "Applicative" "Choice" "Star"
        , i.instanceReqF2 "Distributive" "Closed" "Star"
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents /\ tc.noStatements

in star