{-# LANGUAGE TupleSections, OverloadedStrings, DeriveGeneric #-}
module Handler.User where

import GHC.Generics
import Import
import Network.HTTP.Types (status201, status204, status200)
import Data.Maybe
import Data.Aeson
import Yesod.Auth

{- This module contains the User resource -}

data MilkUser = MilkUser { name :: String } deriving Generic

instance ToJSON MilkUser

getUserR :: Handler RepJson
getUserR  = do
  muser <- maybeAuth
  case muser of
    Nothing -> jsonToRepJson $ MilkUser ""
    _ -> jsonToRepJson $ MilkUser (getUserId muser)

--getUserId :: Maybe (Entity t) -> String
getUserId userEntity = case userEntity of
  Just (Entity k s ) -> show $ userIdent s
