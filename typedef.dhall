
let e = ./expr.dhall

let List/map =
    https://prelude.dhall-lang.org/List/map


let Id =
    < Id : Text
    >


-- let IConstraint = e.Expr
let Constraint = List e.CItem


let DataDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , constraint : Optional Constraint
    }


let NewtypeDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , constraint : Optional Constraint
    }


let ClassDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , parents : List { id : Id, name : Text, vars : List e.Arg }
    , dependencies : { from : List e.Arg, to : List e.Arg }
    , constraint : Optional Constraint
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


let Constraint/render :
    Constraint -> Text =
    \(c : Constraint) ->
    ""

let ctype : e.CItem = e.CItem.CType


let cfn
    : List e.CItem -> e.CItem
    = \(items : List e.CItem) -> e.CItem.CFn (e.Expr/sealAll (List/map e.CItem e.Expr e.CItem/toExpr items))


let cctype : Constraint = [ ctype ]
let cctype2 : Constraint = [ ctype, ctype ]
let cctype3 : Constraint = [ ctype, ctype, ctype ]


let id = Id.Id


let data
    : Id -> Text -> List e.Arg -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    TypeDef.Data_ { id, name, vars, constraint = None Constraint }


let data_c
    : Id -> Text -> List e.Arg -> Constraint -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : Constraint) ->
    TypeDef.Data_ { id, name, vars, constraint = Some constraint }


let nt
    : Id -> Text -> List e.Arg -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    TypeDef.Newtype_ { id, name, vars, constraint = None Constraint }


let nt_c
    : Id -> Text -> List e.Arg -> Constraint -> TypeDef
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : Constraint) ->
    TypeDef.Newtype_ { id, name, vars, constraint = Some constraint }


{-
let test_c01 = assert : Constraint/render cctype ≡ "{{kw:Type}}"
let test_c02 = assert : Constraint/render cctype2 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c03 = assert : Constraint/render cctype3 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c04 = assert : Constraint/render [ ctype, cfn [ ctype, ctype ], ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c05 = assert : Constraint/render [ ctype, cfn cctype2, ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c06 = assert : Constraint/render ccforall [ e.av "k" ] [ ctype, cfn cctype2, cvar "k" ] ≡ "{{kw:forall}} {{var:k}}. {{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{var:k}}"
let test_c07 = assert : Constraint/render [ ctype, ctype, ccon ] ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Constraint}}"
let test_c08 = assert : Constraint/render [ cfn cctype3, ccon ] ≡ "({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"
-}


in
    { id
    , TypeDef, Constraint
    , Constraint/render
    , ctype, cfn
    , cctype, cctype2, cctype3
    , data, data_c
    }