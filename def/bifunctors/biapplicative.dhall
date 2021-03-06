let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let bifunctor : tc.TClass =
    { id = "biapplicative"
    , name = "Biapplicative"
    , what = tc.What.Class_
    , vars = [ "w" ]
    , parents = [ "biapply" ]
    , info = "Captures type constructors of two arguments in Applicative"
    , module = [ "Control" ]
    , package = "purescript-bifunctors"
    , link = "purescript-bifunctors/5.0.0/docs/Control.Biapplicative"
    , members =
        [
            { name = "bipure"
            , def = e.fn3 (e.vn "a") (e.vn "b") (e.ap_ (e.t "w") [ e.n "a", e.n "b" ]) -- a -> b -> w a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws /\ tc.noOps
        ]
    , instances =
        [ i.instanceSubj "Tuple" "Biapplicative"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in bifunctor