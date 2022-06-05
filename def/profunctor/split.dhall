let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let split : tc.TClass =
    { id = "split"
    , name = "Split"
    , what = tc.What.Newtype_
    , vars = [ "f", "a", "b" ]
    , info = ""
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Split"
    , members =
        [
            { name = "split"
            , def = "({{var:a}} {{op:->}} {{var:x}}) {{op:->}} ({{var:x}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:x}} {{op:->}} {{subj:Split}} {{fvar:f}} {{var:a}} {{var:b}}" -- (a -> x) -> (x -> b) -> f x -> Split f a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unSplit"
            , def = "({{kw:forall}} {{var:x}}. ({{var:a}} {{op:->}} {{var:x}}) {{op:->}} ({{var:x}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:x}} {{op:->}} {{var:r}}) {{op:->}} {{subj:Split}} {{fvar:f}} {{var:a}} {{var:b}} {{op:->}} {{var:r}}" -- (forall x. (a -> x) -> (x -> b) -> f x -> r) -> Split f a b -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "liftSplit"
            , def = "{{fvar:f}} {{var:a}} {{op:->}} {{subj:Split}} {{fvar:f}} {{var:a}} {{var:a}}" -- f a -> Split f a a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lowerSplit"
            , def = "{{class:Invariant}} {{fvar:f}} {{op:=>}} {{subj:Split}} {{fvar:f}} {{var:a}} {{var:a}} {{op:->}} {{fvar:f}} {{var:a}}" -- Invariant f => Split f a a -> f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistSplit"
            , def = "({{fvar:f}} {{op:~>}} {{fvar:g}}) {{op:->}} {{subj:Split}} {{fvar:f}} {{var:a}} {{var:b}} {{op:->}} {{subj:Split}} {{fvar:g}} {{var:a}} {{var:b}}" -- (f ~> g) -> Split f a b -> Split g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceFA "Functor" "Split"
        , i.instanceF "Profunctor" "Split"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents /\ tc.noStatements

in split