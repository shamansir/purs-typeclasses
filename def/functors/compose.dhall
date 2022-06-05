let tc = ./../../typeclass.dhall

let compose : tc.TClass =
    { id = "compose"
    , name = "Comprose"
    , what = tc.What.Newtype_
    , vars = [ "f", "g", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Compose"
    , members =
        [
            { name = "Compose"
            , def = "{{subj:Compose}} ({{fvar:f}} ({{fvar:g}} {{var:a}}))" -- Compose (f (g a))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bihoistCompose"
            , def = "Functor f => (f ~> h) -> (g ~> i) -> (Compose f g) ~> (Compose h i)" -- Functor f => (f ~> h) -> (g ~> i) -> (Compose f g) ~> (Compose h i)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Compose}} {{fvar:f}} {{fvar:g}} {{var:a}}) {{var:_}}" -- Newtype (Compose f g a) _
        -- TODO
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in compose