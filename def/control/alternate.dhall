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
    , package = tc.pkmj "purescript-control" +5
    , link = "purescript-control/5.0.0/docs/Data.Monoid.Alternate#t:Alternate"
    , members =
        [
            { name = "Alternate"
            , def = e.subj "Alternate" [ e.f "f", e.n "a" ] -- Alternate f a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noLaws /\ tc.noOps
        ]
    , statements =
        [
            { left =
                -- Alternate fx <> Alternate fy
                e.opc2
                    (e.subj1 "Alternate" (e.f "fx"))
                    "<>"
                    (e.subj1 "Alternate" (e.f "fy"))
            , right =
                 -- Alternate (fx <|> fy)
                 e.subj1 "Alternate" (e.br (e.opc2 (e.f "fx") "<|>" (e.f "fy")))
            }
        ,
            { left =
                -- mempty :: Alternate _
                e.mdef1 "mempty" (e.subj1 "Alternate" e.ph)
            , right =
                e.subj1 "Alternate" (e.callE "empty")
                -- Alternate empty
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