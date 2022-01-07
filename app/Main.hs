{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Api (run)
import Numeric (showFFloat)
import Options.Applicative

data Opts = Opts
  { raw :: !Bool,
    optVal :: !String,
    optCmd :: !Command
  }

type Wallet = String

type Thing = String

type Cost = Float

data Command = List Wallet | Add Thing Cost

main :: IO ()
main = do
  (opts :: Opts) <- execParser optsParser
  runCommand $ optCmd opts
  where
    optsParser :: ParserInfo Opts
    optsParser =
      info
        (helper <*> versionOption <*> programOptions)
        ( fullDesc -- <> progDesc "moneylover-cli"
            <> header "moneylover-cli - a moneylover CLI interface"
        )

runCommand :: Command -> IO ()
runCommand (List wallet) = putStrLn $ "*Listing events from wallet " ++ wallet ++ "*"
runCommand (Add thing cost) = putStrLn $ "Adding " ++ thing ++ " for " ++ showFFloat (Just 2) cost "kr"

versionOption :: Parser (a -> a)
versionOption = infoOption "0.0" (long "version" <> help "Show version")

programOptions :: Parser Opts
programOptions =
  Opts
    <$> switch
      ( short 'r'
          <> long "raw"
          <> help "Print raw API response to stdout"
      )
    <*> strOption
      ( long "wallet"
          <> metavar "ID"
          <> value "default"
          <> help "Override default wallet"
      )
    <*> hsubparser (listCmd <> addCmd)

listCmd :: Mod CommandFields Command
listCmd = command "list" (info listOptions (progDesc "Create a thing"))

listOptions :: Parser Command
listOptions =
  List
    <$> strArgument (metavar "WALLET" <> help "Name of the wallet to list events from")

addCmd :: Mod CommandFields Command
addCmd = command "add" (info listOptions (progDesc "Add an expense"))

addOptions :: Parser Command
addOptions = Add <$> strArgument (metavar "THING" <> help "What did you spend money on?")
  <*>  (metavar "COST" <> help "How much did it cost?")
