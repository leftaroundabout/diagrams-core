{-# LANGUAGE TypeFamilies
           , DeriveFunctor
  #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.Rendering.Diagrams.Points
-- Copyright   :  (c) Brent Yorgey 2010
-- License     :  BSD-style (see LICENSE)
-- Maintainer  :  byorgey@cis.upenn.edu
-- Stability   :  experimental
-- Portability :  portable
--
-- An embedded domain-specific language for describing and rendering
-- diagrams.  This module defines a type of points (as distinct from
-- vectors).
--
-- Note that end users should rarely (if ever) need to import this
-- module directly; instead, import "Graphics.Rendering.Diagrams",
-- which re-exports most of the functionality from this module.
-- Library developers may occasionally wish to import this module
-- directly if they need direct access to something not re-exported by
-- "Graphics.Rendering.Diagrams".
--
-----------------------------------------------------------------------------

module Graphics.Rendering.Diagrams.Points
       ( -- * Points

         Point(..), origin, (.-.), (.+^), (*.)

       ) where

import Data.VectorSpace
import qualified Data.AffineSpace as AS

------------------------------------------------------------
--  Points  ------------------------------------------------
------------------------------------------------------------

-- | @Point@ is a newtype wrapper around vectors that we wish to treat
--   as points, so we don't get them mixed up.  Translations affect
--   points, but leave vectors unchanged.  Points are instances of the
--   'AffineSpace' class from "Data.AffineSpace".
newtype Point v = P v
  deriving (Eq, Ord, Read, Show, Functor)

-- | The origin of the vector space @v@.
origin :: AdditiveGroup v => Point v
origin = P zeroV

instance AdditiveGroup v => AS.AffineSpace (Point v) where
  type AS.Diff (Point v) = v
  P v1 .-. P v2 = v1 ^-^v2
  P v1 .+^ v2   = P (v1 ^+^ v2)

-- | Form a vector as the difference of two points.
(.-.) :: AS.AffineSpace p => p -> p -> AS.Diff p
(.-.) = (AS..-.)

-- | Add a vector to a point, producing a new point.
(.+^) :: AS.AffineSpace p => p -> AS.Diff p -> p
(.+^) = (AS..+^)

-- | Scale a point.
(*.) :: VectorSpace v => Scalar v -> Point v -> Point v
s *. P v = P (s *^ v)