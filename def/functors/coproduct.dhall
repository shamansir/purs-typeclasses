let tc = ./../../typeclass.dhall

let coproduct : tc.TClass =
    { id = "coproduct"
    , name = "Coproduct"
    , what = tc.What.Newtype_
    , vars = [ "f", "g", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Coproduct"
    , members =
        [
            { name = "Coproduct"
            , def = "{{subj:Coproduct}} ({{class:Either}} ({{fvar:f}} {{fvar:a}}) ({{fvar:g}} {{var:a}}))" -- Coproduct (Either (f a) (g a))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "left"
            , def = "{{fvar:f}} {{var:a}} {{op:->}} {{subj:Coproduct}} {{fvar:f}} {{fvar:g}} {{var:a}}" -- f a -> Coproduct f g a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "right"
            , def = "{{fvar:g}} {{var:a}} {{op:->}} {{subj:Coproduct}} {{fvar:f}} {{fvar:g}} {{var:a}}" -- g a -> Coproduct f g a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "coproduct"
            , def = "({{fvar:f}} {{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{fvar:g}} {{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{subj:Coproduct}} {{fvar:f}} {{fvar:g}} {{var:a}} {{op:->}} {{var:b}}" -- (f a -> b) -> (g a -> b) -> Coproduct f g a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bihoistCoproduct"
            , def = "(f ~> h) -> (g ~> i) -> (Coproduct f g) ~> (Coproduct h i)" -- (f ~> h) -> (g ~> i) -> (Coproduct f g) ~> (Coproduct h i)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Coproduct}} {{fvar:f}} {{fvar:g}} {{var:a}}) {{var:_}}" -- Newtype (Coproduct f g a) _
        -- TODO
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in coproduct