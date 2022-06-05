let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let monoid : tc.TClass =
    { id = "monoid"
    , name = "Monoid"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "semigroup" ]
    , info = "Folding empty collection"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid"
    , members =
        [
            { name = "mempty"
            , def = "{{typevar:m}}" -- m
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lmr
                            { left = "{{method:mempty}} {{op:<>}} {{var:x}}" -- mempty <> x
                            , middle = "{{var:x}} {{op:<>}} {{method:mempty}}" -- x <> mempty
                            , right = "{{var:x}} {{kw:forall}} {{var:x}}" -- x forall x
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ,
            { name = "power"
            , def = "{{subj:Monoid}} {{typevar:m}} {{op:=>}} {{typevar:m}} {{op:->}} {{class:Int}} {{op:->}} {{typevar:m}}" -- Monoid m => m -> Int -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "guard"
            , def = "{{subj:Monoid}} {{typevar:m}} {{op:=>}} {{class:Boolean}} {{op:->}} {{typevar:m}} {{op:->}} {{typevar:m}}" -- Monoid m => Boolean -> m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Unit"
        , i.instanceCl "Ordering"
        , i.instanceCl "Number"
        , i.instanceCl "String"
        , i.instanceClA "Array"
        , i.instanceReqSubjArrow "Monoid"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in monoid