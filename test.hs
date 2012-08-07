import Data.ByteString.Base16 as B16
import Data.ByteString.Base64 as B64
import Data.ByteString as BS

convertBase64toBase16 :: ByteString -> ByteString
convertBase64toBase16 s = B16.encode p
          where
            (p,_) = B16.decode s 

main                    :: IO ()
main                    =  do s <- BS.getLine
                              let b = convertBase64toBase16 s
                              BS.putStr b
