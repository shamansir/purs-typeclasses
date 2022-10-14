let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- newtype Position

let position : tc.TClass =
    { id = "position"
    , name = "Position"
    , what = tc.What.Newtype_
    , info = "The `Parser s` monad, where `s` is the type of the input stream"
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , members =
        [
            { name = "Position"
            , def =
                e.subj1 "Position" (e.obj (toMap { column = e.classE "Int", index = e.classE "Int", line = e.classE "Int" }))
                -- Position { column :: Int, index :: Int, line :: Int }
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "initialPos"
            , def =
                e.classE "Position"
                -- Position
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance_ "Generic" "Position"
        , i.instance "Show" "Position"
        , i.instance "Eq" "Position"
        , i.instance "Ord" "Position"
        ]
    } /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in position