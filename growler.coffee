# Description:
#   Fetches the current growler fill list at fine Vancouver establishments
#
# Dependencies:
#   "cheerio": "0.7.0"
#
# Configuration:
#   None
#
# Commands:
#   growler me 33 - Fetches the current menu at 33 Acres Brewing, alternatives: 33a, 33acres
#   growler me brassneck - Fetches the current menu at Brassneck Brewery, alternatives: bn
#   growler me s&o - Fetches the current menu at Steel & Oak, alternatives: so, steeloak, steel&oak
#
# Author:
#   mezzoblue, who knows full well this isn't pretty code

cheerio = require('cheerio')

# clean up entities
prettify = (str) ->
    str.replace(/(&#8211;)/, '—').replace(/(&#8217;)/, '\'').replace(/(&#39;)/, '\'')

module.exports = (robot) ->
  robot.hear /growler me (.*)$/i, (msg) ->

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
                message = "_33 Acres' growler fills today_\n\n"

                # then get the contents of the menu
                $(body).find('ul.beer-list li.clearfix div.beer-info').each ->
                    message += "*" + $(@).children("h1").text() + "* \n"

                    # bit of a dog's breakfast, yay unstructured markup
                    message += $(@).children("p").last().children("span").first().text().replace(/(Colour: )/, '').trim() + ", "
        
                    message += $(@).children("p").last().children("span").first().next().text().replace(/(alcohol: )/i, '').replace(/( by volume)/i, '').trim() + "\n"
        
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
                message = "_Brassneck's growler fills today_\n\n"

                # then get the contents of the menu

                $(body).find('#fills-footer a').each ->
                    message += "*" + prettify ($(@).children(".beertitle").text().replace(/(abv:)/, '')) + "* \n"
                    message += prettify ($(@).children(".post-meta").text().replace(/(abv:)/i, ',').replace(/(kind:)/i, '').trim()) + "\n"
        
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
                message = "_Steel & Oak's growler fills today_\n\n"

                # then get the contents of the menu
                $(body).find('#stacks-layer-todays-growler-fills div.container aside.stacks-layerset-item').each ->
                    message += "*" + prettify ($(@).children("h1").text().trim()) + "* \n"
                    message += prettify ($(@).children("div.typeset").text().trim()) + "\n"
        
                msg.send message.trim()



        #
        # when no menu is specified, no response
        #
        #
        else
            # do nothing
