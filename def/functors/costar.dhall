let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let costar : tc.TClass =
    { id = "costar"
    , name = "Costar"
    , what = tc.What.Newtype_
    , vars = [ "f", "b", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Costar"
    , members =
        [
            { name = "Costar"
            , def = "{{subj:Costar}} ({{fvar:f}} {{var:b}} {{op:->}} {{var:a}})" -- Costar (f b -> a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistCostar"
            , def = "({{fvar:g}} {{op:~>}} {{fvar:f}}) {{op:->}} {{class:Costar}} {{fvar:f}} {{var:a}} {{var:b}} {{op:->}} {{class:Costar}} {{fvar:g}} {{var:a}} {{var:b}}" -- (g ~> f) -> Costar f a b -> Costar g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceFAB_ "Newtype" "Costar"
        , i.instanceReqF2 "Extend" "Semigroupoid" "Costar"
        , i.instanceReqF2 "Comonad" "Category" "Costar"
        , i.instanceFA "Functor" "Costar"
        , i.instanceFA "Invariant" "Costar"
        , i.instanceFA "Apply" "Costar"
        , i.instanceFA "Applicative" "Costar"
        , i.instanceFA "Bind" "Costar"
        , i.instanceFA "Monad" "Costar"
        , i.instanceFA "Distributive" "Costar"
        , i.instanceReqF2 "Contravariant" "Bifunctor" "Costar"
        , i.instanceReqF2 "Functor" "Profunctor" "Costar"
        , i.instanceReqF2 "Comonad" "Strong" "Costar"
        , i.instanceReqF2 "Functor" "Closed" "Costar"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in costar