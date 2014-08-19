
import Control.Monad (void)
import Data.Set (Set)
import qualified Data.Set as S
import Data.Map (Map)
import qualified Data.Map as M
import Data.Monoid
import System.Environment (getArgs)
import System.Process (readProcessWithExitCode)
import System.Exit

-- {{{

main :: IO ()
main = undefined

parseArgs :: ParseArgs a
parseArgs 

type ParseArgs r = [Char] -> [(String,Maybe String)] -> Either Failure r
type Failure = String

runWithArgs :: Parse r -> (r -> IO a) -> IO ()
runWithArgs prs f = do
  as <- getArgs
  case prs as of
    Left err  -> do
      putStrLn $ "Failure: " ++ err
      exitFailure
    Right res -> void $ f res

-- }}}

data FlagName
  = Short Char
  | Long String
  deriving (Eq,Ord,Show)

data FlagInfo = FlagInfo
  { fArity  :: FlagArity
  , fRepeat :: FlagRepeat
  } deriving (Eq,Ord,Show)

data FlagArity
  = NoArg
  | OptArg
  | ReqArg
  deriving (Eq,Ord,Show)

data FlagRepeat
  = NoRepeat
  | Repeat
  deriving (Eq,Ord,Show)

-- Independent flags
type Flags r = Map FlagName (FlagInfo,Endo r)

type Modes r = Map String 

parseFlags :: Flags r -> [String] -> r -> r
parseFlags m as = appEndo builder
  where
  builder = undefined

