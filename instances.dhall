let e =
    ./build_expr.dhall


{- Instances -}


 -- Class Subject
let instance =
    \(cl : Text) ->
    \(subj : Text) ->
    e.ap (e.classE cl) (e.subjE subj)

 -- Subject Class
let instanceSubj =
    \(cl : Text) ->
    \(subj : Text) ->
    e.ap (e.subjE subj) (e.classE cl)

 -- Class
let instanceCl =
    \(cl : Text) ->
    e.val (e.classE cl)

 -- Class a
let instanceClA =
    \(cl : Text) ->
    e.val (e.class_ cl [ e.n "a" ])

 -- (->)
let instanceArrow =
    e.val (e.op "->")

 -- ((->) r)
let instanceArrowR =
    e.ap (e.op "->") (e.vn "r")

-- (a -> b)
let instanceFn =
    e.fn (e.vn "a") (e.vn "b")

-- Class (Subject a)
let instanceA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rbrv (e.subj_ subj [ e.n "a" ]) ])

-- Class (Subject f)
let instanceF =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rbrv (e.subj_ subj [ e.f "f" ]) ])

 -- Class (Subject f a)
let instanceFA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rbrv (e.subj_ subj [ e.f "f", e.n "a" ]) ])

-- Subject (Class a)
let instanceSubjA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.subj_ subj [ e.rbrv (e.class_ cl [ e.n "a" ]) ])

 -- Subject (Class1 Class2)
let instanceSubjA2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.val (e.subj_ subj [ e.r (e.apBr (e.classE cl1) (e.classE cl2)) ])

-- Class Subject _
let instance_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rv (e.subjE subj), e.n "_" ])

 -- Class (Subject a) _
let instanceA_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rbrv (e.subj_ subj [ e.n "a" ]), e.n "_" ])

 -- Class (Subject f a) _
let instanceFA_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rbrv (e.subj_ subj [ e.n "a", e.f "f" ]), e.n "_" ])

-- Class (Subject a b) _
let instanceAB_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rbrv (e.subj_ subj [ e.n "a", e.n "b" ]), e.n "_" ])

-- Class (Subject f a b) _
let instanceFAB_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.val (e.class_ cl [ e.rbrv (e.subj_ subj [ e.f "f", e.n "a", e.n "b" ]), e.n "_" ])

-- Class a => Class (Subject a)
let instanceReqA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl [ e.n "a" ] ] (e.class_ cl [ e.rbrv (e.subj_ subj [ e.n "a" ]) ])

 -- Subject a => Subject (Class a)
let instanceReqASubj =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.subj_ subj [ e.n "a" ] ] (e.subj_ subj [ e.rbrv (e.class_ cl [ e.n "a" ]) ])

 -- Subject a => Subject (Class p)
let instanceReqPSubj =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.subj_ subj [ e.f "p" ] ] (e.subj_ subj [ e.rbrv (e.class_ cl [ e.f "p" ]) ])

 -- Class1 a => Class2 (Subject a)
let instanceReqA2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl1 [ e.n "a" ] ] (e.class_ cl2 [ e.rbrv (e.subj_ subj [ e.n "a" ]) ])

 -- Class f => Class (Subject f)
let instanceReqF =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl [ e.f "f" ] ] (e.class_ cl [ e.rbrv (e.subj_ subj [ e.f "f" ]) ])

 -- Class1 f => Class2 (Subject f)
let instanceReqF2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl1 [ e.f "f" ] ] (e.class_ cl2 [ e.rbrv (e.subj_ subj [ e.f "f" ]) ])

 -- Class1 f => Subject (Class2 f)
let instanceReqF2_ =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl1 [ e.f "f" ] ] (e.subj_ subj [ e.rbrv (e.class_ cl2 [ e.f "f" ]) ])

 -- Class f => Class (Subject f a)
let instanceReqFA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl [ e.f "f" ] ] (e.class_ cl [ e.rbrv (e.subj_ subj [ e.f "f", e.n "a" ]) ])

 -- Class (f a) => Class (Subject f a)
let instanceReqFA_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl [ e.r (e.apBr (e.vf "f") (e.vn "a")) ] ] (e.class_ cl [ e.rbrv (e.subj_ subj [ e.f "f", e.n "a" ]) ])

 -- Class a => Class (Subject a b)
let instanceReqA_B =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl [ e.n "a" ] ] (e.class_ cl [ e.rbrv (e.subj_ subj [ e.n "a", e.n "b" ]) ])

 -- Class (f a) => Class (Subject f a b)
let instanceReqFAB_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl [ e.r (e.apBr (e.vf "f") (e.vn "a")) ] ] (e.class_ cl [ e.rbrv (e.subj_ subj [ e.f "f", e.n "a", e.n "b" ]) ])

 -- Class f => Class Subject
let instanceReqF_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req [ e.class_ cl [ e.f "f" ] ] (e.class_ cl [ e.rv (e.subjE subj) ])

 -- Subject b => Subject (a -> b)
let instanceReqSubjArrow =
    \(subj : Text) ->
    e.req [ e.subj_ subj [ e.n "b" ] ] (e.subj_ subj [ e.r (e.fnBr (e.vn "a") (e.vn "b")) ])

 -- (Subject f, Subject g) => Subject (Class f g)
let instanceReqFG =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req
        [ e.subj_ subj [ e.f "f" ]
        , e.subj_ subj [ e.f "g" ]
        ]
        (e.subj_ subj [ e.rbrv (e.class_ cl [ e.f "f", e.f "g" ]) ])

 -- (Class2 f, Class1 a) => Class1 (Subject f a)
let instanceReqFA2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req
        [ e.class_ cl2 [ e.f "f" ]
        , e.class_ cl1 [ e.n "a" ]
        ]
        (e.class_ cl1 [ e.rbrv (e.subj_ subj [ e.f "f", e.n "a" ]) ])

in
    { instance, instanceCl, instanceSubj, instanceSubjA, instanceSubjA2, instanceClA, instanceArrow, instanceArrowR, instanceFn, instanceA, instanceF, instanceFA
    , instance_, instanceA_, instanceFA_, instanceAB_, instanceFAB_, instanceReqA_B
    , instanceReqA, instanceReqA2, instanceReqF2, instanceReqF2_, instanceReqASubj, instanceReqF,  instanceReqF_, instanceReqFA, instanceReqFA_, instanceReqFAB_
    , instanceReqSubjArrow, instanceReqFG, instanceReqFA2, instanceReqPSubj
    }