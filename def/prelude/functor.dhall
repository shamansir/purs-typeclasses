let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let functor : tc.TClass =
    { id = "functor"
    , name = "Functor"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = "Convert and forget"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Functor"
    , members =
        [
            { name = "map"
            , def =
                e.fn3
                    (e.br (e.fn2 (e.n "a") (e.n "b")))
                    (e.ap2 (e.f "f") (e.n "a"))
                    (e.ap2 (e.f "f") (e.n "b"))
                -- (a -> b) -> f a -> f b
            , belongs = tc.Belongs.Yes
            , op = Some "<$>"
            , opEmoji = Some "🚂"
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lr
                            { left = e.op_fn1 "<$>" (e.callE "id") -- (<$>) id
                            , right = e.callE "id" -- id
                            }
                        ]
                    }
                ,
                    { law = "composition"
                    , examples =
                        [ tc.lr
                            { left =
                                e.op_fn1 "<$>" (e.br (e.opc2 (e.f "f") "<<<" (e.f "g")))
                                -- (<$>) (f <<< g)
                            , right =
                                e.opc2
                                    (e.br (e.ap2 (e.f "f") (e.op "<$>")))
                                    "<<<"
                                    (e.br (e.ap2 (e.f "g") (e.op "<$>")))
                                -- (f <$>) <<< (g <$>)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "mapFlipped"
            , def =
                e.req1
                    (e.subj1 "Functor" (e.f "f"))
                    (e.fn3
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.br (e.fn2 (e.n "a") (e.n "b")))
                        (e.ap2 (e.f "f") (e.n "b"))
                    )
                -- Functor f => f a -> (a -> b) -> f b
            , belongs = tc.Belongs.No
            , op = Some "<#>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "void"
            , def =
                e.req1
                    (e.subj1 "Functor" (e.f "f"))
                    (e.fn2
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.ap2 (e.f "f") (e.classE "Unit"))
                    )
                -- Functor f => f a -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "voidRight"
            , op = Some "<$"
            , def =
                e.req1
                    (e.subj1 "Functor" (e.f "f"))
                    (e.fn3
                        (e.n "a")
                        (e.ap2 (e.f "f") (e.n "b"))
                        (e.ap2 (e.f "f") (e.n "a"))
                    )
                -- Functor f => a -> f b -> f a
            , belongs = tc.Belongs.No
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "voidLeft"
            , op = Some "$>"
            , def =
                e.req1
                    (e.subj1 "Functor" (e.f "f"))
                    (e.fn3
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.n "b")
                        (e.ap2 (e.f "f") (e.n "b"))

                    )
                -- Functor f => f a -> b -> f b
            , belongs = tc.Belongs.No
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "flap"
            , op = Some "<@>"
            , def =
                e.req1
                    (e.subj1 "Functor" (e.f "f"))
                    (e.fn3
                        (e.ap2 (e.f "f") (e.br (e.fn2 (e.n "a") (e.n "b"))))
                        (e.n "a")
                        (e.ap2 (e.f "f") (e.n "b"))
                    )
                -- Functor f => f (a -> b) -> a -> f b
            , belongs = tc.Belongs.No
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in functor