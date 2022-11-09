let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- data ParseState s

let parsestate : tc.TClass =
    { spec = d.data (d.id "parsestate") "ParseState" [ d.v "s" ]
    , info = "The internal state of the `ParserT s m` monad."
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , members =
        [
            { name = "ParseState"
            , def =
                e.subj "ParseState" [ e.n "s", e.classE "Position", e.classE "Boolean" ]
                -- ParseState s Position Boolean
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in parsestate