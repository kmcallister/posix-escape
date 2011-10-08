{- | Quote Unicode arguments to be passed through the Unix shell.

If you are escaping ASCII-only strings, use @System.Posix.Escape@ as a safer
alternative.

If you are escaping untrusted input, you must guarantee that the Unicode
characters of the escaped @String@ will be serialized using the character
encoding expected by @\/bin\/sh@.

Some software incorrectly interprets characters as bytes, and will use only the
low 8 bits of each Unicode code point.  This includes version 1.0 of the
Haskell @process@ package, which is bundled with GHC 7.0.  Under such
circumstances this module /will not/ prevent malicious input from escaping the
quotation.

This bug was fixed in @process-1.1@, which ships with GHC 7.2:

* <http://hackage.haskell.org/trac/ghc/ticket/4006>

* <http://hackage.haskell.org/trac/ghc/ticket/1414>

To repeat: Escaping untrusted input using this module and passing it to the
@process@ package in GHC 7.0 is NOT SAFE and can allow MALICIOUS CODE
EXECUTION.  Use @System.Posix.Escape@ as a safer alternative.

-}

module System.Posix.Escape.Unicode
    ( escape
    , escapeMany
    ) where

-- | Wrap a @String@ so it can be used within a Unix shell command line, and
-- end up as a single argument to the program invoked.
escape :: String -> String
escape xs = "'" ++ concatMap f xs ++ "'" where
    f '\0' = ""
    f '\'' = "'\"'\"'"
    f x    = [x]

-- | Wrap some @String@s as separate arguments, by inserting spaces before and
-- after each.  This will break if, for example, prefixed with a backslash.
escapeMany :: [String] -> String
escapeMany xs = " " ++ unwords (map escape xs) ++ " "
