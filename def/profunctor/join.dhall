let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Join :: forall k. (k -> k -> Type) -> k -> Type
-- newtype Join p a

let join : tc.TClass =
    { id = "join"
    , name = "Join"
    , what = tc.What.Newtype_
    , vars = [ "p", "a" ]
    , info = ""
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Join"
    , spec = d.nt_c (d.id "join") "Join" [ d.v "p", d.v "a" ] d.kkt_kt
    , members =
        [
            { name = "Join"
            , def =
                e.subj1 "Join" (e.br (e.ap3 (e.t "p") (e.n "a") (e.n "a")))
                -- Join (p a a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ e.subj "Newtype" [ e.br (e.ap2 (e.t "p") (e.n "a")), e.ph ] -- Newtype (Join p a) _
        , e.req1
            (e.br (e.class1 "Eq" (e.br (e.ap3 (e.t "p") (e.n "a") (e.n "a")))))
            (e.class1 "Eq" (e.br (e.class "Join" [ e.t "p", e.n "a" ])))
            -- (Eq (p a a)) => Eq (Join p a)
        , e.req1
            (e.br (e.class1 "Ord" (e.br (e.ap3 (e.t "p") (e.n "a") (e.n "a")))))
            (e.class1 "Ord" (e.br (e.class "Join" [ e.t "p", e.n "a" ])))
            -- (Ord (p a a)) => Ord (Join p a)
        , e.req1
            (e.br (e.class1 "Show" (e.br (e.ap3 (e.t "p") (e.n "a") (e.n "a")))))
            (e.class1 "Show" (e.br (e.class "Join" [ e.t "p", e.n "a" ])))
            -- (Show (p a a)) => Show (Join p a)
        , e.req1
            (e.br (e.class1 "Semigroupoid" (e.t "p")))
            (e.class1 "Semigroup" (e.br (e.class "Join" [ e.t "p", e.n "a" ])))
            -- (Semigroupoid p) => Semigroup (Join p a)
        , e.req1
            (e.br (e.class1 "Category" (e.t "p")))
            (e.class1 "Monoid" (e.br (e.class "Join" [ e.t "p", e.n "a" ])))
            -- (Category p) => Monoid (Join p a)
        , e.req1
            (e.br (e.class1 "Category" (e.t "p")))
            (e.class1 "Invariant" (e.br (e.class1 "Join" (e.t "p"))))
            -- (Profunctor p) => Invariant (Join p)
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents /\ tc.noStatements

in join