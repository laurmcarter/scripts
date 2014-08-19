{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DefaultSignatures #-}

module Shelly.Cmd where

import Prelude hiding (FilePath)

import Shelly
import System.Environment
import System.Exit

import Data.Monoid
import Data.Text (Text)
import qualified Data.Text    as T
import qualified Data.Text.IO as T

type Usage = (Text,Text)

class Shelly t r where
  shellyCmd :: [Usage] -> t -> IO r

instance Shelly (Sh a) a where
  shellyCmd [] m = shellyNoDir m
  shellyCmd _  _ = error "Excessive usage descriptions provided"

instance (CmdLineArg arg, Shelly t r) => Shelly (Maybe arg -> t) r where
  shellyCmd use f = do
    as <- getArgs
    let uRest = case use of
                  []       -> []
                  (_:rest) -> rest
    case as of
      [] -> shellyCmd uRest $ f Nothing
      (a1:aRest) -> withArgs aRest
        $ shellyCmd uRest
        $ f (Just $ fromArg a1)

instance (CmdLineArg arg, Shelly t r) => Shelly (arg -> t) r where
  shellyCmd (use1:uRest) f = do
    as <- getArgs
    case as of
      []         -> missingArgError use1
      (a1:aRest) -> withArgs aRest
        $ shellyCmd uRest 
        $ f (fromArg a1)
    where
    missingArgError (aName,aDesc) = do
      T.putStrLn $ "Missing arg:" <+> aName $$ indent aDesc
      exitFailure
  shellyCmd _ _ = error "Insufficient usage descriptions provided"

-- CmdLineArg class {{{

class CmdLineArg a where
  fromArg :: String -> a
  default fromArg :: Read a => String -> a
  fromArg = read

instance CmdLineArg String where
  fromArg = id

instance CmdLineArg Text where
  fromArg = T.pack

instance CmdLineArg FilePath where
  fromArg = fromText . fromArg

instance CmdLineArg Int where
instance CmdLineArg Float where
instance CmdLineArg Bool where

-- }}}

-- Text Helpers {{{

(<+>) :: Text -> Text -> Text
t1 <+> t2 = t1 <> " " <> t2

infixr 5 <+>

($$) :: Text -> Text -> Text
t1 $$ t2 = t1 <> "\n" <> t2

infixr 4 $$

indent :: Text -> Text
indent = T.unlines . map ("  " <>) . T.lines

-- }}}

