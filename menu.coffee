# Description:
#   Fetches the current menu at fine Vancouver establishments
#
# Dependencies:
#   "cheerio": "0.7.0"
#
# Configuration:
#   None
#
# Commands:
#   menu me 33 - Fetches the current menu at 33 Acres Brewing, alternatives: 33a, 33acres
#   menu me biercraft - Fetches the current menu at Biercraft Commercial, alternatives: biercraftcommercial, biercraft-commercial, biercraftcambie, biercraft-cambie
#   menu me brassneck - Fetches the current menu at Brassneck Brewery, alternatives: bn
#   menu me revolver - Fetches the current menu at Revolver Coffee
#   menu me s&o - Fetches the current menu at Steel & Oak, alternatives: so, steeloak, steel&oak
#   menu me staugs - Fetches the current menu at St. Augustine's, alternatives: augs, augustine, staugustine
#
# Author:
#   mezzoblue, who knows full well this isn't pretty code

cheerio = require('cheerio')

# clean up entities
prettify = (str) ->
    str.replace(/(&#8211;)/, '—').replace(/(&#8217;)/, '\'').replace(/(&#39;)/, '\'')

module.exports = (robot) ->
  robot.hear /menu me (.*)$/i, (msg) ->

    message = ""

    stringNoResponse = " isn't responding. No beer for you."

    switch (msg.match[1])



        #
        # what's on at 33 acres brewing
        #
        #
        when "33", "33a", "33acres", "b33r"

            msg.http('http://33acresbrewing.com/our-beers/').get() (err, res, body) ->

              if res.statusCode != 200
                msg.send "33 Acres" + stringNoResponse

              else
                $ = cheerio.load(body)

                # start with a label
                message = "_33 Acres' tap menu today_\n\n"

                # then get the contents of the menu
                $(body).find('ul.beer-list li.clearfix div.beer-info').each ->
                    message += "*" + $(@).children("h1").text() + "* \n"

                    # bit of a dog's breakfast, yay unstructured markup
                    message += $(@).children("p").last().children("span").first().text().replace(/(Colour: )/, '').trim() + ", "
        
                    message += $(@).children("p").last().children("span").first().next().text().replace(/(alcohol: )/i, '').replace(/( by volume)/i, '').trim() + "\n"
        
                msg.send message.trim()



        #
        # what's on at biercraft commercial
        #
        #
        when "biercraft", "biercraftcommercial", "biercraft-commercial"

            msg.http('http://biercraft.com/commercial/beer-list/').get() (err, res, body) ->

              if res.statusCode != 200
                msg.send "Biercraft" + stringNoResponse

              else
                $ = cheerio.load(body)

                # start with a label
                message = "_Biercraft Commercial's tap menu today_\n\n"

                # then get the contents of the menu
                $(body).find('div#X4383 table tr').each ->
                    if !($(@).hasClass('linerow'))
                        message += "*" + prettify($(@).children(".beername").text().trim()) + "*\n"
                        if $(@).children(".style").text()
                            message += $(@).children(".style").text().trim() + ", "
                        message += $(@).children(".abv").text().trim() + "\n"
        
                msg.send message.trim()



        #
        # what's on at biercraft cambie
        #
        #
        when "biercraftcambie", "biercraft-cambie"

            msg.http('http://biercraft.com/cambie/beer-list/').get() (err, res, body) ->

              if res.statusCode != 200
                msg.send "Biercraft" + stringNoResponse

              else
                $ = cheerio.load(body)

                # start with a label
                message = "_Biercraft Cambie's tap menu today_\n\n"

                # then get the contents of the menu
                $(body).find('div#taphunter table tr').each ->
                    if !($(@).hasClass('linerow'))
                        message += "*" + prettify($(@).children(".beername").text().trim()) + "*\n"
                        if $(@).children(".style").text()
                            message += $(@).children(".style").text().trim() + ", "
                        message += $(@).children(".abv").text().trim() + "\n"
        
                msg.send message.trim()


        #
        # what's on at brassneck brewing
        #
        #
        when "brassneck", "bn"

            msg.http('http://brassneck.ca/').get() (err, res, body) ->

              if res.statusCode != 200
                msg.send "Brassneck" + stringNoResponse

              else
                $ = cheerio.load(body)

                # start with a label
                message = "_Brassneck's taproom menu today_\n\n"

                # then get the contents of the menu

                $(body).find('#ontap-footer a').each ->
                    message += "*" + prettify ($(@).children(".beertitle").text().replace(/(abv:)/, '')) + "* \n"
                    message += prettify ($(@).children(".post-meta").text().replace(/(abv:)/i, ',').replace(/(kind:)/i, '').trim()) + "\n"
        
                msg.send message.trim()



        #
        # what's on at revolver coffee
        #
        #
        when "revolver"

            msg.http('http://www.revolvercoffee.ca/home/').get() (err, res, body) ->

              if res.statusCode != 200
                msg.send "Revolver isn't responding. No coffee for you!"

              else
                $ = cheerio.load(body)

                # start with the date of the latest menu update
                message = "_Revolver's menu as of "
                message += $(body).find('.section-head small em').text().replace(/(Updated)/, '').trim() + "_\n\n"

                # then get the contents of the menu

                $(body).find('div.coffee-menu ul li').each ->
                    prefix = ""
                    suffix = ""

                    if $(@).children('strong').length
                        prefix = "*"
                        suffix = "*"

                    message += prefix + $(@).text() + suffix + "\n"

                msg.send message.trim()


 
        #
        # what's on at st. augustine's
        #
        #
        when "augustine", "augs", "staugustine", "staugs"

            msg.http('http://live-menu.staugustinesvancouver.com/taps.json?offset=0&amount=9999').get() (err, res, body) ->

              if res.statusCode != 200
                msg.send "St. Augustine's" + stringNoResponse

              else
                json = JSON.parse(body)

                # start with a label
                message = "_St. Augustine's tap menu today_\n\n"

                # then get the contents of the menu
                message += "*#{beer.number}. #{beer.name}*\n#{beer.brewer}, #{beer.alcohol_by_volume}%, keg at " + Math.round(beer.remaining) + "%\n" for beer in json

                msg.send message.trim()



        #
        # what's on at steel & oak brewing
        #
        #
        when "so", "s&o", "steeloak", "steel&oak"

            msg.http('https://steelandoak.ca/').get() (err, res, body) ->

              if res.statusCode != 200
                msg.send "Steel & Oak" + stringNoResponse

              else
                $ = cheerio.load(body)

                # start with a label
                message = "_Steel & Oak's taproom menu today_\n\n"

                # then get the contents of the menu
                $(body).find('#stacks-layer-tasting-room div.container aside.stacks-layerset-item').each ->
                    message += "*" + prettify ($(@).children("h1").text().trim()) + "* \n"
                    message += prettify ($(@).children("div.typeset").text().trim()) + "\n"
        
                msg.send message.trim()



        #
        # when no menu is specified, no response
        #
        #
        else
            # do nothing
