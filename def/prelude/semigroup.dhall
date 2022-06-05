let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let semigroup : tc.TClass =
    { id = "semigroup"
    , name = "Semigroup"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Associativity"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Semigroup"
    , members =
        [
            { name = "append"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "<>"
            , opEmoji = Some "🙏"
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left = "({{var:x}} {{op:<>}} {{var:y}}) {{op:<>}} {{var:z}}" -- (x <> y) <> z
                            , right = "{{var:x}} {{op:<>}} ({{var:y}} {{op:<>}} {{var:z}})" -- x <> (y <> z)
                            }
                        ]
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "String"
        , i.instanceCl "Unit"
        , i.instanceCl "Void"
        , i.instanceClA "Array"
        , "{{subj:Semigroup}} {{var:s'}} {{op:=>}} {{subj:Semigroup}} ({{var:s}} {{op:->}} {{var:s'}})" -- "Semigroup s' => Semigroup (s -> s')"
        ]

    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in semigroup