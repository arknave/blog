---
title: Finding Bulbasaur Part I: Welcome to Pallet Town
---

The other day in class, someone asked me to show them something "cool". At the time, Pokemon X and Y had just come out, and I was thinking about the time I had spent on the earlier games as a kid. I thought we'd spend the period finding where Bulbasaur was in Pokemon Red.

![Pokemon Red Box Art](https://upload.wikimedia.org/wikipedia/en/e/e9/Pok%C3%A9mon_box_art_-_Red_Version.jpg)

To get started, I loaded my Pokemon Red ROM into a hex editor and took a peek.

```
.$ .............
..#......%!.....
......G.....D.. 
..@...@x....@...
@..!....". ..>.!
......(w.. .....
.......... .....
... .*...y. ....
................
................
................
................
..P...ff.....s..
..............n.
......gcn.......
..3>POKEMON RED.
....01.....3. ..
..(....>.....T.>
...............
./...7G>........

```
...And on and on and on

I recognized the text "POKEMON RED" in the header, but couldn't make heads or tails of the rest of it. I definitely didn't find Bulbasaur. It was time to bust out some code. I wrote all of the code in Haskell, but the ideas are language-agnostic.

###First Pass

To start, I just opened the file and searched for the string "BULBASAUR" in ASCII in the ROM.

```haskell
import qualified Data.ByteString.Char8 as BS 
import Data.Char

main = do
    game <- BS.readFile "Pokemon Red.gb"
    print $ BS.take 50 . snd $ BS.breakSubstring (BS.pack "BULBASAUR") game
```

Haskell's syntax is a little strange at first, but powerful once you get used to it. The first lines are standard import statements, with syntax similar to Python. The main function is called when the program is run. The do block is shorthand for repeatedly calling the bind (`>>=`) function, something we won't go into in this blog post. Just read it as this:

- Take the contents of the file "Pokemon Red.gb" and read them into `game`.
- Run the function `breakSubstring` on the ByteStrings `BULBASAUR` and the whole game file.
- Print the first 50 characters of the second element of the tuple returned by `breakSubstring`.

The 50 characters is arbitrary. `breakSubstring` returns a tuple with two elements. The first element is a ByteString with all the bytes that precede our query, and the second contains our query and everything after. If our query isn't found, the first element contains all input and the second element is empty. Unfortunately, the first run returned an empty string: `""`. This means that the Pokemon ROM doesn't use standard ASCII encoding.

###A Bulbasaur by Any Other Name...
I'm assuming that whatever encoding that GameFreak uses keeps the letters in alphabetical order. Let's try every possible encoding. 

```haskell
import qualified Data.ByteString.Char8 as BS 
import Data.Char

oneString :: String -> Int -> String
oneString s n = map (\x -> chr $ (ord x) + n) s

allStrings :: String -> [BS.ByteString]
allStrings s = map (BS.pack . oneString s) [-65..165]

main = do
    game <- BS.readFile "Pokemon Red.gb"
    print $ map (\x -> BS.take 50 .  snd $ BS.breakSubstring x game) (allStrings "BULBASAUR")
```

The (`\x -> f x`) is a lambda function. `oneString` takes a string and shifts all characters in the string by a parameter. `allStrings` calls `oneString` with every number from -65 to 165. These numbers were chosen to map A to 0 at the lowest point and Z to 255 at the highest. Running this code gives...

```
["","","", ... 

"\129\148\139\129\128\146\128\148\145P\149\132\141\148\146\128\148\145PP\147\132\141\147\128\130\145\148\132\139\140\136\146\146\136\141\134\141\142\232\134\142\139\131\132\132\141PPP",
    
"", ..., ""]
```

Looks like we found Bulbasaur! Let's figure out what that offset is. With Haskell's `zip` function, we can tie an index to each element of the list, then pare the list down to the non-empty ByteStrings to find our lucky index.

```haskell
import qualified Data.ByteString.Char8 as BS 
import Data.Char

oneString :: String -> Int -> String
oneString s n = map (\x -> chr $ (ord x) + n) s

allStrings :: String -> [BS.ByteString]
allStrings s = map (BS.pack . oneString s) [-65..165]

main = do
    game <- BS.readFile "Pokemon Red.gb"
    print $ filter (\(_, b) -> b /= BS.empty) . zip [0..] $ 
    map (\x -> BS.take 50 .  snd $ BS.breakSubstring x game) (allStrings "BULBASAUR")
```

This returns

```
[(128,"\129\148 ... PPP")]
```

So it looks like `A` is `128`, or `0x80`. Let's translate the bytes into plain english using our new encoding system.

```haskell
import qualified Data.ByteString.Char8 as BS 
import Data.Char

oneString :: String -> Int -> String
oneString s n = map (\x -> chr $ (ord x) + n) s

allStrings :: String -> [BS.ByteString]
allStrings s = map (BS.pack . oneString s) [-65..165]

showByteString :: Char -> Char
showByteString s = chr $ (ord s) - 128 + 65

main = do
    game <- BS.readFile "Pokemon Red.gb"
    print $ BS.map showByteString . BS.take 50 . snd $ 
    BS.breakSubstring (BS.pack $ oneString "BULBASAUR" (128-65)) game
```

Which outputs:

```haskell
"BULBASAUR\DC1VENUSAUR\DC1\DC1TENTACRUELMISSINGNO\169GOLDEEN\DC1\DC1\DC1"
```

We did it! We found Bulbasaur! To get the memory offset, let's modify the main function to output the number of bytes before the string "BULBASAUR".

```haskell
import qualified Data.ByteString.Char8 as BS 
import Data.Char

oneString :: String -> Int -> String
oneString s n = map (\x -> chr $ (ord x) + n) s

allStrings :: String -> [BS.ByteString]
allStrings s = map (BS.pack . oneString s) [-65..165]

showByteString :: Char -> Char
showByteString s = chr $ (ord s) - 63

main = do
    game <- BS.readFile "Pokemon Red.gb"
    print $ BS.length . fst 
    $ BS.breakSubstring (BS.pack $ oneString "BULBASAUR" (128-65)) game
```

Which returns `116750`, or in hex, `0x1C80E`.

However, this results in some new mysteries. Where is Ivysaur, and why is it not between Bulbasaur and Venusaur? Why does Goldeen come after Tentacruel? We'll answer those questions and more next month.

Find the code here at this gist: https://gist.github.com/arknave/8294686
