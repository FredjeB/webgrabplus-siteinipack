**------------------------------------------------------------------------------------------------
* @header_start
* WebGrab+Plus ini for grabbing EPG data from TvGuide websites
* @Site: go.com.mt
* @MinSWversion:
* @Revision 0 - [17/05/2017] Netuddki
* - creation
* - some code by BlackBear199
* @Remarks: All the 143 channels must be loaded on one single page, therefore it's very slow!
* @header_end
**------------------------------------------------------------------------------------------------
*
site {url=go.com.mt|timezone=UTC|maxdays=7|cultureinfo=en-GB|charset=UTF-8|titlematchfactor=90}
*
url_index {url|https://www.go.com.mt/personal/tv/channels/what-s-on-tv?p_p_id=epgdisplay_WAR_epgportlet&p_p_lifecycle=2&p_p_mode=view&p_p_resource_id=getSchedule2&p_p_col_id=column-1&date=|urldate|&stationFirst=|channel|&stationLast=##station_last##&filter=0}
urldate.format {datestring|yyyMMdd}
*
index_temp_1.modify {calculate(scope=urlindex format=F0)|'config_site_id' 1 +}
url_index.modify {replace(scope=urlindex)|##station_last##|'index_temp_1'}
*
index_showsplit.scrub {regex||<div role="menuitem"(.*?)</div>||}
index_showsplit.modify {sort(ascending,string)}
sort_by.scrub {single(target="index_showsplit")|startdate="||"|"}
sort_by.modify {calculate(target="index_showsplit" format=date,java)}
*
index_start.scrub {regex||startdate="(.*?)"||}
index_stop.scrub {regex||enddate="(.*?)"||}
*
index_title.scrub {regex||title="(.*?)"||}
index_description.scrub {regex||<p>(.*?)</p>||}
*
index_temp_2.scrub {regex||entryId="(.*?)"||}
index_variable_element.modify {set|'index_temp_2'}
*
index_urlshow.modify {addstart|https://www.go.com.mt/personal/tv/channels/what-s-on-tv?p_p_id=epgdisplay_WAR_epgportlet&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=getShowDetails&p_p_cacheability=cacheLevelPage&p_p_col_id=column-1&p_p_col_count=3&entryId='index_variable_element'}
title.scrub {regex||showTitle" : "(.*?)"||}
subtitle.scrub {regex||episodeTitle" : "(.*?)"||}
productiondate.scrub {regex||year" : "(.*?)"||}
*
**  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _
**      #####  CHANNEL FILE CREATION (only to create the xxx-channel.xml file)
**
** @auto_xml_channel_start
*url_index{url|https://www.go.com.mt/personal/tv/channels/what-s-on-tv?p_p_id=epgdisplay_WAR_epgportlet&p_p_lifecycle=2&p_p_mode=view&p_p_resource_id=getSchedule2&p_p_col_id=column-1&date=|urldate|&stationFirst=0&stationLast=143&filter=0}
*site {retry=<retry time-out="25">4</retry>}
*index_site_id.scrub {|}
*index_site_channel.scrub {multi|<h3 channel="||"|"}
*scope.range{(channellist)|end}
*index_temp_1.modify {set|0}
*index_site_channel.modify {cleanup(removeduplicates)}
*loop{(each "index_temp_9" in 'index_site_channel')|end}
*index_site_id.modify {addend|'index_temp_1'#_#}
*index_temp_1.modify {calculate(format=F0)|1 +}
*end_loop
*index_site_id.modify {replace|#_#|\|}
*index_site_id.modify {remove(type=element)|-1 1}
*end_scope
** @auto_xml_channel_end
