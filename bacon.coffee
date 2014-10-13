# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   bacon me - Display a bacony piece of wonder
#
# Author:
#   mezzoblue

bacon = [
  "http://cdn.newadnetwork.com/sites/prod/files/uploads/bhockenstein_en/kevin-bacon.jpg",
  "http://www.jaxfoodieadventures.com/wp-content/uploads/2014/09/1bacon0929.jpg",
  "http://img2.wikia.nocookie.net/__cb20110624171559/bacon/images/5/5f/Crispy_bacon_1-1-.jpg",
  "http://timenewsfeed.files.wordpress.com/2013/05/nf_bacon_longevity_0508.jpg?w=480&h=320&crop=1",
  "http://www.bizpacreview.com/wp-content/uploads/2014/08/bacon.jpg",
  "http://33q47o1cmnk34cvwth15pbvt120l.wpengine.netdna-cdn.com/wp-content/uploads/1362814231.jpg",
  "http://fcdn.mtbr.com/attachments/off-camber-off-topic/913593d1407286737-midnight-i-want-some-crunchy-bacon-1399806627786.jpg",
  "http://365daysofbacon.files.wordpress.com/2013/02/bacon_heart.jpg",
  "http://cdn.sheknows.com/articles/candied-bacon.jpg",
  "http://ewpopwatch.files.wordpress.com/2009/03/bacon_l.jpg",
  "https://www.beanstalk-inc.com/blog/wp-content/uploads/2012/09/bacon.jpg",
  "http://rack.3.mshcdn.com/media/ZgkyMDEyLzEyLzA0L2VhL25vd3dla25vd2hvLmQ5VC5qcGcKcAl0aHVtYgk5NTB4NTM0IwplCWpwZw/e0e419b9/567/now-we-know-how-much-is-too-much-bacon-viral-video--796066df88.jpg",
  "http://l3.yimg.com/bt/api/res/1.2/52gLPdUO_4DRpd4h5msXNw--/YXBwaWQ9eW5ld3M7cT04NTt3PTYzMA--/http://media.zenfs.com/en/blogs/technews/sms-630-bacon-plate-shutterstock-630w.jpeg"
]

module.exports = (robot) ->
  robot.hear /bacon me\b/i, (msg) ->
    msg.send msg.random bacon