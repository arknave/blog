{-# LANGUAGE OverloadedStrings #-}
import Clay
import Prelude hiding (div)
import Data.Monoid

import qualified Clay.Media as Media
import qualified Data.Text.Lazy.IO as T

bgColor :: Color
bgColor = white

fgColor :: Color
fgColor = black

mutedColor :: Color
mutedColor = rgb 85 85 85

borderColor :: Color
borderColor = black

headerStylesheet :: Css
headerStylesheet = do
  header ? do 
    borderBottom solid (px 2) black
    marginBottom (em 1)
  "#logo" ? a ? do
    color          fgColor
    float          floatLeft
    fontSize       (em 1)
    fontWeight     bold
    paddingLeft    (em 0.5)
    textDecoration none
    textTransform  uppercase
  nav ? do
    textAlign    (alignSide sideRight)
    paddingRight (em 0.5)
    ul ? do
      listStyle none outside none
      li ? do
        display inline
        a ? do
          color          fgColor
          fontSize       (em 1)
          fontWeight     bold
          marginLeft     (em 0.5)
          textDecoration none
          textTransform  uppercase

footerStylesheet :: Css
footerStylesheet = do
  footer ? do
    borderTop    solid (px 2) black
    color        mutedColor
    fontSize     (em 1)
    marginTop    (em 2)
    sym2 padding (em 1) (em 0)
    textAlign    (alignSide sideCenter)

contentStylesheet :: Css
contentStylesheet = do
  section # "#content" ? do
    sym padding (em 1)
    maxWidth    (em 60)
    sym2 margin      (em 0) auto
  section # ".info" ? do
    color     mutedColor
    fontSize  (em 1)
    fontStyle italic

headingStylesheet :: Css
headingStylesheet = do
  (h1 <> h2 <> h3 <> h4 <> h5 <> h6) ? do
    sym  margin (em 0)
    sym padding (em 0)
  h2 ? do
    fontSize (em 2)

tablet :: Css
tablet = do
  "#content" ? do
    fontSize (em 1.2)
    lineHeight (em 1.5)

  h2 ? fontSize (em 2.5)
  h3 ? fontSize (em 2)

  footer ? textAlign (alignSide sideRight) 

desktop :: Css
desktop = do
  header ? fontSize (em 1.2)
  div # "#logo" ? a ? paddingLeft (em 0)
  nav ? paddingRight (em 0)
  section # "#content" ? do
    fontSize (em 1.3)
    lineHeight (em 1.7)

theStylesheet :: Css
theStylesheet = do
    body ? do 
      backgroundColor bgColor
      color           fgColor
      fontSize        (em 1)
      sym2 margin     (em 0) auto
      maxWidth        (px 768)

    headerStylesheet
    footerStylesheet
    contentStylesheet
    headingStylesheet
    -- media queries
    query Clay.all [Media.minWidth (em 40)] tablet
    query Clay.all [Media.minWidth (em 55)] desktop

main :: IO ()
main = putCss theStylesheet
