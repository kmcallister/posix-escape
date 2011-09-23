module System.Posix.Escape.Unicode
    ( escape
    , escapeMany
    ) where

escape :: String -> String
escape xs = "'" ++ concatMap f xs ++ "'" where
    f '\0' = ""
    f '\'' = "'\"'\"'"
    f x    = [x]

escapeMany :: [String] -> String
escapeMany xs = " " ++ unwords (map escape xs) ++ " "
