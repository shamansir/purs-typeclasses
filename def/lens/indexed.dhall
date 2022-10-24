let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- newtype Indexed :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type
-- newtype Indexed p i s t

let indexed : tc.TClass =
    { id = "indexed"
    , name = "Indexed"
    , what = tc.What.Type_
    , vars = [ "p", "i", "s", "t" ]
    , info = "An indexed getter."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Getter"
    , def = d.nt_c (d.id "indexed") "Indexed" [ d.v "p", d.v "i", d.v "s", d.v "t" ] d.t3t4
    , members =
        [
            { name = "Indexed"
            , def =
                e.class1 "Indexed" (e.br
                    (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "i", e.n "s" ])) (e.n "t"))
                )
                -- Indexed (p (Tuple i s) t)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexed

-- Newtype (Indexed p i s t) _
-- (Profunctor p) => Profunctor (Indexed p i)
-- (Strong p) => Strong (Indexed p i)
-- (Choice p) => Choice (Indexed p i)
-- (Wander p) => Wander (Indexed p i)