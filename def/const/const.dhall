let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let const : tc.TClass =
    { id = "const"
    , name = "Const"
    , what = tc.What.Newtype_
    , vars = [ "a", "b" ]
    , info = "Wraps its first type argument and ignores its second"
    , module = [ "Data" ]
    , package = "purescript-const"
    , link = "purescript-const/3.0.0/docs/Data.Const"
    , members =
        [
            { name = "Const"
            , def = e.val (e.subj_ "Const" [ e.n "a" ]) -- Const a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceAB_ "Newtype" "Const"
        , i.instanceReqA_B "Eq" "Const"
        , i.instanceReqA_B "Ord" "Const"
        , i.instanceReqA_B "Bounded" "Const"
        , i.instanceReqA_B "Show" "Const"
        , i.instance "Semigroup" "Const"
        , i.instanceReqA_B "Semigroup" "Const"
        , i.instanceReqA_B "Monoid" "Const"
        , i.instanceReqA_B "Semiring" "Const"
        , i.instanceReqA_B "Ring" "Const"
        , i.instanceReqA_B "EucledeanRing" "Const"
        , i.instanceReqA_B "CommutativeRing" "Const"
        , i.instanceReqA_B "Field" "Const"
        , i.instanceReqA_B "HeytingAlgebra" "Const"
        , i.instanceReqA_B "BooleanAlgebra" "Const"
        , i.instanceA "Functor" "Const"
        , i.instanceA "Invariant" "Const"
        , i.instanceA "Contavariant" "Const"
        , i.instanceReqA2 "Semigroup" "Apply" "Const"
        , i.instanceReqA2 "Semigroup" "Bind" "Const"
        , i.instanceReqA2 "Monoid" "Applicative" "Const"
        , i.instanceA "Foldable" "Const"
        , i.instanceA "Traversable" "Const"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in const