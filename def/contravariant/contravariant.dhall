let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let contravariant : tc.TClass =
    { id = "contravariant"
    , name = "Contravariant"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = "A way of changing the input type of a consumer of input"
    , module = [ "Data", "Functor" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Functor.Contravariant"
    , laws =
        [
            { law = "identity"
            , examples =
                [ tc.lr
                    { left = e.ap (e.op ">$<") (e.callE "identity")  -- (>$<) identity
                    , right = e.val (e.callE "identity") -- identity
                    }
                ]
            }
        ,
            { law = "composition"
            , examples =
                [ tc.lr
                    { left =
                        -- (f >$<) <<< (g >$<) =
                        e.inf
                            "<<<"
                            (e.rtv (e.apBr (e.vf "f") (e.op ">$<")))
                            (e.rtv (e.apBr (e.op ">$<") (e.vf "g")))
                    , right =
                         -- (>$<) (g <<< f)
                        e.ap
                            (e.op ">$<")
                            (e.rtv (e.inf "<<<" (e.vf "g") (e.vf "f")))
                    }
                ]
            }
        ]
    , members =
        [
            { name = "cmap"
            , def =
                -- (b -> a) -> f a -> f b
                (e.fnvs
                    [ e.fn_ [ e.n "b", e.n "a" ]
                    , e.ap1_ (e.f "f") (e.n "a")
                    , e.ap1_ (e.f "f") (e.n "b")
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
                    (e.subj_ "Contravariant" [ e.f "f" ])
                    (e.rtv
                        (e.fnvs
                            [ e.ap1_ (e.f "f") (e.n "a")
                            , e.fn_ [ e.n "b", e.n "a" ]
                            , e.ap1_ (e.f "f") (e.n "b")
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            , op = Some ">#<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "coerce"
            , def =
                -- Contravariant f => Functor f => f a -> f b
                e.req
                    [ e.subj_ "Bifunctor" [ e.f "f" ]
                    , e.subj_ "Functor" [ e.f "f" ]
                    ]
                    (e.rtv
                        (e.fnvs
                            [ e.ap1_ (e.f "f") (e.n "a")
                            , e.ap1_ (e.f "f") (e.n "b")
                            ]
                        )
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    } /\ tc.noParents /\ tc.noValues /\ tc.noStatements /\ tc.noInstances

in contravariant