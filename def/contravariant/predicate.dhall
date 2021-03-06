let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let predicate : tc.TClass =
    { id = "predicate"
    , name = "Predicate"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "An adaptor allowing >$< to map over the inputs of predicate"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Predicate"
    , members =
        [
            { name = "Predicate"
            , def =
                -- Predicate (a -> Boolean)
                e.val
                    (e.subj_
                        "Predicate"
                        [ e.r
                            (e.fnvs
                                [ e.vf "a"
                                , e.vf "a"
                                , e.classE "Boolean"
                                ]
                            )
                        ]
                    )
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Predicate"
        , i.instance "Contravariant" "predicate"
        ]
    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in predicate