module Main where

import Control.Applicative
import Control.Monad
import Data.List
import System.IO
import System.Random
import Text.ParserCombinators.Parsec

data Roll = Roll Int Int deriving Show

main = forever $ do
    putStr "roll> "
    hFlush stdout
    input <- getLine
    case (parse roll "error" input) of
        Left _ -> print "Error"
        Right x -> rollDie x

rollDie :: Roll -> IO ()
rollDie r = do
    rs <- getRandom newStdGen r
    putStr $ intercalate " + " (map show rs)
    putStr " = "
    print $ sum rs

getRandom :: IO StdGen -> Roll -> IO [Int]
getRandom iogen (Roll c s) = do
    gen <- iogen
    return $ take c $ randomRs (1, s) gen

roll :: Parser Roll
roll = Roll <$> integer <* char 'd' <*> integer

integer :: Parser Int
integer = fmap read $ many1 digit
