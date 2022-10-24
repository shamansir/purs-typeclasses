let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ../../typedef.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall

-- type IndentParser s a = ParserT s (State Position) a

let cexpr = e.class "ParserT" [ e.n "s", e.br (e.class1 "State" (e.classE "Position")), e.n "a" ]
    -- ParserT s (State Position) a

let ips = \(last : e_.Expr) -> e.subj "IndentParser" [ e.n "s", last ]  -- IndentParser s <last>
let ipsa = ips (e.n "a")                                                -- IndentParser s a
let ipsb = ips (e.n "b")                                                -- IndentParser s b
let ipsc = ips (e.n "c")                                                -- IndentParser s c
let ipsu = ips (e.classE "Unit")                                        -- IndentParser s Unit
let ipsla = ips (e.br (e.class1 "List" (e.n "a")))                      -- IndentParser s (List a)
let ipslb = ips (e.br (e.class1 "List" (e.n "b")))                      -- IndentParser s (List b)
let ipstra = e.subj "IndentParser" [ e.classE "String", e.n "a" ]       -- IndentParser String a
let ipstra2ipstra = e.fn2 ipstra ipstra                                 -- IndentParser String a -> IndentParser String a

let indentparser : tc.TClass =
    { id = "indentparser"
    , name = "IndentParser"
    , vars = [ "s", "a" ]
    , what = tc.What.Type_
    , info = "The `Parser s` monad with a monad transformer parameter m."
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , def = d.t (d.id "indentparser") "IndentParser" [ d.v "s", d.v "a" ] cexpr
    , members =
        [
            { name = "IndentParser"
            , def = cexpr
                -- type IndentParser s a = ParserT s (State Position) a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "runIndent"
            , def = e.fn2 (e.class "State" [ e.classE "Position", e.n "a" ]) (e.n "a")
                -- State Position a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withBlock"
            , def =
                e.fn [ e.br (e.fn3 (e.n "a") (e.class1 "List" (e.n "b")) (e.n "c")), ipsa, ipsb, ipsc ]
                -- (a -> List b -> c) -> IndentParser s a -> IndentParser s b -> IndentParser s c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withBlock'"
            , def = e.fn [ ipsa, ipsb, ipslb ]
                -- IndentParser s a -> IndentParser s b -> IndentParser s (List b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "block"
            , def = e.fn [ ipsa, ipsla ]
                -- IndentParser s a -> IndentParser s (List a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "block1"
            , def = e.fn [ ipsa, ipsla ]
                -- IndentParser s a -> IndentParser s (List a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indented"
            , def = ipsu
                -- IndentParser s Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indented'"
            , def = ipsu
                -- IndentParser s Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sameLine"
            , def = ipsu
                -- IndentParser s Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sameOrIndented"
            , def = ipsu
                -- IndentParser s Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "checkIndent"
            , def = ipsu
                -- IndentParser s Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withPos"
            , def = e.fn2 ipsa ipsa
                -- IndentParser s a -> IndentParser s a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentAp"
            , def = e.fn [ ips (e.br (e.fn2 (e.n "a") (e.n "b"))), ipsa, ipsb ]
                -- IndentParser s (a -> b) -> IndentParser s a -> IndentParser s b
            , belongs = tc.Belongs.No
            , op = Some "<+/>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentNoAp"
            , def = e.fn [ ipsa, ipsb, ipsa ]
                -- IndentParser s a -> IndentParser s b -> IndentParser s a
            , belongs = tc.Belongs.No
            , op = Some "<-/>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentMany"
            , def = e.fn [ ips (e.br (e.fn2 (e.class1 "List" (e.n "a")) (e.n "b"))), ipsa, ipsb ]
                -- IndentParser s (List a -> b) -> IndentParser s a -> IndentParser s b
            , belongs = tc.Belongs.No
            , op = Some "<*/>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentOp"
            , def = e.fn [ ips (e.br (e.fn2 (e.n "a") (e.n "b"))), e.class "Optional" [ e.n "s", e.n "a" ], ipsb ]
                -- IndentParser s (a -> b) -> Optional s a -> IndentParser s b
            , belongs = tc.Belongs.No
            , op = Some "<?/>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentBrackets"
            , def = ipstra2ipstra
                -- IndentParser String a -> IndentParser String a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentAngles"
            , def = ipstra2ipstra
                -- IndentParser String a -> IndentParser String a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentBraces"
            , def = ipstra2ipstra
                -- IndentParser String a -> IndentParser String a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "indentParens"
            , def = ipstra2ipstra
                -- IndentParser String a -> IndentParser String a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indentparser