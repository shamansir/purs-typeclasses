let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- class Biapply :: (Type -> Type -> Type) -> Constraint
-- class (Bifunctor w) <= Biapply w where

let biapply : tc.TClass =
    { id = "biapply"
    , name = "Biapply"
    , what = tc.What.Class_
    , vars = [ "w" ]
    , parents = [ "bifunctor" ]
    , info = "Captures type constructors of two arguments in Apply"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-bifunctors" +5
    , link = "purescript-bifunctors/5.0.0/docs/Control.Biapply"
    , members =
        [
            { name = "biapply"
            , def =
                -- w (a -> b) (c -> d) -> w a c -> w b d
                e.fn3
                    (e.ap3 (e.t "w") (e.br (e.fn2 (e.n "a") (e.n "b"))) (e.br (e.fn2 (e.n "c") (e.n "d"))))
                    (e.ap3 (e.t "w") (e.n "a") (e.n "c"))
                    (e.ap3 (e.t "w") (e.n "b") (e.n "d"))
            , op = Some "<<*>>"
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws /\ tc.noExamples
        ,

            { name = "Control.Category.identity"
            , def = e.ap3 (e.n "a") (e.t "t") (e.t "t") -- a t t
            , belongs = tc.Belongs.No
            , op = Some "<<$>>"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.of
                            { fact =
                                e.opc2
                                    (e.call "bipure" [ e.f "f", e.f "g" ])
                                    "<<$>>"
                                    (e.opc2 (e.n "x") "<<*>>" (e.n "y"))
                                -- bipure f g <<$>> x <<*>> y
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ,
            { name = "biapplyFirst"
            , def =
                -- Biapply w => w a b -> w c d -> w c d
                e.req1
                    (e.subj1 "Biapply" (e.t "w"))
                    (e.fn3
                        (e.ap3 (e.t "w") (e.n "a") (e.n "b") )
                        (e.ap3 (e.t "w") (e.n "c") (e.n "d") )
                        (e.ap3 (e.t "w") (e.n "c") (e.n "d") )
                    )
            , op = Some "*>>"
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.No
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "biapplySecond"
            , def =
                 -- Biapply w => w a b -> w c d -> w a b
                e.req1
                    (e.subj1 "Biapply" (e.t "w"))
                    (e.fn3
                        (e.ap3 (e.t "w") (e.n "a") (e.n "b") )
                        (e.ap3 (e.t "w") (e.n "c") (e.n "d") )
                        (e.ap3 (e.t "w") (e.n "a") (e.n "b") )
                    )
            , op = Some "<<*"
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.No
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "blift2"
            , def =
                -- Biapply w => (a -> b -> c) -> (d -> e -> f) -> w a d -> w b e -> w c f
                e.req1
                    (e.subj1 "Biapply" (e.t "w"))
                    (e.fn
                        [ e.br (e.fn [ e.n "a", e.n "b", e.n "c" ])
                        , e.br (e.fn [ e.n "d", e.n "e", e.n "f" ])
                        , e.ap3 (e.t "w") (e.n "a") (e.n "d")
                        , e.ap3 (e.t "w") (e.n "b") (e.n "e")
                        , e.ap3 (e.t "w") (e.n "c") (e.n "f")
                        ]
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "blift3"
            , def =
                -- Biapply w => (a -> b -> c -> d) -> (e -> f -> g -> h) -> w a e -> w b f -> w c g -> w d h
                e.req1
                    (e.subj1 "Biapply" (e.t "w"))
                    (e.fn
                        [ e.br (e.fn [ e.n "a", e.n "b", e.n "c", e.n "d" ])
                        , e.br (e.fn [ e.n "e", e.n "f", e.n "g", e.n "h" ])
                        , e.ap3 (e.t "w") (e.n "a") (e.n "e")
                        , e.ap3 (e.t "w") (e.n "b") (e.n "f")
                        , e.ap3 (e.t "w") (e.n "c") (e.n "g")
                        , e.ap3 (e.t "w") (e.n "d") (e.n "h")
                        ]
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Tuple" "Biapply"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in biapply