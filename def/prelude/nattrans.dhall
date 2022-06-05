let tc = ./../../typeclass.dhall

let naturalTransformation : tc.TClass =
    { id = "ntransform"
    , name = "NaturalTransformation"
    , what = tc.What.Type_
    , vars = [ "f", "g" ]
    , info = "Mapping b/w type constructors with no manipulation on inner value"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.NaturalTransformation"
    , members =
        [
            { name = "NaturalTransformation"
            , def = "{{fvar:f}} {{var:a}} {{op:->}} {{fvar:g}} {{var:a}}" -- f a -> g a
            , belongs = tc.Belongs.Yes
            , op = Some "~>"
            , opEmoji = Some "🐛"
            } /\ tc.noLaws
        ]

    } /\ tc.noLaws /\ tc.noParents /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in naturalTransformation