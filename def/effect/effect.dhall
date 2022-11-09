let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- data Effect t0

let effect : tc.TClass =
    { spec = d.data (d.id "effect") "Effect" [ d.v "t0" ]
    , info = "A native effect"
    , module = [ "Data" ] -- FIXME: wrong module?
    , package = tc.pkmj "purescript-effect" +3
    , members =
        [
            { name = "Effect"
            , def = e.fn2 (e.kw "Type") (e.kw "Type") -- Type -> Type
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "untilE"
            , def =
                -- Effect Boolean -> Effect Unit
                e.fn2 (e.subj1 "Effect" (e.classE "Boolean")) (e.subj1 "Effect" (e.classE "Unit"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "whileE"
            , def =
                -- Effect Boolean -> Effect a -> Effect Unit
                e.fn
                    [ e.subj1 "Effect" (e.classE "Boolean")
                    , e.subj1 "Effect" (e.n "a")
                    , e.subj1 "Effect" (e.classE "Unit")
                    ]
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "forE"
            , def =
                -- Int -> Int -> (Int -> Effect Unit) -> Effect Unit
                e.fn
                    [ e.classE "Int"
                    , e.classE "Int"
                    , e.br (e.fn2 (e.classE "Int") (e.ap2 (e.subjE "Effect") (e.classE "Unit")))
                    , e.subj1 "Effect" (e.classE "Unit")
                    ]
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "forEachE"
            , def =
                -- Array a -> (a -> Effect Unit) -> Effect Unit
                e.fn
                    [ e.class1 "Array" (e.n "a")
                    , e.br (e.fn2 (e.n "a") (e.ap2 (e.subjE "Effect") (e.classE "Unit")))
                    , e.subj1 "Effect" (e.classE "Unit")
                    ]
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Functor" "Effect"
        , i.instance "Apply" "Effect"
        , i.instance "Applicative" "Effect"
        , i.instance "Bind" "Effect"
        , i.instance "Monad" "Effect"
        , i.instanceReqA "Semigroup" "Effect"
        , i.instanceReqA "Monoid" "Effect"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in effect