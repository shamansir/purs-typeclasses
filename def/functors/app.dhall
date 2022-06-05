let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let app : tc.TClass =
    { id = "app"
    , name = "App"
    , what = tc.What.Newtype_
    , vars = [ "f", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.App"
    , members =
        [
            { name = "App"
            , def = "{{class:App}} ({{fvar:f}} {{var:a}})" -- App (f a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistApp"
            , def = "({{fvar:f}} {{op:~>}} {{fvar:g}}) {{op:->}} ({{class:App}} {{fvar:f}}) {{op:~>}} ({{subj:App}} {{fvar:g}})" -- (f ~> g) -> (App f) ~> (App g)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistLiftApp"
            , def = "{{fvar:f}} ({{fvar:g}} {{var:a}}) {{op:->}} {{fvar:f}} ({{subj:App}} {{var:g}} {{var:a}})" -- f (g a) -> f (App g a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistLowerApp"
            , def = "{{fvar:f}} ({{subj:App}} {{fvar:g}} {{var:a}}) {{op:->}} {{fvar:f}} ({{fvar:g}} {{var:a}})" -- f (App g a) -> f (g a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceFA_ "Newtype" "App"
        , i.instanceReqFA2 "Eq" "Eq1" "App"
        , i.instanceReqF "Eq" "App"
        , i.instanceReqFA2 "Ord" "Ord1" "App"
        , i.instanceReqF "Ord" "App"
        , i.instanceReqFA_ "Show" "App"
        , i.instanceReqFA2 "Semigroup" "Apply" "App"
        , i.instanceReqFA2 "Monoid" "Applicative" "App"
        , i.instanceReqF "MonadZero" "App"
        , i.instanceReqF "Functor" "App"
        , i.instanceReqF "Apply" "App"
        , i.instanceReqF "Applicative" "App"
        , i.instanceReqF "Bind" "App"
        , i.instanceReqF "Monad" "App"
        , i.instanceReqF "Alt" "App"
        , i.instanceReqF "Plus" "App"
        , i.instanceReqF "Alternative" "App"
        , i.instanceReqF "MonadPlus" "App"
        , i.instanceReqFA_ "Lazy" "App"
        , i.instanceReqF "Extend" "App"
        , i.instanceReqF "Comonad" "App"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in app