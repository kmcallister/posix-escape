module System.Posix.Escape
    ( escape
    , escapeMany
    ) where

import qualified System.Posix.Escape.Unicode as U

import Data.Char

escape :: String -> String
escape = U.escape . filter isAscii

escapeMany :: [String] -> String
escapeMany = U.escapeMany . map (filter isAscii)
