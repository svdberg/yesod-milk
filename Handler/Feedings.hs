module Handler.Feedings where

import Import
import Network.HTTP.Types (status201, status204, status200)
import Data.Maybe
import Yesod.Auth

{- This module contains the Feeding resource -}

getFeedingR :: FeedingId -> Handler RepJson
getFeedingR fid = runDB (get404 fid) >>= jsonToRepJson . Entity fid

deleteFeedingR :: FeedingId -> Handler ()
deleteFeedingR fid = do --incomming Id is Base64, mongo expects Base16
                  runDB $ delete fid
                  sendResponseStatus status200 ()

putFeedingR :: FeedingId -> Handler ()
putFeedingR fid =  do --incomming Id is Base64, mongo expects Base16
           feeding <- parseJsonBody_
           runDB $ replace fid feeding
           sendResponseStatus status200 ()

postFeedingsR :: Handler RepJson
postFeedingsR  = do
      muser <- maybeAuth
      parsedFeeding <- parseJsonBody_ --get content as JSON
      fid <- runDB $ insert parsedFeeding --store in mongo
      let userId = getUserId muser
      runDB $ update fid [ FeedingUserId =. userId ] --link the feeding to the user
      sendResponseCreated $ FeedingR fid --return the id

getUserId :: Maybe (Entity t) -> Key (PersistEntityBackend t) t
getUserId userEntity = case userEntity of
  Just (Entity k s ) -> k

getFeedingsR :: Handler RepJson
getFeedingsR = do
  muser <- maybeAuth
  runDB (selectList [FeedingUserId ==. (getUserId muser)] [Desc FeedingDate, Desc FeedingTime]) >>= jsonToRepJson . asFeedingEntities
    where
      asFeedingEntities :: [Entity Feeding] -> [Entity Feeding]
      asFeedingEntities = id
