module Handler.Feedings where

import Import
import Network.HTTP.Types (status201, status204, status200)
import Data.Maybe
import Yesod.Auth

{- This module contains the Feeding resource -}

getFeedingsR :: FeedingId -> Handler RepJson
getFeedingsR fid = runDB (get404 fid) >>= jsonToRepJson . Entity fid

deleteFeedingsR :: FeedingId -> Handler ()
deleteFeedingsR fid = do --incomming Id is Base64, mongo expects Base16
                  runDB $ delete fid
                  sendResponseStatus status200 ()

putFeedingsR :: FeedingId -> Handler ()
putFeedingsR fid =  do --incomming Id is Base64, mongo expects Base16
           feeding <- parseJsonBody_
           runDB $ replace fid feeding
           sendResponseStatus status200 ()

postFeedingsR :: FeedingId -> Handler RepJson
postFeedingsR feedingId = do
      muser <- maybeAuth
      parsedFeeding <- parseJsonBody_ --get content as JSON
      fid <- runDB $ insert parsedFeeding --store in mongo
      let userId = getUserId muser
      runDB $ update fid [ FeedingUserId =. userId ] --link the feeding to the user
      sendResponseCreated $ FeedingsR fid --return the id

getUserId :: Maybe (Entity t) -> Key (PersistEntityBackend t) t
getUserId userEntity = case userEntity of
  Just (Entity k s ) -> k


getFeedingR :: Handler RepJson
getFeedingR = do
  muser <- maybeAuth
  runDB (selectList [FeedingUserId ==. (getUserId muser)] [Desc FeedingDate, Desc FeedingTime]) >>= jsonToRepJson . asFeedingEntities
    where
      asFeedingEntities :: [Entity Feeding] -> [Entity Feeding]
      asFeedingEntities = id
