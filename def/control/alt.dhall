let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Alt :: (Type -> Type) -> Constraint
-- class (Functor f) <= Alt f where

let alt : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "alt")
            "Alt"
            [ d.v "f" ]
            [ d.p (d.id "functor") "Functor" [ d.v "f" ] ]
            d.t2c
    , info = "Associative operation on a constructor"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , members =
        [
            { name = "alt"
            , def =
                -- f a -> f a -> f a
                e.fn3
                    (e.ap2 (e.f "f") (e.n "a" ))
                    (e.ap2 (e.f "f") (e.n "a" ))
                    (e.ap2 (e.f "f") (e.n "a" ))
            , op = Some "<|>"
            , opEmoji = Some "🔗"
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- (x <|> y) <|> z
                                e.opc2
                                    (e.br (e.opc2 (e.n "x") "<|>" (e.n "y")))
                                    "<|>"
                                    (e.n "z")
                            , right =
                                -- x <|> (y <|> z)
                                e.opc2
                                    (e.n "x")
                                    "<|>"
                                    (e.br (e.opc2 (e.n "y") "<|>" (e.n "z")))
                            }
                        ]
                    }
                ,
                    { law = "distributivity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- f <$> (x <|> y)
                                e.opc2
                                    (e.f "f")
                                    "<$>"
                                    (e.br (e.opc2 (e.n "x") "<|>" (e.n "y")))
                            , right =
                                e.opc2
                                    (e.br (e.opc2 (e.f "f") "<$>" (e.n "x")))
                                    "<|>"
                                    (e.n "y")
                                -- (f <$> x) <|> y
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in alt