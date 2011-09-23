{-# LANGUAGE
    CPP #-}

module Main(main) where

import Test.QuickCheck
import Test.QuickCheck.Monadic
import System.Process
import System.IO
import Control.Exception ( evaluate )

#ifdef UNICODE
import System.Posix.Escape.Unicode
#else
import System.Posix.Escape
#endif

echo :: String -> IO String
echo xs = do
    (_, Just hOut, _, hProc) <- createProcess $
        (shell ("/bin/echo -n " ++ xs)) { std_out = CreatePipe }
    out <- hGetContents hOut
    _ <- evaluate (length out)
    hClose hOut
    _ <- waitForProcess hProc
    return out

mangled :: String -> String
#ifdef UNICODE
mangled = id
#else
mangled = filter ((< 0x80) . fromEnum)
#endif

prop_escaped :: String -> PropertyM IO ()
prop_escaped xs = do
    pre (all (/= '\0') xs)
    ys <- run $ echo (escape xs)
    assert (mangled xs == ys)

main :: IO ()
main = quickCheck (monadicIO . prop_escaped)
