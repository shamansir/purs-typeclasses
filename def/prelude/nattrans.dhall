let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

let naturalTransformation : tc.TClass =
    { id = "ntransform"
    , name = "NaturalTransformation"
    , what = tc.What.Type_
    , vars = [ "f", "g" ]
    , info = "Mapping b/w type constructors with no manipulation on inner value"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.NaturalTransformation"
    , members =
        [
            { name = "NaturalTransformation"
            , def =
                e.fn2
                    (e.ap2 (e.f "f") (e.n "a"))
                    (e.ap2 (e.f "g") (e.n "a"))
                -- f a -> g a
            , belongs = tc.Belongs.Yes
            , op = Some "~>"
            , opEmoji = Some "🐛"
            } /\ tc.noLaws
        ]

    } /\ tc.noLaws /\ tc.noParents /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in naturalTransformation