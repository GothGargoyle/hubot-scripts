
cheerio = require "cheerio"

module.exports = (robot) ->
  robot.respond /(rb|ratebeer) (.*)/i, (msg) ->
    ratebeer msg, msg.match[2], (result) ->
      $ = cheerio.load(result)
      msg.send $("div#container div div:nth-of-type(3)").html()
      $("table.results tr:not([bgcolor])").each (i, elem) ->
        uri = $(this).find("a").attr("href")
#        msg.send "Looking at #{uri} for more detail"
        beerDetails msg, uri, (beerpage) ->
          $ = cheerio.load(beerpage)
          rating = $("#container span[itemprop=rating] span:not([style])").map (i, elem) ->
            $(this).html()
          name = $("h1").html()
          style = $("#container a[href*=beerstyles]").text()
          abv = $("#container abbr[title='Alcohol By Volume'] ~ big").text()
          avg = $("#container a[name='real average'] strong").last().text()
          count = $("#container span[itemprop=count]").text()
          msg.send "#{name}. A #{abv} #{style}. Ratings (#{count}): overall #{rating[0]}, style #{rating[1]}, avg/5 #{avg}"



ratebeer = (msg, beer, callback) ->
  msg.http('http://www.ratebeer.com/findbeer.asp')
    .query(BeerName: beer)
    .get() (err, res, body) ->
      callback body

beerDetails = (msg, uri, callback) ->
  msg.http("http://www.ratebeer.com#{uri}")
    .get() (err, res, body) ->
      callback body

