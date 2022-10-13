let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall


let endo : tc.TClass =
    { id = "endo"
    , name = "Endo"
    , what = tc.What.Newtype_
    , vars = [ "c", "a" ]
    , info = "By itself"
    , module = [ "Data", "Monoid" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid.Endo"
    , statements =
        [
            { left =
                e.opc2
                    (e.subj1 "Endo" (e.f "f"))
                    "<>"
                    (e.subj1 "Endo" (e.f "g"))
                -- Endo f <> Endo g
            , right =
                e.subj1
                    "Endo"
                    (e.br (e.opc2 (e.f "f") "<<<" (e.f "g")))
                -- Endo (f <<< g)
            }
        ,
            { left =
                e.mdef1 "mempty" (e.subj1 "Endo" e.ph)
                -- mempty :: Endo _
            , right =
                e.subj1 "fixes" (e.callE "identity")
                -- Endo id
            }
        ]
    , members =
        [
            { name = "Endo"
            , def =
                e.subj1
                    "Endo"
                    (e.ap3 (e.t "c") (e.n "a") (e.n "a"))
                -- Endo (c a a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        let
            instanceCaa =
                \(cl : Text) ->
                    e.req1
                        (e.br (e.class1 cl (e.br (e.ap3 (e.t "c") (e.n "a") (e.n "a")))))
                        ((e.class1 cl (e.br (e.subj "Endo" [ e.t "c", e.n "a" ]))))
                    -- (Class (c a a)) => Class (Endo c a)
        let
            instanceC =
                \(cl1 : Text) -> \(cl2 : Text) ->
                    e.req1
                        (e.br (e.class1 cl1 (e.t "c")))
                        ((e.class1 cl2 (e.br (e.subj "Endo" [ e.t "c", e.n "a" ]))))
                    -- (Class1 c) => Class2 (Endo c a)
        in
        [ instanceCaa "Eq"
             -- (Eq (c a a)) => Eq (Endo c a)
        , instanceCaa "Ord"
             -- (Ord (c a a)) => Ord (Endo c a)
        , instanceCaa "Bounded"
            -- (Bounded (c a a)) => Bounded (Endo c a)
        , instanceCaa "Show"
            -- (Show (c a a)) => Show (Endo c a)
        , instanceC "Semigroupoid" "Semigroup"
            -- (Semigroupoid c) => Semigroup (Endo c a)
        , instanceC "Category" "Monoid"
            -- (Category c) => Monoid (Endo c a)
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents

in endo