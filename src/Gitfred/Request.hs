module Gitfred.Request
    ( getRepos
    ) where

import System.Environment (getEnv)
import Control.Exception (throwIO)

import qualified Data.ByteString.Char8 as BS
import qualified Data.Vector as V
import qualified GitHub.Endpoints.Repos as GH
import qualified Alfred as A
import qualified Data.Text as T
import LoadEnv (loadEnv)

getRepos :: IO [GH.Repo]
getRepos = do
    loadEnv
    oauthToken <- getEnv "GITHUB_OAUTH_TOKEN"
    let oauth = GH.OAuth $ BS.pack oauthToken
    erepos <- GH.currentUserRepos oauth GH.RepoPublicityAll
    case erepos of
        Left e -> throwIO $ userError $ show e
        Right repos -> return $ V.toList repos

instance A.ToAlfredItem GH.Repo where
    toAlfredItem repo = A.Item ownerAndName url visits
        where
            ownerAndName = T.concat [owner, "/", name]
            owner = GH.untagName $ GH.simpleOwnerLogin $ GH.repoOwner repo
            name = GH.untagName $ GH.repoName repo
            url = GH.repoHtmlUrl repo
            visits = 0
