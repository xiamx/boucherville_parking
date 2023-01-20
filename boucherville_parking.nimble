# Package

version       = "0.1.0"
author        = "Meng Xuan Xia"
description   = "Boucherville winter street parking permission tracker, connects to MQTT"
license       = "MIT"
srcDir        = "src"
bin           = @["boucherville_parking"]


# Dependencies

requires "nim >= 1.6.8"
requires "nmqtt >= 1.0.5"
