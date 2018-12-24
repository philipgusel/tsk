module Main where

import System.Environment
import System.Process
import System.Directory
import Control.DeepSeq
import Control.Exception

-- config/task file
cfgfile = ".tsk"

main = do 
        dir <- getHomeDirectory
        -- get userspecific path
        let path = dir ++ "/" ++ cfgfile
        -- make sure the file exists
        system $ "touch " ++ path
        arg <- getArgs
        perform arg path
        
-- convert string to Int
readint :: String -> Int
readint = read

-- drop one specific item off a list
dropitem _ [] = []
dropitem i (l:ls) 
        | i == l = dropitem i ls
        | otherwise = l:dropitem i ls

-- print a file with line numbers
putFile [] _ = return ()
putFile (l:ls) c = do 
        putStrLn ((show c) ++ " " ++ l)
        putFile ls (c+1)

-- print notes if no argument is provided
perform [] f = do
        file <- readFile f
        -- force eval the file (lazy IO)
        evaluate (force file)
        putFile (lines file) 1
-- add i as note
perform ("add":i:as) f = do
        file <- readFile f
        -- force eval the file (lazy IO)
        evaluate (force file)
        let nfile = file ++ i ++ "\n"
        putFile (lines nfile) 1
        writeFile f nfile
-- remove ith note
perform ("done":i:as) f = do
        file <- readFile f
        -- force eval the file (lazy IO)
        evaluate (force file)
        let nfile = unlines $ dropitem ((lines file) !! ((readint i)-1)) (lines file)
        putFile (lines nfile) 1
        writeFile f nfile
-- reset the file
perform ("reset":ls) f = do
        system $ "rm " ++ f
        system $ "touch " ++ f
        return ()
-- error message
perform _ _ = do putStr "?\n"
