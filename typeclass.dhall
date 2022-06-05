let List/map =
      https://prelude.dhall-lang.org/List/map

-- let List/length =
--       https://prelude.dhall-lang.org/List/length


{- Types -}

let Id = Text

let LawExample =
    < LR : { left : Text, right : Text }
    | LMR : { left : Text, middle : Text, right : Text }
    | LRC : { left : Text, right : Text, conditions : List Text }
    | FC : { fact : Text, conclusion : Text }
    | OF : { fact : Text }
    >

let Statement =
    { left : Text, right : Text }

let Law =
    { law : Id
    , examples : List { type : Text, v : LawExample }
    }

let Belongs =
    < Yes
    | No
    | Constructor
    >

let Member =
    { name : Text
    , def : Text
    , op : Optional Text
    , opEmoji : Optional Text
    , laws : List Law
    , belongs : Belongs
    }

let What =
    < Class_
    | Newtype_
    | Type_
    | Internal_
    | Data_
    >

let Value = Text

let Var = Text

let Package = Text

let Module = List Text

let TClass =
    { id : Id
    , what : What
    , vars : List Var
    , link : Text
    , name : Text
    , info  : Text
    , parents : List Id
    , package : Package
    , module : Module
    , laws : List Law
    , members : List Member
    , instances : List Text
    , values : List Value
    , statements : List Statement
    }

let noOp : Optional Text = None Text

let noParents = { parents = [] : List Id }

let noInstances = { instances = [] : List Id }

let noOps = { op = noOp, opEmoji = noOp }

let noLaws = { laws = [] : List Law }

let noMembers = { members = [] : List Member }

let noValues = { values = [] : List Value }

let noVars = { vars = [] : List Var }

let noStatements = { statements = [] : List Statement }

let lr =
    \(v : { left : Text, right : Text })
    -> { type = "lr", v = LawExample.LR v }

let lmr =
    \(v : { left : Text, middle : Text, right : Text })
    -> { type = "lmr", v = LawExample.LMR v }

let lrc =
    \(v : { left : Text, right : Text, conditions : List Text })
    -> { type = "lrc", v = LawExample.LRC v }

let fc =
    \(v : { fact : Text, conclusion : Text })
    -> { type = "fc", v = LawExample.FC v }

let of =
    \(v : { fact : Text })
    -> { type = "of", v = LawExample.OF v }

let one
    : forall (t : Type) -> forall (a : t) -> List t
    = \(t : Type) -> \(a : t) -> [ a ]

let oneEx
    : LawExample -> List LawExample
    = one LawExample


in
    { TClass
    , Id, Value
    , Law, LawExample, Member, What, Belongs
    , one, oneEx
    , noOp, noOps, noLaws, noParents, noMembers, noInstances, noValues, noStatements, noVars
    , lr, lmr, lrc, fc, of
    }