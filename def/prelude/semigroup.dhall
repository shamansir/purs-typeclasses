let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Semigroup a where

let semigroup : tc.TClass =
    { spec =
        d.class_v
            (d.id "semigroup")
            "Semigroup"
            [ d.v "a" ]
    , info = "Associativity"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "append"
            , def = e.fn3 (e.n "a") (e.n "a") (e.n "a") -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "<>"
            , opEmoji = Some "🙏"
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left = e.opc2 (e.br (e.opc2 (e.n "x") "<>" (e.n "y"))) "<>" (e.n "z")
                                -- (x <> y) <> z
                            , right = e.opc2 (e.n "x") "<>" (e.br (e.opc2 (e.n "y") "<>" (e.n "z")))
                                -- x <> (y <> z)
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "String"
        , i.instanceCl "Unit"
        , i.instanceCl "Void"
        , i.instanceClA "Array"
        , e.req1
            (e.subj1 "Semigroup" (e.n "s'"))
            (e.subj1 "Semigroup" (e.br (e.fn2 (e.n "s") (e.n "s"))))
            -- Semigroup s' => Semigroup (s -> s')"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in semigroup