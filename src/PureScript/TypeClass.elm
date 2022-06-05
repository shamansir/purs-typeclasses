module PureScript.TypeClass exposing (..)


type alias Id = String


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
    }


type alias What = String


type alias Package = String


type alias Instance = String


type alias Module = String


type alias Def = String


type alias Value = String


type alias Op = String


type alias Link = String


type alias Parent = String


type alias Var = String


type alias TypeClass =
    { id : Id
    , name : String
    , info : String
    , what : What
    , vars : List Var
    , link : Link
    , parents : List Parent
    , package : Package
    , module_ : List Module
    , instances : List Instance
    , statements : List Statement
    , members : List Member
    , values : List Value
    , laws : List Law
    }
