module Settings.Development where

import Prelude

development :: Bool
development = True

production :: Bool
production = not development
