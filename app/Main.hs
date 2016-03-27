module Main where

import Control.Monad (join)

import Options.Applicative
import qualified Data.Text as T

import Gitfred.Request
import qualified Alfred as A

data Command
    = Search (Maybe String)
    | Cache
    | Increment String

main :: IO ()
main = run =<< execParser
    (parseCommand `withInfo` "Interact with the GitHub API")

run :: Command -> IO ()
run cmd =
    case cmd of
        Search mquery -> A.searchItems cacheFile mquery
        Cache         -> do
                            repos <- getRepos
                            A.writeItems cacheFile $ fmap A.toAlfredItem repos
        Increment url -> A.incrementVisits cacheFile $ T.pack url

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts desc = info (helper <*> opts) $ progDesc desc

parseCommand :: Parser Command
parseCommand =
    subparser $
        command "search"     (parseSearch `withInfo` "Search for GitHub repos") <>
        command "cache"      (parseCache  `withInfo` "Cache GitHub repos") <>
        command "increment"  (parseIncrement  `withInfo` "Increment a repo's visit count")

parseSearch :: Parser Command
parseSearch = Search <$> optional (argument str (metavar "QUERY"))

parseCache :: Parser Command
parseCache = pure Cache

parseIncrement :: Parser Command
parseIncrement = Increment <$> argument str (metavar "REPO_URL")

cacheFile :: String
cacheFile = "repos.csv"
