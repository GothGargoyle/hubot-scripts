# Description:
# Fetches the details and ratings for a beer from ratebeer.com
#
# Dependencies:
# "cheerio": "0.18.0"
#
# Configuration:
# None
#
# Commands:
# ratebeer <beername> - Queries ratebeer for info on the named beer
#
# Author:
# Simon Droscher

cheerio = require "cheerio"

baseurl = "http://www.ratebeer.com"

module.exports = (robot) ->
  robot.hear /(ratebeer) (.*)/i, (msg) ->
    beerSearch msg, msg.match[2], (result) ->
      $ = cheerio.load(result)
      resultsCount = parseInt($("div#container div div:nth-of-type(3) b:last-of-type").text(), 10)
      if resultsCount is 0
        msg.send "No results were found by ratebeer for #{msg.match[2]}"
      else
        results = []
        $("table.results tr:not([bgcolor])").each (i, elem) ->
          results.push(
            uri: $(this).find("a").attr("href")
            count: parseInt($(this).find("td:last-of-type").text(), 10)
          )

        results.sort (a, b) ->
          if a.count > b.count then -1 else 1

        beerSummary(msg, results[0].uri)


beerSearch = (msg, beer, callback) ->
  msg.http("#{baseurl}/findbeer.asp")
    .query(BeerName: beer)
    .get() (err, res, body) ->
      callback body

beerDetails = (msg, uri, callback) ->
  msg.http("#{baseurl}#{uri}")
    .get() (err, res, body) ->
      callback body

beerSummary = (msg, uri) ->
  beerDetails msg, uri, (beerpage) ->
    $ = cheerio.load(beerpage)
    ratings = $("#container span[itemprop=rating] span:not([style])").map (i, elem) ->
      $(this).html()

    overallRating = ratings[0]
    styleRating = ratings[1]
    name = $("h1").html()
    style = $("#container a[href*=beerstyles]").text()
    abv = $("#container abbr[title='Alcohol By Volume'] ~ big").text()
    avg = $("#container a[name='real average'] strong").last().text()
    count = $("#container span[itemprop=count]").text()

    image = $("#container #tdL img").attr("src")

    msg.send "*#{name}*. A #{abv} #{style}. Ratings (#{count}): overall *#{overallRating}*, style *#{styleRating}*, avg/5 *#{avg}*"
    msg.send image
