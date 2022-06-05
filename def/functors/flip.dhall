let tc = ./../../typeclass.dhall

let flip : tc.TClass =
    { id = "fllip"
    , name = "Flip"
    , what = tc.What.Newtype_
    , vars = [ "p", "a", "b" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Flip"
    , members =
        [
            { name = "Flip"
            , def = "{{subj:Flip}} ({{fvar:p}} {{var:b}} {{var:a}})" -- Flip (p b a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ "{{class:Newtype}} ({{subj:Flip}} {{fvar:p]}} {{var:a}} {{var:b}}) {{var:_}}" -- Newtype (Flip p a b) _
        -- TODO
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in flip