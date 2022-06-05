let tc = ./../../typeclass.dhall

let inject : tc.TClass =
    { id = "inject"
    , name = "Inject"
    , what = tc.What.Class_
    , vars = [ "f", "g" ]
    , info = ""
    , module = [ "Data", "Functor", "Coproduct" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Coproduct.Inject"
    , members =
        [
            { name = "inj"
            , def = "{{fvar:f}} {{var:a}} {{op:->}} {{fvar:g}} {{var:a}}" -- f a -> g a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "prj"
            , def = "{{fvar:g}} {{var:a}} {{op:->}} {{class:Maybe}} ({{fvar:f}} {{var:a}})" -- g a -> Maybe (f a)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{subj:Inject}} {{fvar:f}} {{fvar:f}}" -- Inject f f
        , "{{subj:Inject}} {{fvar:f}} ({{class:Coproduct}} {{fvar:f}} {{fvar:g}})" -- Inject f (Coproduct f g)
        , "({{subj:Inject}} {{fvar:f}} {{fvar:g}}) {{op:=>}} {{subj:Inject}} {{fvar:f}} ({{class:Coproduct}} {{fvar:f}} {{fvar:g}})" -- (Inject f g) => Inject f (Coproduct h g)
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in inject