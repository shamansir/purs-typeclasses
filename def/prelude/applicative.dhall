let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let applicative : tc.TClass =
    { id = "applicative"
    , name = "Applicative"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "apply" ]
    , info = "Lift with zero arguments, wrap values"
    , module = [ "Control" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Control.Applicative#t:Applicative"
    , members =
        [
            { name = "pure"
            , def =
                e.fn2 (e.n "a") (e.ap2 (e.f "a") (e.n "a"))
                -- a -> f a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lr
                            { left =
                                e.opc2 (e.br (e.call1 "pure" (e.callE "identity"))) "<*>" (e.n "v")
                                -- (pure id) <*> v
                            , right =
                                e.n "v"
                                -- v
                            }
                        ]
                    }
                ,
                    { law = "composition"
                    , examples =
                        [ tc.lr
                            { left =
                                e.opc4
                                    (e.br (e.call1 "pure" (e.op "<<<")))
                                    "<*>" (e.f "f")
                                    "<*>" (e.f "g")
                                    "<*>" (e.f "h")
                                -- (pure <<<) <*> f <*> g <*> h
                            , right =
                                e.opc2
                                    (e.f "f")
                                    "<*>"
                                    (e.br (e.opc2 (e.f "g") "<*>" (e.f "h")))
                                -- f <*> (g <*> h)
                            }
                        ]
                    }
                ,
                    { law = "homomorphism"
                    , examples =
                        [ tc.lr
                            { left =
                                e.opc2
                                    (e.br (e.call1 "pure" (e.f "f")))
                                    "<*>"
                                    (e.br (e.call1 "pure" (e.f "x")))
                                -- (pure f) <*> (pure x)
                            , right =
                                e.call1 "pure" (e.br (e.call1 "f" (e.n "x")))
                                -- pure (f x)
                            }
                        ]
                    }
                ,
                    { law = "interchange"
                    , examples =
                        [ tc.lr
                            { left =
                                e.opc2
                                    (e.f "u")
                                    "<*>"
                                    (e.br (e.call1 "pure" (e.n "y")))
                                -- u <*> (pure y)
                            , right =
                                e.opc2
                                    (e.br (e.call1 "pure" (e.ap2 (e.op "$") (e.n "y"))))
                                    "<*>"
                                    (e.f "u")
                                -- (pure ($ y)) <*> u
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ,
            { name = "liftA1"
            , def =
                e.req1
                    (e.subj1 "Applicative" (e.f "f"))
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.n "b")))
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.ap2 (e.f "f") (e.n "b"))
                    )
                -- Applicative f => (a -> b) -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "when"
            , def =
                e.req1
                    (e.subj1 "Applicative" (e.t "m"))
                    (e.fn3
                        (e.classE "Boolean")
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
                -- Applicative m => Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unless"
            , def =
                e.req1
                    (e.subj1 "Applicative" (e.t "m"))
                    (e.fn3
                        (e.classE "Boolean")
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
                -- Applicative m => Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in applicative