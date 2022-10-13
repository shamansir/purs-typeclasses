let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- class Contravariant :: (Type -> Type) -> Constraint
-- class Contravariant f where

let contravariant : tc.TClass =
    { id = "contravariant"
    , name = "Contravariant"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = "A way of changing the input type of a consumer of input"
    , module = [ "Data", "Functor" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Functor.Contravariant"
    , laws =
        [
            { law = "identity"
            , examples =
                [ tc.lr
                    { left = e.op_fn1 ">$<" (e.callE "identity")  -- (>$<) identity
                    , right = e.callE "identity" -- identity
                    }
                ]
            }
        ,
            { law = "composition"
            , examples =
                [ tc.lr
                    { left =
                        -- (f >$<) <<< (g >$<) =
                        e.opc2
                            (e.br (e.ap2 (e.f "f") (e.op ">$<")))
                            "<<<"
                            (e.br (e.ap2 (e.f "g") (e.op ">$<")))
                    , right =
                         -- (>$<) (g <<< f)
                        e.op_fn1
                            ">$<"
                            (e.br (e.opc2 (e.f "g") "<<<" (e.f "f")))
                    }
                ]
            }
        ]
    , members =
        [
            { name = "cmap"
            , def =
                -- (b -> a) -> f a -> f b
                (e.fn
                    [ e.br (e.fn2 (e.n "b") (e.n "a"))
                    , e.ap2 (e.f "f") (e.n "a")
                    , e.ap2 (e.f "f") (e.n "b")
                    ]
                )
            , belongs = tc.Belongs.Yes
            , op = Some ">$<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "cmapFlipped"
            , def =
                -- Contravariant f => f a -> (b -> a) -> f b
                e.req1
                    (e.subj1 "Contravariant" (e.f "f"))
                    (e.fn
                        [ e.ap2 (e.f "f") (e.n "a")
                        , e.br (e.fn2 (e.n "b") (e.n "a"))
                        , e.ap2 (e.f "f") (e.n "b")
                        ]
                    )
            , belongs = tc.Belongs.No
            , op = Some ">#<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "coerce"
            , def =
                -- Contravariant f => Functor f => f a -> f b
                e.reqseq
                    [ e.subj1 "Bifunctor" (e.f "f")
                    , e.subj1 "Functor" (e.f "f")
                    ]
                    (e.fn2
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.ap2 (e.f "f") (e.n "b"))
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    } /\ tc.noParents /\ tc.noValues /\ tc.noStatements /\ tc.noInstances

in contravariant