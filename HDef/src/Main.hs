{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}

import Prelude hiding (FilePath)

import Shelly
import Shelly.Cmd
import Data.Text (Text)

main :: IO ()
main = shellyCmd usage prg
  where
  usage =
    [ ( "Directory"   , "directory to recursively search through" )
    , ( "Search Term" , "term to search for" )
    ]
  prg :: FilePath -> Text -> Sh ()
  prg dir arg = do
    run "echo" ["-e","\n\033[0;35mFunctions:"]
    fs <- run "grep" ["-R","--include='*.hs'","-e","::",toTextIgnore dir]
    echo fs

ntDef, tDef, dDef :: Text
ntDef = "newtype.*=.*"
tDef  = "type.*=.*"
dDef  = "data.*=.*"

