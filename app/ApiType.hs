{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}

module ApiType where

import Data.Aeson ( FromJSON )
import Data.Proxy ( Proxy(..) )
import GHC.Generics ( Generic )
import Servant.API ( type (:>), QueryParam', Required, Post, JSON )
import Servant.Client ( client )

type RequiredParam a b = QueryParam' '[Required] a b
type API =
  "authenticate"
    :> RequiredParam "client" ClientID
    :> RequiredParam "secret" Secret
    :> RequiredParam "callback_url" Url
    :> Post '[JSON] Auth

newtype Auth = Auth {login_url :: String}
  deriving (Show, Generic, FromJSON)

api :: Proxy API
api = Proxy

authenticate = client api

type ClientID = String

type WalletID = String

type Secret = String

type Url = String
