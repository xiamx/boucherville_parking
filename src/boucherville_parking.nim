import std/httpclient
import strutils, nmqtt, asyncdispatch

const mqttHost = "127.0.0.1"
const mqttPort = 1883
const parkingUrl = "https://boucherville.ca/infos-pratiques/deneigement/stationnement-nuit/" 
const parkingAllowedHtml = "Il est<strong> permis</strong> de stationner"
const parkingNotAllowedHtml = "Il est<strong> interdit</strong> de stationner"

proc mqttPub(ctx: MqttCtx, parkingAllowed: bool) {.async.} =
  await ctx.start()
  await ctx.publish("boucherville/parking/allowed", $parkingAllowed, 2)
  await sleepAsync 100
  await ctx.disconnect()

proc main() =
  let ctx = newMqttCtx("BPMQTTClient")
  ctx.set_host(mqttHost, mqttPort)
  ctx.set_ping_interval(30)
  
  let client = newHttpClient()
  let content = client.getContent(parkingUrl)


  if parkingAllowedHtml in content:
    echo "Street parking is allowed tonight"
    waitFor mqttPub(ctx, true)
  elif parkingNotAllowedHtml in content:
    echo "Street parking is prohibited tonight"
    waitFor mqttPub(ctx, false)
  else:
    echo "Error: not able to determine street parking permission"



when isMainModule:
  main()

  