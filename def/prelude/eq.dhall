let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let eq : tc.TClass =
    { id = "eq"
    , name = "Eq"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Equality"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Eq"
    , members =
        [
            { name = "eq"
            , def =
                e.fn3
                    (e.n "a")
                    (e.n "a")
                    (e.classE "Boolean")
                -- a -> a -> Boolean
            , op = Some "=="
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "reflexivity"
                    , examples =
                        [ tc.lr
                            { left = e.inf2 (e.n "x") "==" (e.n "x") -- x == x
                            , right = e.u "true" -- true
                            }
                        ]
                    }
                ,
                    { law = "symmetry"
                    , examples =
                        [ tc.lr
                            { left = e.inf2 (e.n "x") "==" (e.n "y") -- x == y
                            , right = e.inf2 (e.n "y") "==" (e.n "x") -- y == x
                            }
                        ]
                    }
                ,
                    { law = "transitivity"
                    , examples =
                        [ tc.fc
                            { fact =
                                e.inf2
                                    (e.br (e.inf2 (e.n "x") "==" (e.n "y")))
                                    "and"
                                    (e.br (e.inf2 (e.n "y") "==" (e.n "z")))
                                 -- (x == y) and (y == z)
                            , conclusion =
                                e.inf2 (e.n "y") "==" (e.n "x") -- y == x
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "notEq"
            , def =
                e.req1
                    (e.subj1 "Eq" (e.n "a"))
                    (e.fn3
                        (e.n "a")
                        (e.n "a")
                        (e.classE "Boolean"))
                -- Eq a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some "/="
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Int"
        , i.instanceCl "Number"
        , i.instanceCl "Char"
        , i.instanceCl "String"
        , i.instanceCl "Unit"
        , i.instanceCl "Void"
        , i.instanceReqASubj "Array" "Eq"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in eq