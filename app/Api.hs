module Api where

import ApiType
import Network.HTTP.Client (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings, newTlsManager)
import Servant.Client

endpoint :: String
endpoint = "oapi.moneylover.me"

getAuthUrl :: ClientM Auth
getAuthUrl = do
  let client = "myClient"
  let secret = "mySecret"
  let callback_url = "localhost"
  authenticate client secret callback_url

run :: IO ()
run = do
  manager' <- newTlsManager
  res <- runClientM getAuthUrl (mkClientEnv manager' (BaseUrl Https endpoint 443 "/public"))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right (Auth url) -> putStrLn url
