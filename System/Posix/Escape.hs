-- | Quote ASCII arguments to be passed through the Unix shell.
--
-- For safety, these functions drop all non-ASCII characters.
module System.Posix.Escape
    ( escape
    , escapeMany
    ) where

import qualified System.Posix.Escape.Unicode as U

import Data.Char

-- | Wrap a @String@ so it can be used within a Unix shell command line, and
-- end up as a single argument to the program invoked.
escape :: String -> String
escape = U.escape . filter isAscii

-- | Wrap some @String@s as separate arguments, by inserting spaces before and
-- after each.  This will break if, for example, prefixed with a backslash.
escapeMany :: [String] -> String
escapeMany = U.escapeMany . map (filter isAscii)
