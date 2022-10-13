let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class Semigroup a where

let semigroup : tc.TClass =
    { id = "semigroup"
    , name = "Semigroup"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Associativity"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Semigroup"
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
            }
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

    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in semigroup