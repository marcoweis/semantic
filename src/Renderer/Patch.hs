import Data.ByteString.Char8 (ByteString, pack)
import Data.Maybe (fromMaybe)
import Data.Monoid (Sum(..))
import Data.Semigroup ((<>))
import Prelude hiding (fst, snd)
        offsetHeader = "@@ -" <> offsetA <> "," <> pack (show lengthA) <> " +" <> offsetB <> "," <> pack (show lengthB) <> " @@" <> "\n"
        (offsetA, offsetB) = runJoin . fmap (pack . show . getSum) $ offset hunk
        (pathA, pathB) = case runJoin $ pack . blobPath <$> blobs of