{-# LANGUAGE CPP #-}

module AccelerateSample (
  dotp, sampleMain
) where

import Data.Array.Accelerate
import Prelude (IO, show)
import Text.Printf (printf)

#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
import Data.Array.Accelerate.LLVM.Native as CPU
#endif
#ifdef ACCELERATE_LLVM_PTX_BACKEND
import Data.Array.Accelerate.LLVM.PTX as PTX ( runN )
#endif

-- | A simple vector inner product
dotp :: Acc (Vector Double) -> Acc (Vector Double) -> Acc (Scalar Double)
dotp xs ys = fold (+) 0 (zipWith (*) xs ys)

sampleMain :: IO ()
sampleMain = do
  let xs :: Vector Double
      xs = fromList (Z :. 10) [0 ..]

      ys :: Vector Double
      ys = fromList (Z :. 10) [1, 3 ..]

  printf "input data:\n"
  printf "xs = %s\n" (show xs)
  printf "ys = %s\n\n" (show ys)

  printf "the function to execute:\n"
  printf "%s\n\n" (show dotp)

#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
  printf "result with CPU backend: dotp xs ys = %s\n" (show (CPU.runN dotp xs ys))
#endif
#ifdef ACCELERATE_LLVM_PTX_BACKEND
  printf "result with PTX backend: dotp xs ys = %s\n" (show (PTX.runN dotp xs ys))
#endif
