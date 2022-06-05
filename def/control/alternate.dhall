let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let alternate : tc.TClass =
    { id = "alternate"
    , name = "Alternate"
    , what = tc.What.Newtype_
    , vars = [ "f", "a" ]
    , info = "Monoid and Semigroup instances corresponding to Plus and Alt for f"
    , module = [ "Data", "Monoid" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Data.Monoid.Alternate#t:Alternate"
    , members =
        [
            { name = "Alternate"
            , def = e.val (e.subj_ "Alternate" [ e.f "f", e.n "a" ]) -- Alternate f a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left =
                -- Alternate fx <> Alternate fy
                e.inf
                    "<>"
                    (e.subj_ "Alternate" [ e.f "fx" ])
                    (e.subj_ "Alternate" [ e.f "fy" ])
            , right =
                 -- Alternate (fx <|> fy)
                e.val
                    (e.subj_ "Alternate"
                        [ e.rbr (e.inf "<|>" (e.vf "fx") (e.vf "fy"))
                        ]
                    )
            }
        ,
            { left =
                -- mempty :: Alternate _
                e.mdef "mempty" (e.subj_ "Alternate" [ e.ph ])
            , right =
                -- Alternate empty
                e.val
                    (e.subj_ "Alternate" [ e.rbrv (e.callE "empty") ])
            }
        ]
    , instances =
        [ i.instanceFA_ "Newtype" "Alternate"
        , i.instanceReqFA "Eq" "Alternate"
        , i.instanceReqA "Ord" "Alternate"
        , i.instanceReqA "Bounded" "Alternate"
        , i.instanceReqF_ "Functor" "Alternate"
        , i.instanceReqF "Invariant" "Alternate"
        , i.instanceReqF_ "Apply" "Alternate"
        , i.instanceReqF_ "Applicative" "Alternate"
        , i.instanceReqF_ "Bind" "Alternate"
        , i.instance "Monad" "Alternate"
        , i.instance "Extend" "Alternate"
        , i.instance "Comonad" "Alternate"
        , i.instanceFA "Show" "Alternate"
        , i.instanceFA "Semigroup" "Alternate"
        , i.instanceFA "Monoid" "Alternate"
        -- FIXME: incorrect instances
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in alternate