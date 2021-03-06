module Main where

import Control.Monad

import System.Directory

import System.INotify as INotify

import Utils

file = "hello"

write path = do
    writeFile (path ++ '/':file) ""

remove path = do
    removeFile (path ++ '/':file)

action path = do
    write path
    remove path
    
main =
    inTestEnviron [AllEvents] action $ \ events -> do
        when (expected ~= events)
            testSuccess
        explainFailure expected events

expected =
    [ Created   False file
    , Opened    False (Just file)
    , Modified  False (Just file)
    , Closed    False (Just file) True
    , Deleted   False file
    ]
