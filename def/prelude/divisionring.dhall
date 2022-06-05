let tc = ./../../typeclass.dhall

let divisionRing : tc.TClass =
    { id = "divisionring"
    , name = "DivisionRing"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "ring" ]
    , info = "Non-zero rings in which every non-zero element has a multiplicative inverse / skew fields"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.DivisionRing"
    , members =
        [
            { name = "recip"
            , def = "{{var:a}} {{op:->}} {{var:a}}" -- a -> a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "Non-zero Ring"
                    , examples =
                        [ tc.of
                            { fact = "{{method:one}} {{op:/=}} {{method:zero}}" -- one /= zero
                            }
                        ]
                    }
                ,
                    { law = "Non-zero multplicative inverse"
                    , examples =
                        [ tc.lmr
                            { left = "{{method:recip}} {{var:a}} {{op:*}} {{var:a}}" -- recip a * a
                            , middle = "{{var:a}} {{op:*}} {{method:recip}} {{var:a}}" -- a * recip a
                            , right = "{{method:one}} {{kw:forall}} {{var:a}} {{op:/=}} {{val:0}}" -- one forall a /= 0
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ,
            { name = "leftDiv"
            , def = "{{subj:DivisionRing}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- DivisionRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "rightDiv"
            , def = "{{subj:DivisionRing}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- DivisionRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances = [ "Number" ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in divisionRing