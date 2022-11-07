let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Re :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type
-- newtype Re p s t a b


let re : tc.TClass =
    { id = "re"
    , name = "Re"
    , what = tc.What.Newtype_
    , vars = [ "p", "s", "t", "a", "b" ]
    , info = ""
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens"
    , spec = d.nt_c (d.id "re") "Re" [ d.v "p", d.v "s", d.v "t", d.v "a", d.v "b" ] d.t3t5
    , members =
        [
            { name = "Re"
            , def =
                e.class1 "Re" (e.br (e.fn2 (e.ap3 (e.t "p") (e.n "b") (e.n "a")) (e.ap3 (e.t "p") (e.n "t") (e.n "s"))))
                -- Re (p b a -> p t s)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in re

-- Newtype (Re p s t a b) _
-- (Profunctor p) => Profunctor (Re p s t)
-- (Choice p) => Cochoice (Re p s t)
-- (Cochoice p) => Choice (Re p s t)
-- (Strong p) => Costrong (Re p s t)
-- (Costrong p) => Strong (Re p s t)