module Main where

import Control.Applicative hiding ((<|>))
import Control.Monad
import Data.List
import System.Exit
import System.IO
import System.Random
import Text.ParserCombinators.Parsec

data Term = Roll Int Int | Static Int deriving Show

main = forever $ do
    input <- prompt
    case (parse expression "error" input) of
        Left _ -> print "Error"
        Right ts -> mapM evaluateTerm ts >>= printResults

prompt :: IO String
prompt = do
    putStr "roll> "
    hFlush stdout
    eof <- isEOF
    if eof
        then putStrLn "" >> exitWith ExitSuccess
        else getLine

evaluateTerm :: Term -> IO [Int]
evaluateTerm (Roll c m) = getRandom c m
evaluateTerm (Static s) = return [s]

printResults :: [[Int]] -> IO ()
printResults rss = do
    putStr $ intercalate " + " $ map show rs
    putStr " = "
    print . sum $ rs
        where rs = concat rss

getRandom :: Int -> Int -> IO [Int]
getRandom count magnitude = do
    g <- newStdGen
    return $ take count $ randomRs (1, magnitude) g

expression :: Parser [Term]
expression = sepBy term addition

addition :: Parser (String -> String -> String)
addition = (++) <$ spaces <* char '+' <* spaces

term :: Parser Term
term = try roll <|> static

roll :: Parser Term
roll = Roll <$> integer <* char 'd' <*> integer

static :: Parser Term
static = Static <$> integer

integer :: Parser Int
integer = fmap read $ many1 digit
