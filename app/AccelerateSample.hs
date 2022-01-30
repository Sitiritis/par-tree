{-# LANGUAGE CPP #-}

module AccelerateSample (
  dotp, sampleMain
) where

import Relude (show)
import Data.Array.Accelerate
import Text.Printf (printf)
import Data.Text (Text)
import Relude (IO)

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
  let xsStr :: Text
      xsStr = show xs
  printf "xs = %s\n" xsStr
  let ysStr :: Text
      ysStr = show ys
  printf "ys = %s\n\n" ysStr

  printf "the function to execute:\n"
  let dotpStr :: Text
      dotpStr = show dotp
  printf "%s\n\n" dotpStr

#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
  let resultStr :: Text
      resultStr = show (CPU.runN dotp xs ys)
  printf "result with CPU backend: dotp xs ys = %s\n" resultStr
#endif
#ifdef ACCELERATE_LLVM_PTX_BACKEND
  let resultStr :: Text
      resultStr = (show (PTX.runN dotp xs ys))
  printf "result with PTX backend: dotp xs ys = %s\n" resultStr
#endif
