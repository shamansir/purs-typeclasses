let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let biapply : tc.TClass =
    { id = "biapply"
    , name = "Biapply"
    , what = tc.What.Class_
    , vars = [ "w" ]
    , parents = [ "bifunctor" ]
    , info = "Captures type constructors of two arguments in Apply"
    , module = [ "Control" ]
    , package = "purescript-bifunctors"
    , link = "purescript-bifunctors/5.0.0/docs/Control.Biapply"
    , members =
        [
            { name = "biapply"
            , def =
                -- w (a -> b) (c -> d) -> w a c -> w b d
                e.fn3
                    (e.ap_ (e.t "w") [ e.r (e.fnBr (e.vn "a") (e.vn "b")), e.r (e.fnBr (e.vn "c") (e.vn "d")) ])
                    (e.ap_ (e.t "w") [ e.n "a", e.n "c" ])
                    (e.ap_ (e.t "w") [ e.n "b", e.n "d" ])
            , op = Some "<<*>>"
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws
        ,

            { name = "Control.Category.identity"
            , def = e.ap3 (e.vn "a") (e.vt "t") (e.vt "t") -- a t t
            , belongs = tc.Belongs.No
            , op = Some "<<$>>"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.of
                            { fact =
                                -- bipure f g <<$>> x <<*>> y
                                e.inf
                                    ("<<$>>")
                                    (e.call_ "bipure" [ e.f "f", e.f "g" ])
                                    (e.rtv (e.inf ("<<*>>") (e.vn "x") (e.vn "y")))
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "biapplyFirst"
            , def =
                -- Biapply w => w a b -> w c d -> w c d
                e.req1
                    (e.subj_ "Biapply" [ e.t "w" ])
                    (e.rtv
                        (e.fn3
                            (e.ap_ (e.t "w") [ e.n "a", e.n "b" ])
                            (e.ap_ (e.t "w") [ e.n "c", e.n "d" ])
                            (e.ap_ (e.t "w") [ e.n "c", e.n "d" ])
                        )
                    )
            , op = Some "*>>"
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.No
            } /\ tc.noLaws
        ,
            { name = "biapplySecond"
            , def =
                 -- Biapply w => w a b -> w c d -> w a b
                e.req1
                    (e.subj_ "Biapply" [ e.t "w" ])
                    (e.rtv
                        (e.fn3
                            (e.ap_ (e.t "w") [ e.n "a", e.n "b" ])
                            (e.ap_ (e.t "w") [ e.n "c", e.n "d" ])
                            (e.ap_ (e.t "w") [ e.n "a", e.n "b" ])
                        )
                    )
            , op = Some "<<*"
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.No
            } /\ tc.noLaws
        ,
            { name = "blift2"
            , def =
                -- Biapply w => (a -> b -> c) -> (d -> e -> f) -> w a d -> w b e -> w c f
                e.req1
                    (e.subj_ "Biapply" [ e.t "w" ])
                    (e.rtv
                        (e.fnvs
                            [ e.fn_ [ e.n "a", e.n "b", e.n "c" ]
                            , e.fn_ [ e.n "d", e.n "e", e.n "f" ]
                            , e.ap_ (e.t "w") [ e.n "a", e.n "d" ]
                            , e.ap_ (e.t "w") [ e.n "b", e.n "e" ]
                            , e.ap_ (e.t "w") [ e.n "c", e.n "f" ]
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "blift3"
            , def =
                -- Biapply w => (a -> b -> c -> d) -> (e -> f -> g -> h) -> w a e -> w b f -> w c g -> w d h
                e.req1
                    (e.subj_ "Biapply" [ e.t "w" ])
                    (e.rtv
                        (e.fnvs
                            [ e.fn_ [ e.n "a", e.n "b", e.n "c", e.n "d" ]
                            , e.fn_ [ e.n "e", e.n "f", e.n "g", e.n "h" ]
                            , e.ap_ (e.t "w") [ e.n "a", e.n "e" ]
                            , e.ap_ (e.t "w") [ e.n "b", e.n "f" ]
                            , e.ap_ (e.t "w") [ e.n "c", e.n "g" ]
                            , e.ap_ (e.t "w") [ e.n "d", e.n "h" ]
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Tuple" "Biapply"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in biapply