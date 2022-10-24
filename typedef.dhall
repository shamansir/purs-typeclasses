
let e = ./expr.dhall

let List/map =
    https://prelude.dhall-lang.org/List/map


let Id =
    < Id : Text
    >


let Parent = { id : Id, name : Text, vars : List e.Arg }


let Dependencies = { from : List e.Arg, to : List e.Arg }


let DataDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , constraint : Optional e.Constraint
    }


let NewtypeDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , constraint : Optional e.Constraint
    }


let ClassDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , parents : List Parent
    , dependencies : Optional Dependencies
    , constraint : Optional e.Constraint
    }


let PackageDef =
    { name : Text
    , id : Id
    }


-- add module, info, package
let Def =
    < Data_ : DataDef
    -- | Type_
    | Newtype_ : NewtypeDef
    | Class_ : ClassDef
    | Package_ : PackageDef
    >


let ctype : e.CItem = e.CItem.CType


let cfn
    : List e.CItem -> e.CItem
    = \(items : List e.CItem) ->
    e.CItem.CFn (e.Expr/sealAll (List/map e.CItem e.Expr e.CItem/toExpr items))


let cfn_br
    : List e.CItem -> e.CItem
    = \(items : List e.CItem) ->
    e.CItem.CBr
        (e.Expr/seal
            (e.CItem/toExpr (cfn items) )
        )


let cctype : e.Constraint = [ ctype ]
let cctype2 : e.Constraint = [ ctype, ctype ]
let cctype3 : e.Constraint = [ ctype, ctype, ctype ]


let ccforall
    : List e.Arg -> e.Constraint -> e.Constraint
    = \(args : List e.Arg) -> \(body : e.Constraint) -> [ e.CItem.CForall { args, body = e.Expr/seal (e.Constraint/toExpr body) } ]


let id = Id.Id


let data
    : Id -> Text -> List e.Arg -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    Def.Data_ { id, name, vars, constraint = None e.Constraint }


let data_c
    : Id -> Text -> List e.Arg -> e.Constraint -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : e.Constraint) ->
    Def.Data_ { id, name, vars, constraint = Some constraint }


let nt
    : Id -> Text -> List e.Arg -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    Def.Newtype_ { id, name, vars, constraint = None e.Constraint }


let nt_c
    : Id -> Text -> List e.Arg -> e.Constraint -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : e.Constraint) ->
    Def.Newtype_ { id, name, vars, constraint = Some constraint }


let pkg
    : Id -> Text -> Def
    = \(id : Id) -> \(name : Text) ->
    Def.Package_ { id, name }


let p
    : Id -> Text -> List e.Arg -> Parent
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    { id, name, vars }


let pe
    : Id -> Text -> Parent
    = \(id : Id) -> \(name : Text) ->
    p id name ([] : List e.Arg)


let v
    : Text -> e.Arg
    = e.Arg.VarArg


let cv
    : Text -> e.CItem
    = \(v_ : Text) -> e.CItem.CVar (v v_)


let ccon
    : e.CItem
    = e.CItem.CConstraint


let class
   : Id -> Text -> Def
    = \(id : Id) -> \(name : Text) ->
    Def.Class_
        { id, name
        , vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_v
   : Id -> Text -> List e.Arg -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
   Def.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_c
   : Id -> Text -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vp
   : Id -> Text -> List e.Arg -> List Parent -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_vc
   : Id -> Text -> List e.Arg -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vpd
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , constraint = None e.Constraint
        }


let class_vpc
   : Id -> Text -> List e.Arg -> List Parent -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->  \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vpdc
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) -> \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , constraint = Some cnst
        }


let dep1
    : e.Arg -> e.Arg -> Dependencies
    = \(from : e.Arg) -> \(to : e.Arg) -> { from = [ from ], to = [ to ]}


let test_c01 = assert : e.Constraint/render cctype ≡ "{{kw:Type}}"
let test_c02 = assert : e.Constraint/render cctype2 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c03 = assert : e.Constraint/render cctype3 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c04 = assert : e.Constraint/render [ ctype, cfn_br [ ctype, ctype ], ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c05 = assert : e.Constraint/render [ ctype, cfn_br cctype2, ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c06 = assert : e.Constraint/render (ccforall [ v "k" ] [ ctype, cfn_br cctype2, cv "k" ]) ≡ "{{kw:forall}} {{var:k}}. {{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{var:k}}"
let test_c07 = assert : e.Constraint/render [ ctype, ctype, ccon ] ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Constraint}}"
let test_c08 = assert : e.Constraint/render [ cfn_br cctype3, ccon ] ≡ "({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"


let Def/renderConstraint = \(td : Def) -> Some "" -- TODO


let Def/renderSpec = \(td : Def) -> "" -- TODO


let Def/renderConstraintRaw = \(td : Def) -> Some "" -- TODO


let Def/renderSpecRaw = \(td : Def) -> "" -- TODO


let Def/render = \(td : Def) -> { constraint = Some "", def = "" } -- TODO


let Def/renderRaw = \(td : Def) -> { constraint = Some "", def = "" } -- TODO


{-
d.class_vpc
    (d.id "biapplicative")
    "Biapplicative"
    [ d.v "w" ]
    [ d.p (d.id "biapply") "Biapply" [ d.v "w" ] ]
    [ d.cfn_br d.cctype3, d.ccon ]

class Biapplicative :: (Type -> Type -> Type) -> Constraint
class (Biapply w) <= Biapplicative w where
-}

{-
d.class_vpc
    (d.id "decidable")
    "Decidable"
    [ d.v "f" ]
    [ d.p (d.id "decide") "Decide" [ d.v "f" ]
    , d.p (d.id "divisible") "Divisible" [ d.v "f" ]
    ]
    [ d.cfn_br d.cctype2, d.ccon ]

class Decidable :: (Type -> Type) -> Constraint
class (Decide f, Divisible f) <= Decidable f where
-}

{-
d.class_vc
    (d.id "bifunctor")
    "Bifunctor"
    [ d.v "w" ]
    [ d.cfn_br d.cctype3, d.ccon ]

class Bifunctor :: (Type -> Type -> Type) -> Constraint
class Bifunctor f where
-}

{-
d.class_v (d.id "lazy") "Lazy" [ d.v "l" ]

class Lazy l where
-}

{-
d.nt_c
    (d.id "alternate")
    "Alternate"
    [ d.v "f", d.v "a" ]
    (d.ccforall [ d.v "k" ] [ d.cfn_br [ d.cv "k", d.ctype ], d.cv "k", d.ctype ])

newtype Alternate :: forall k. (k -> Type) -> k -> Type
newtype Alternate f a
-}

{-
d.nt_c
    (d.id "const")
    "Const"
    [ d.v "a", d.v "b" ]
    (d.ccforall [ d.v "k" ] [ d.ctype, d.cv "k", d.ctype ])

newtype Const :: forall k. Type -> k -> Type
newtype Const a b
-}

{-
d.nt (d.id "op") "Op" [ d.v "a", d.v "b" ]

newtype Op a b
-}

{-
d.data (d.id "effect") "Effect" [ d.v "t0" ]

data Effect t0
-}

{-
d.class_vpdc
    (d.id "foldablewithindex")
    "FoldableWithIndex"
    [ d.v "i", d.v "f" ]
    [ d.p (d.id "foldable") "Foldable" [ d.v "f" ] ]
    (d.dep1 (d.v "f") (d.v "i"))
    d.tt2c

class FoldableWithIndex :: Type -> (Type -> Type) -> Constraint
class (Foldable f) <= FoldableWithIndex i f | f -> i where
-}

{-
d.class_vpdc
    (d.id "traversablewithindex")
    "TraversableWithIndex"
    [ d.v "i", d.v "t" ]
    [ d.p (d.id "functorwithindex") "FunctorWithIndex" [ d.v "i", d.v "t" ]
    , d.p (d.id "foldablewithindex") "FoldableWithIndex" [ d.v "i", d.v "t" ]
    , d.p (d.id "traversable") "Traversable" [ d.v "t" ]
    ]
    (d.dep1 (d.v "t") (d.v "i"))
    d.tt2c

class TraversableWithIndex :: Type -> (Type -> Type) -> Constraint
class (FunctorWithIndex i t, FoldableWithIndex i t, Traversable t) <= TraversableWithIndex i t | t -> i where
-}

-- (Type -> Type) -> Type -> Type -> Type
let t2t3 : e.Constraint = [ cfn_br cctype2, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> (Type -> Type -> Type) -> Type -> Type -> Type
let t3t3t3 : e.Constraint = [ cfn_br cctype2, cfn_br cctype3, ctype, ctype, ctype ]

-- (Type -> Type) -> Constraint
let t2c : e.Constraint = [ cfn_br cctype2, ccon ]

-- (Type -> Type -> Type) -> Constraint
let t3c : e.Constraint = [ cfn_br cctype3, ccon ]

-- Type -> (Type -> Type) -> Constraint
let tt2c : e.Constraint = [ ctype, cfn_br cctype2, ccon ]

-- forall k. Type -> k -> Type
let tkt : e.Constraint = ccforall [ v "k" ] [ ctype, cv "k", ctype ]

-- forall k. (k -> Type) -> k -> Type
let kt_kt : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> k -> Type
let kt_kt_kt : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k1 k2. (k2 -> Type) -> (k1 -> k2) -> k1 -> Type
let k12kt : e.Constraint = ccforall [ v "k1", v "k2" ] [ cfn_br [ cv "k2", ctype ], cfn_br [ cv "k1", cv "k2" ], cv "k1", ctype ]

-- forall k1 k2. (k1 -> k2 -> Type) -> k2 -> k1 -> Type
let kkt_kkt : e.Constraint = ccforall [ v "k1", v "k2" ] [ cfn_br [ cv "k1", cv "k2", ctype ], cv "k2", cv "k1", ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> Constraint
let kt_kt_c : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], ccon ]

in
    { id
    , Def
    , ctype, cfn_br
    , cctype, cctype2, cctype3, ccon, ccforall
    , p, pe, v, cv
    , dep1
    , data, data_c, nt, nt_c, pkg, class, class_v, class_c, class_vp, class_vc, class_vpd, class_vpc, class_vpdc
    , t2c, t3c, t3t3t3, tkt, kt_kt, kt_kt_kt, tt2c, t2t3, k12kt, kkt_kkt, kt_kt_c
    }