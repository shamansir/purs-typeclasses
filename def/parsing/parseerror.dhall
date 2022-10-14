let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- data ParseError

let parseerror : tc.TClass =
    { id = "parseerror"
    , name = "ParseError"
    , what = tc.What.Data_
    , info = "The `Parser s` monad, where `s` is the type of the input stream"
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , members =
        [
            { name = "ParseError"
            , def =
                e.subj "ParseError" [ e.classE "String", e.classE "Position" ]
                -- ParseError String Position
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "parseErrorMessage"
            , def =
                e.fn2 (e.classE "ParseError") (e.classE "String")
                -- ParseError -> String
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "parseErrorPosition"
            , def =
                e.fn2 (e.classE "ParseError") (e.classE "Position")
                -- ParseError -> Position
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    } /\ tc.noVars /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in parseerror