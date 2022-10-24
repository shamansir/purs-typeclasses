let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ../../typedef.dhall
let e = ./../../build_expr.dhall

-- data ParseState s

let parsestate : tc.TClass =
    { id = "parsestate"
    , name = "ParseState"
    , vars = [ "s" ]
    , what = tc.What.Data_
    , info = "The internal state of the `ParserT s m` monad."
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , def = d.data (d.id "parsestate") "ParseState" [ d.v "s" ]
    , members =
        [
            { name = "ParseState"
            , def =
                e.subj "ParseState" [ e.n "s", e.classE "Position", e.classE "Boolean" ]
                -- ParseState s Position Boolean
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in parsestate