let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Position

let position : tc.TClass =
    { spec = d.nt_e (d.id "position") "Position"
    , info = "The `Parser s` monad, where `s` is the type of the input stream"
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , members =
        [
            { name = "Position"
            , def =
                e.subj1 "Position" (e.obj (toMap { column = e.classE "Int", index = e.classE "Int", line = e.classE "Int" }))
                -- Position { column :: Int, index :: Int, line :: Int }
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "initialPos"
            , def =
                e.classE "Position"
                -- Position
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance_ "Generic" "Position"
        , i.instance "Show" "Position"
        , i.instance "Eq" "Position"
        , i.instance "Ord" "Position"
        ]
    } /\ tc.aw /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in position