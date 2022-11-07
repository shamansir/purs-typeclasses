let tc = ./../../typeclass.dhall
let d = ./../../spec.dhall
let e_ = ../../expr.dhall
let e = ./../../build_expr.dhall

let plma = \(last : e_.Expr) -> e.subj "ParserT" [ e.br (e.class1 "List" (e.n "a")), e.t "m", last ] -- ParserT (List a) m <last>
let plmaa = plma (e.n "a")                                                                           -- ParserT (List a) m a
let plmu = plma (e.classE "Unit")                                                                    -- ParserT (List a) m Unit

let atopos = (e.br (e.fn2 (e.n "a") (e.classE "Position"))) -- (a -> Position)
let atobool = (e.br (e.fn2 (e.n "a") (e.classE "Position"))) -- (a -> Boolean)

let tokenParsers : tc.TClass =
    { id = "tokenparsers"
    , name = "Token"
    , what = tc.What.Package_
    , info = "Primitive parsers for working with streams of tokens."
    , module = [ "Parsing", "Token" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , spec = d.pkg (d.id "tokenparsers") "Parsing.Token"
    , members =
        [
            { name = "token"
            , def = e.fn2 atopos plmaa
            -- (a -> Position) -> ParserT (List a) m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "when"
            , def = e.fn3 atopos atobool plmaa
            -- (a -> Position) -> (a -> Boolean) -> ParserT (List a) m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "match"
            , def =
                e.req1
                    (e.class1 "Eq" (e.n "a"))
                    (e.fn3 atopos (e.n "a") plmaa)
            -- Eq a => (a -> Position) -> a -> ParserT (List a) m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "eof"
            , def = plmu
            -- ParserT (List a) m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "makeTokenParser"
            , def =
                e.fn2
                    (e.class "GenLanguageDef" [ e.classE "String", e.n "m" ])
                    (e.class "GenTokenParser" [ e.classE "String", e.n "m" ])
            -- GenLanguageDef String m -> GenTokenParser String m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noVars /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in tokenParsers