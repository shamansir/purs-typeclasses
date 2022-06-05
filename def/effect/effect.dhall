let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let effect : tc.TClass =
    { id = "effect"
    , name = "Effect"
    , what = tc.What.Data_
    , info = "A native effect"
    , module = [ "Data" ]
    , package = "purescript-effect"
    , link = "purescript-effect/3.0.0/docs/Effect"
    , members =
        [
            { name = "Effect"
            , def = e.fn (e.classE "Type") (e.classE "Type") -- Type -> Type
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "untilE"
            , def =
                -- Effect Boolean -> Effect Unit
                e.fn (e.subj1_ "Effect" (e.rv (e.classE "Boolean"))) (e.subj1_ "Effect" (e.rv (e.classE "Unit")))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "whileE"
            , def =
                -- Effect Boolean -> Effect a -> Effect Unit
                e.fnvs
                    [ e.subj1_ "Effect" (e.rv (e.classE "Boolean"))
                    , e.subj1_ "Effect" (e.n "a")
                    , e.subj1_ "Effect" (e.rv (e.classE "Unit"))
                    ]
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "forE"
            , def =
                -- Int -> Int -> (Int -> Effect Unit) -> Effect Unit
                e.fnvs
                    [ e.classE "Int"
                    , e.classE "Int"
                    , e.rtv (e.fn (e.classE "Int") (e.rtv (e.ap (e.subjE "Effect") (e.classE "Boolean"))))
                    , e.subj1_ "Effect" (e.n "a")
                    , e.subj1_ "Effect" (e.rv (e.classE "Unit"))
                    ]
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "forEachE"
            , def =
                -- Array a -> (a -> Effect Unit) -> Effect Unit
                e.fnvs
                    [ e.class1_ "Array" (e.n "a")
                    , e.rtv (e.fn (e.vn "a") (e.rtv (e.ap (e.subjE "Effect") (e.classE "Boolean"))))
                    , e.subj1_ "Effect" (e.rv (e.classE "Unit"))
                    ]
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
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

    } /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noVars /\ tc.noValues

in effect