# Description:
#  Queries the haveibeenpwned.com api (v2) for the specified email address
#
# Dependencies
#  None
#
# Configuration:
#  None
#
# Commands:
#  hubot *has  `email` been pwned?* - queries haveibeenpwned.com for specified 'email' address
#  hubot *has `username` been pwned?* - queries haveibeenpwned.com for specified 'username'
#
# Author:
#   belldavidr (adapted from neufeldtech)

module.exports = (robot) ->
  robot.hear /(?:has|is) (\S+@\w+\.\w+) (?:been )?pwned\??/i, (msg) ->
    email = msg.match[1]
    url = robot.http("https://haveibeenpwned.com/api/v2/breachedaccount/"+email)
    msg.send "{#url}"
    .get() (err, res, body) ->
      if err
        res.send "Encountered an error :( #{err}"
        return
      else if res.statusCode == 403
          msg.send "you need a user agent"
      else
        if res.statusCode == 200
          msg.send "HTTP 200 OK"
          body = JSON.parse(body)
          pwnedSites = ""
          i = 0
          while i < body.length
            pwnedSites += "#{body[i].Domain}\n"
            i++
          msg.send "Yes, #{email} has been pwned :sob:\n```#{pwnedSites}```"
          return
        else if res.statusCode == 404
          msg.send "Nope, #{email} has not been pwned :tada:"
          return
        else
          msg.send "Encountered an error :("
          return
