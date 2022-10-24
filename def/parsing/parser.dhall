let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ../../typedef.dhall
let e = ./../../build_expr.dhall

-- type Parser s = ParserT s Identity

let cexpr = e.class "ParserT" [ e.n "s", e.classE "Identity" ] -- ParserT s Identity

let parser : tc.TClass =
    { id = "parser"
    , name = "Parser"
    , vars = [ "s" ]
    , what = tc.What.Type_
    , info = "The `Parser s` monad, where `s` is the type of the input stream"
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , def = d.t (d.id "parser") "Parser" [ d.v "s" ] cexpr
    , members =
        [
            { name = "Parser"
            , def = cexpr
                -- type Parser s = ParserT s Identity
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "runParser"
            , def =
                e.fn3 (e.n "s") (e.subj "Parser" [ e.n "s", e.n "a" ]) (e.class "Either" [ e.classE "ParseError", e.n "a" ])
                -- s -> Parser s a -> Either ParseError a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in parser