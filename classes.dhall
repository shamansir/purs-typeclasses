let tc = ./typeclass.dhall

let List/map =
    https://prelude.dhall-lang.org/List/map

let defs =
    [ ./def/prelude/additive.dhall
    , ./def/prelude/apply.dhall
    , ./def/prelude/bind.dhall
    , ./def/prelude/boolean.dhall
    , ./def/prelude/booleanalgebra.dhall
    , ./def/prelude/bounded.dhall
    , ./def/prelude/category.dhall
    , ./def/prelude/commutativering.dhall
    , ./def/prelude/conj.dhall
    , ./def/prelude/disj.dhall
    , ./def/prelude/divisionring.dhall
    , ./def/prelude/dual.dhall
    , ./def/prelude/endo.dhall
    , ./def/prelude/eq.dhall
    , ./def/prelude/euclidianring.dhall
    , ./def/prelude/field.dhall
    , ./def/prelude/first.dhall
    , ./def/prelude/function.dhall
    , ./def/prelude/functor.dhall
    , ./def/prelude/heytingalgebra.dhall
    , ./def/prelude/last.dhall
    , ./def/prelude/monad.dhall
    , ./def/prelude/monoid.dhall
    , ./def/prelude/multiplicative.dhall
    , ./def/prelude/nattrans.dhall
    , ./def/prelude/ord.dhall
    , ./def/prelude/ordering.dhall
    , ./def/prelude/proxy.dhall
    , ./def/prelude/ring.dhall
    , ./def/prelude/semigroup.dhall
    , ./def/prelude/semigroupoid.dhall
    , ./def/prelude/semiring.dhall
    , ./def/prelude/show.dhall
    , ./def/prelude/unit.dhall
    , ./def/prelude/void.dhall

    , ./def/const/const.dhall

    , ./def/contravariant/comparison.dhall
    , ./def/contravariant/decidable.dhall
    , ./def/contravariant/decide.dhall
    , ./def/contravariant/divide.dhall
    , ./def/contravariant/divisible.dhall
    , ./def/contravariant/equivalence.dhall
    , ./def/contravariant/contravariant.dhall
    , ./def/contravariant/op.dhall
    , ./def/contravariant/predicate.dhall

    , ./def/control/alt.dhall
    , ./def/control/alternate.dhall
    , ./def/control/alternative.dhall
    , ./def/control/comonad.dhall
    , ./def/control/extend.dhall
    , ./def/control/lazy.dhall
    , ./def/control/monadplus.dhall
    , ./def/control/monadzero.dhall
    , ./def/control/plus.dhall

    , ./def/effect/effect.dhall
    , ./def/effect/monadeffect.dhall

    , ./def/foldable-traversable/bifoldable.dhall
    , ./def/foldable-traversable/foldable.dhall
    -- , ./def/foldable-traversable/foldable1.dhall
    -- , ./def/foldable-traversable/foldablewithindex.dhall
    , ./def/foldable-traversable/traversable.dhall
    -- , ./def/foldable-traversable/traversable1.dhall
    -- , ./def/foldable-traversable/traversablewithindex.dhall
    , ./def/foldable-traversable/bitraversable.dhall

    , ./def/functors/app.dhall
    , ./def/functors/clown.dhall
    , ./def/functors/compose.dhall
    , ./def/functors/coproduct.dhall
    , ./def/functors/inject.dhall
    , ./def/functors/costar.dhall
    , ./def/functors/flip.dhall
    , ./def/functors/joker.dhall
    , ./def/functors/product.dhall
    , ./def/functors/product2.dhall

    , ./def/bifunctors/biapplicative.dhall
    , ./def/bifunctors/biapply.dhall
    , ./def/bifunctors/bifunctor.dhall

    , ./def/invariant/invariant.dhall

    , ./def/distributive/distributive.dhall

    , ./def/profunctor/choice.dhall
    , ./def/profunctor/closed.dhall
    , ./def/profunctor/cochoice.dhall
    , ./def/profunctor/costrong.dhall
    , ./def/profunctor/join.dhall
    , ./def/profunctor/profunctor.dhall
    , ./def/profunctor/split.dhall
    , ./def/profunctor/star.dhall
    , ./def/profunctor/strong.dhall

    ] : List tc.TClass

in
    { defs =
        List/map
            tc.TClass
            tc.TClassText
            tc.TClass/toText
            defs
    }
