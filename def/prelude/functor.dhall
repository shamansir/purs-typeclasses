let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Functor :: (Type -> Type) -> Constraint
-- class Functor f where

let functor : tc.TClass =
    { spec =
        d.class_vc
            (d.id "functor")
            "Functor"
            [ d.v "f" ]
            d.t2c
    , info = "Convert and forget"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
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
                            { left = e.op_fn1 "<$>" (e.callE "identity") -- (<$>) id
                            , right = e.callE "identity" -- id
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
            } /\ tc.noExamples
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
            } /\ tc.noLaws /\ tc.noExamples
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
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
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
            } /\ tc.noLaws /\ tc.noExamples
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
            } /\ tc.noLaws /\ tc.noExamples
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
            } /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.w 2.0 /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in functor