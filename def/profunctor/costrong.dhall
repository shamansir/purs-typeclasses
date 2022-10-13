let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let costrong : tc.TClass =
    { id = "costrong"
    , name = "Costrong"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Provides the dual operations of the Strong class"
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Costrong"
    , members =
        [
            { name = "unfirst"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])) (e.br (e.class "Tuple" [ e.n "b", e.n "c" ])))
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                -- p (Tuple a c) (Tuple b c) -> p a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unsecond"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "b" ])) (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])))
                    (e.ap3 (e.t "p") (e.n "b") (e.n "c"))
                -- p (Tuple a b) (Tuple a c) -> p b c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Function" "Closed"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in costrong