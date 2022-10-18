let tc = ./../../typeclass.dhall
let e_ = ../../expr.dhall
let e = ./../../build_expr.dhall


let stringParsers : tc.TClass =
    { id = "stringparsers"
    , name = "String"
    , what = tc.What.Package_
    , info = "Primitive parsers for working with an input stream of type String"
    , module = [ "Parsing", "String" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , members =
        [
        ]
    } /\ tc.noVars /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in stringParsers