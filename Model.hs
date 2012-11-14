{-# LANGUAGE FlexibleInstances #-}
module Model where

import Prelude
import Yesod
import Data.Text (Text)
import Database.Persist.Quasi
import Database.Persist.MongoDB hiding (master)
import Language.Haskell.TH.Syntax
import Data.Time
import Data.Aeson hiding (object)
import Control.Applicative ((<$>), (<*>))
import System.Locale

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist MkPersistSettings { mpsBackend = ConT ''Action }, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")


instance ToJSON (Entity Feeding) where
    toJSON (Entity fid (Feeding date side time excrements remarks userid)) = object
        [ "_id" .= toPathPiece fid
        , "date" .= date
        , "side" .= side
        , "time" .= time
        , "excrements" .= excrements
        , "remarks" .= remarks
        , "userid" .= userid --should be overriden by Auth, set server side
        ]

instance FromJSON Feeding where
    parseJSON (Object o) = Feeding
        <$> (dateFromString <$> o .: "date")
        <*> o .: "side"
        <*> (timeFromString  <$> (o .: "time"))
        <*> o .: "excrements"
        <*> o .: "remarks"
        <*> o .: "userid"
    parseJSON _ = fail "Invalid feeding"


dateFromString :: String -> UTCTime
dateFromString s = readTime defaultTimeLocale "%Y-%m-%d" s :: UTCTime

--parse time in the form of xx:xx to a UTCTime
timeFromString :: String -> UTCTime
timeFromString s = readTime defaultTimeLocale "%H:%M" s :: UTCTime
