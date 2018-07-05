# Description:
#  SSLabs for Hubot
#
# Dependencies:
#  None
#
# Configuration:
#  None
#
# Commands:
#  hubot *ssl check `domain`* - Check SSL certificate at `domain`
#
# Author
#  belldavidr

module.exports = (robot) ->
  robot.respond /ssl (?:check) (.+)/i, (res) ->
    host = res.match[1].slice(9)
    res.reply "Scanning #{host} with Qualys SSL Labs..."
    url = "https://api.ssllabs.com/api/v3/analyze?host=#{hostname}&fromCache=on"
    robot.http(url).get() (err, response, body) ->
      if err
        res.send ":rick: T-t-t-that didn't *buuurrrp* work, broh."
        return
      else
        api = JSON.parse body
        for endpoint in api.host
          grade = api.host[endpoint].grade
          ip = api.host[endpoint].ipAddress
          server = api.host[endpoint].serverName
          res.send "Grade: #{grade} for #{server} (#{ip}) \n"
        res.send "Details are available at:\n #{url}"
        return