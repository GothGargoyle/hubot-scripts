# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   Replace 'when' blocks below with victim's username and desired responses
#   (works best with in-jokes as responses, and a healthy dose of sensitivity
#    about each victim's tolerance for abuse.)
#
# Commands:
#   <person|place|thing> sucks - Display hubot's true feelings about the subject
#
# Author:
#   mezzoblue


module.exports = (robot) ->
  robot.hear /(.*) sucks$/i, (msg) ->


    switch (msg.match[1].toLowerCase())

        #
        # if 'subject' is matched, pick a random response below to display
        #
        when "subject", "subject-alternate-name"
          reply = [
          	"response",
          	"response 2",
            "response 3, etc."
          ]
          msg.send reply[Math.floor(Math.random() * reply.length)]


        #
        # clone each block for more subjects
        #
        when "subject2"
          reply = [
            "response",
            "response 2"
          ]
          msg.send reply[Math.floor(Math.random() * reply.length)]


        #
        # set a default response when no match is found
        #
        else
          msg.send "Nah. Be nice."
