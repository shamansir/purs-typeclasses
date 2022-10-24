let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- class Plus :: (Type -> Type) -> Constraint
-- class (Alt f) <= Plus f where

let plus : tc.TClass =
    { id = "plus"
    , name = "Plus"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "alt" ]
    , info = "Left and Right identity for Alt"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , link = "purescript-control/5.0.0/docs/Control.Plus"
    , def =
        d.class_vpc
            (d.id "plus")
            "Plus"
            [ d.v "f" ]
            [ d.p (d.id "alt") "Alt" [ d.v "f" ] ]
            d.t2c
    , members =
        [
            { name = "empty"
            , def = e.ap2 (e.f "f") (e.n "a") -- f a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "left identity"
                    , examples =
                        [ tc.lr
                            { left =
                                 -- empty <|> x
                                e.opc2 (e.callE "empty") "<|>" (e.n "x")
                            , right =
                                -- x
                                e.n "x"
                            }
                        ]
                    }
                ,
                    { law = "right identity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- x <|> empty
                                e.opc2 (e.n "x") "<|>" (e.callE "empty")
                            , right =
                                -- x
                                e.n "x"
                            }
                        ]
                    }
                ,
                    { law = "annihilation"
                    , examples =
                        [ tc.lr
                            { left =
                                -- f <$> empty
                                e.opc2 (e.f "f") "<$>" (e.callE "empty")
                            , right =
                                -- empty
                                e.callE "empty"
                            }
                        ]
                    }
                ]
            } /\ tc.noOps /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in plus