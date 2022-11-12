module PureScript.TypeClass exposing (..)


type Id = Id String


idToString : Id -> String
idToString (Id id) = id


type LawExample
    = LR  { left : String, right : String }
    | LMR { left : String, middle : String, right : String }
    | LRC { left : String, right : String, conditions : List String }
    | FC  { fact : String, conclusion : String }
    | OF  { fact : String }


type alias Statement =
    { left : String
    , right : String
    }


type alias Law =
    { law : String
    , examples : List LawExample
    }


type alias Member =
    { name : String
    , def : Def
    , op : Maybe Op
    , opEmoji : Maybe Op
    , laws : List Law
    , examples : List Example
    }


type alias What = String


type alias Package = { name : String, version : List Int }


type alias ParentRef = { name : String, id : Id }


type alias VarWithKind = { kind : String, name : String }


type alias Connection = { parent : ParentRef, vars : List VarWithKind }


type alias Instance = String


type alias Module = String


type alias Def = String


type alias Value = String


type alias Op = String


type alias Link = String


type alias Parent = Id


type alias Var = String


type alias Example = String


type alias TypeClass =
    { id : Id
    , name : String
    , info : String
    , what : What
    , vars : List Var
    , link : Link
    , weight : Float
    , connections : List Connection
    , parents : List Parent
    , package : Package
    , module_ : List Module
    , instances : List Instance
    , statements : List Statement
    , members : List Member
    , values : List Value
    , laws : List Law
    }
