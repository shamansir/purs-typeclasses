let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let alt : tc.TClass =
    { id = "alt"
    , name = "Alt"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "functor" ]
    , info = "Associative operation on a constructor"
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.Alt#t:Alt"
    , members =
        [
            { name = "alt"
            , def =
                -- f a -> f a -> f a
                e.fn3
                    (e.ap_ (e.f "f") [ e.n "a" ])
                    (e.ap_ (e.f "f") [ e.n "a" ])
                    (e.ap_ (e.f "f") [ e.n "a" ])
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
                                e.inf "<|>"
                                    (e.rtvbr (e.inf "<|>" (e.vn "x") (e.vn "y")))
                                    (e.vn "z")
                            , right =
                                -- x <|> (y <|> z)
                                e.inf "<|>"
                                    (e.vn "x")
                                    (e.rtvbr (e.inf "<|>" (e.vn "y") (e.vn "z")))
                            }
                        ]
                    }
                ,
                    { law = "distributivity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- f <$> (x <|> y)
                                e.inf "<$>"
                                    (e.vf "f")
                                    (e.rtvbr (e.inf "<|>" (e.vn "x") (e.vn "y")))
                            , right =
                                -- (f <$> x) <|> y
                                e.inf "<|>"
                                    (e.rtvbr (e.inf "<$>" (e.vf "f") (e.vn "y")))
                                    (e.vn "y")
                            }
                        ]
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in alt