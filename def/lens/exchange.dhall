let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- data Exchange a b s t

let exchange : tc.TClass =
    { id = "exchange"
    , name = "Exchange"
    , what = tc.What.Newtype_
    , vars = [ "a", "b", "s", "t" ]
    , info = ""
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens"
    , members =
        [
            { name = "Exchange"
            , def =
                e.class "Exchange"
                    [ e.br (e.fn2 (e.n "s") (e.n "a"))
                    , e.br (e.fn2 (e.n "b") (e.n "t"))
                    ]
                -- Exchange (s -> a) (b -> t)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in exchange

-- Functor (Exchange a b s)
-- Profunctor (Exchange a b)