
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


let TypeDef =
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
    : Id -> Text -> List e.Arg -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    TypeDef.Data_ { id, name, vars, constraint = None e.Constraint }


let data_c
    : Id -> Text -> List e.Arg -> e.Constraint -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : e.Constraint) ->
    TypeDef.Data_ { id, name, vars, constraint = Some constraint }


let nt
    : Id -> Text -> List e.Arg -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    TypeDef.Newtype_ { id, name, vars, constraint = None e.Constraint }


let nt_c
    : Id -> Text -> List e.Arg -> e.Constraint -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : e.Constraint) ->
    TypeDef.Newtype_ { id, name, vars, constraint = Some constraint }


let pkg
    : Id -> Text -> TypeDef
    = \(id : Id) -> \(name : Text) ->
    TypeDef.Package_ { id, name }


let p
    : Id -> Text -> List e.Arg -> Parent
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    { id, name, vars }


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
   : Id -> Text -> TypeDef
    = \(id : Id) -> \(name : Text) ->
    TypeDef.Class_
        { id, name
        , vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_v
   : Id -> Text -> List e.Arg -> TypeDef
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
   TypeDef.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_c
   : Id -> Text -> e.Constraint -> TypeDef
   = \(id : Id) -> \(name : Text) -> \(cnst : e.Constraint) ->
   TypeDef.Class_
        { id, name, vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vp
   : Id -> Text -> List e.Arg -> List Parent -> TypeDef
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->
   TypeDef.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_vc
   : Id -> Text -> List e.Arg -> e.Constraint -> TypeDef
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(cnst : e.Constraint) ->
   TypeDef.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vpd
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> TypeDef
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) ->
   TypeDef.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , constraint = None e.Constraint
        }


let class_vpc
   : Id -> Text -> List e.Arg -> List Parent -> e.Constraint -> TypeDef
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->  \(cnst : e.Constraint) ->
   TypeDef.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vpdc
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> e.Constraint -> TypeDef
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) -> \(cnst : e.Constraint) ->
   TypeDef.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , constraint = Some cnst
        }


let test_c01 = assert : e.Constraint/render cctype ≡ "{{kw:Type}}"
let test_c02 = assert : e.Constraint/render cctype2 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c03 = assert : e.Constraint/render cctype3 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c04 = assert : e.Constraint/render [ ctype, cfn_br [ ctype, ctype ], ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c05 = assert : e.Constraint/render [ ctype, cfn_br cctype2, ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c06 = assert : e.Constraint/render (ccforall [ v "k" ] [ ctype, cfn_br cctype2, cv "k" ]) ≡ "{{kw:forall}} {{var:k}}. {{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{var:k}}"
let test_c07 = assert : e.Constraint/render [ ctype, ctype, ccon ] ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Constraint}}"
let test_c08 = assert : e.Constraint/render [ cfn_br cctype3, ccon ] ≡ "({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"


in
    { id
    , TypeDef
    , ctype, cfn_br
    , cctype, cctype2, cctype3, ccon
    , p, v, cv
    , data, data_c, nt, nt_c, pkg, class, class_v, class_c, class_vp, class_vc, class_vpd, class_vpc, class_vpdc
    }