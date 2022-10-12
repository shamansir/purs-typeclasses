let e =
    ./build_expr.dhall


{- Instances -}


-- TODO: add tests

 -- Class Subject
let instance =
    \(cl : Text) ->
    \(subj : Text) ->
    e.ap2 (e.classE cl) (e.subjE subj)

 -- Subject Class
let instanceSubj =
    \(cl : Text) ->
    \(subj : Text) ->
    e.ap2 (e.subjE subj) (e.classE cl)

 -- Subject Class1 Class2
let instanceSubj2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.ap3 (e.subjE subj) (e.classE cl1) (e.classE cl2)

 -- Class
let instanceCl =
    \(cl : Text) ->
    e.classE cl

 -- Class a
let instanceClA =
    \(cl : Text) ->
    e.class1 cl (e.n "a")

 -- (->)
let instanceArrow =
    e.br (e.op "->")

 -- ((->) r)
let instanceArrowR =
    e.br (e.ap2 (e.op "->") (e.n "r"))

-- (a -> b)
let instanceFn =
    e.fn2 (e.n "a") (e.n "b")

-- Class (Subject a)
let instanceA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class1 cl (e.br (e.subj1 subj (e.n "a")))

-- Class (Subject f)
let instanceF =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class1 cl (e.br (e.subj1 subj (e.f "f")))

 -- Class (Subject f a)
let instanceFA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class1 cl (e.br (e.subj subj [ e.f "f", e.n "a" ]))

-- Class (Subject f a b)
let instanceFAB =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class1 cl (e.br (e.subj subj [ e.f "f", e.n "a", e.n "b" ]))

-- Subject (Class a)
let instanceSubjA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.subj1 subj (e.br (e.class1 cl (e.n "a")))

-- Subject Class1 (Class2 a)
let instanceClSubjA =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.subj subj [ e.classE cl1, e.br (e.class1 cl2 (e.n "a")) ]

-- Subject (Class f)
let instanceSubjF =
    \(cl : Text) ->
    \(subj : Text) ->
    e.subj1 subj (e.br (e.class1 cl (e.f "f")))

 -- Subject (Class1 Class2)
let instanceSubjA2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.subj1 subj (e.br (e.class1 cl1 (e.classE cl2)))

-- Class Subject _
let instance_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class cl [ e.subjE subj, e.ph ]

 -- Class (Subject a) _
let instanceA_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class cl [ e.br (e.subj1 subj (e.n "a")), e.ph ]

 -- Class (Subject f a) _
let instanceFA_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class cl [ e.br (e.subj subj [e.f "f", e.n "a"]), e.ph ]

-- Class (Subject a b) _
let instanceAB_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class cl [ e.br (e.subj subj [e.n "a", e.n "b"]), e.ph ]

-- Class (Subject f a b) _
let instanceFAB_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.class cl [ e.br (e.subj subj [e.f "f", e.n "a", e.n "b"]), e.ph ]

-- Class a => Class (Subject a)
let instanceReqA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl (e.n "a")) (instanceSubjA cl subj)

 -- Subject a => Subject (Class a)
let instanceReqASubj =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1 (e.subj1 subj (e.n "a")) (instanceA cl subj)

 -- Subject a => Subject (Class p)
let instanceReqPSubj =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1
        (e.subj1 subj (e.n "a"))
        (e.subj1 subj (e.br (e.class1 cl (e.f "p"))))

 -- Class1 a => Class2 (Subject a)
let instanceReqA2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl1 (e.n "a")) (instanceSubjA cl2 subj)

 -- Class f => Class (Subject f)
let instanceReqF =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl (e.f "f")) (instanceF cl subj)

 -- Class1 f => Class2 (Subject f)
let instanceReqF2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl1 (e.f "f")) (instanceF cl2 subj)

 -- Class1 f => Subject (Class2 f)
let instanceReqF2_ =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl1 (e.f "f")) (instanceSubjF cl2 subj)

 -- Class f => Class (Subject f a)
let instanceReqFA =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl (e.f "f")) (instanceFA cl subj)

 -- Class (f a) => Class (Subject f a)
let instanceReqFA_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1
        (e.class1 cl (e.br (e.ap2 (e.f "f") (e.n "a"))))
        (instanceFA cl subj)

 -- Class a => Class (Subject a b)
let instanceReqA_B =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl (e.n "a")) (instanceAB_ cl subj)

 -- Class (f a) => Class (Subject f a b)
let instanceReqFAB_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1
        (e.class1 cl (e.br (e.ap2 (e.f "f") (e.n "a"))))
        (instanceFAB cl subj)

 -- Class f => Class Subject
let instanceReqF_ =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req1 (e.class1 cl (e.f "f")) (instance cl subj)

 -- Subject b => Subject (a -> b)
let instanceReqSubjArrow =
    \(subj : Text) ->
    e.req1
        (e.subj1 subj (e.n "b"))
        (e.subj1 subj (e.br (e.fn2 (e.n "a") (e.n "b"))))

 -- (Subject f, Subject g) => Subject (Class f g)
let instanceReqFG =
    \(cl : Text) ->
    \(subj : Text) ->
    e.req
        [ e.subj1 subj (e.f "f")
        , e.subj1 subj (e.f "g")
        ]
        (e.subj1 subj (e.br (e.class cl [ e.f "f", e.f "g" ])))

 -- (Class2 f, Class1 a) => Class1 (Subject f a)
let instanceReqFA2 =
    \(cl1 : Text) ->
    \(cl2 : Text) ->
    \(subj : Text) ->
    e.req
        [ e.class1 cl2 (e.f "f")
        , e.class1 cl1 (e.n "a")
        ]
        (instanceFA cl1 subj)

in
    { instance, instanceCl, instanceSubj, instanceSubj2, instanceSubjA, instanceSubjA2, instanceSubjF, instanceClA, instanceClSubjA, instanceArrow, instanceArrowR, instanceFn, instanceA, instanceF, instanceFA
    , instance_, instanceA_, instanceFA_, instanceAB_, instanceFAB_, instanceReqA_B
    , instanceReqA, instanceReqA2, instanceReqF2, instanceReqF2_, instanceReqASubj, instanceReqF,  instanceReqF_, instanceReqFA, instanceReqFA_, instanceReqFAB_
    , instanceReqSubjArrow, instanceReqFG, instanceReqFA2, instanceReqPSubj
    }