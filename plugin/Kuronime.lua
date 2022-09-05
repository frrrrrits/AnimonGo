-- created by frrrrrits
-- on 2022/6/18 v1.0.0 created

import "android.util.Base64"
baseUrl = "https://kuronime.org"

latestUpdateUrl = "%s/page/%s/"
latestSelector = "div.postbody > div:nth-child(2) > div.listupd div.bsux"

streamSelector = "div.mobius > .mirror > option"
episodeSelector = "div.bixbox.bxcl li"
downloadSelector = "div.bixbox.mctn > div.soraddl > div.soraurl"

streamable = true

local detailUrlSelector = "div.item.meta > div.lm > span.year > a"
local hasload = false

function detailUrl(document)
    return document.select(detailUrlSelector).attr("href")
end

function fetchLatestUpdate(document)
    url = document.select("a").attr("href")
    title = document.select("div.bsuxtt").text()
    episode = document.select("div.bt > div.ep").text()
    thumbnail = document.select("div.limit > img").attr("src")  
end

function fetchDetail(info, genre, document)
    local infoElement = document.select("div.infodetail > ul")
    local genreElement = infoElement.select("li:nth-child(2) > a").iterator()

    info.title = document.select("div.info-header > h1").text()
    info.cover = document.select("div.main-info > div.con > div.l > img").attr("src")
    info.status = infoElement.select("li:nth-child(3)").text():gsub("Status: ", "")
    info.airdate = infoElement.select("li:nth-child(6)").text():gsub("Season: ", "")
    info.description = document.select("div.main-info > div.con > div.r > div > span").text()
    info.trailer = document.select("div.bixbox.trailer noscript > iframe").attr("src"):gsub("embed/","watch?v=")

    if not (hasload) then
        while genreElement.hasNext() do
            local element = genreElement.next()
            genre.url = element.select("a").attr("href")
            genre.title = element.select("a").text()
            updateGenre()
        end
        hasload = true
    end
    updateDetail()
end

local function decode(data)
   return String(Base64.decode(data,Base64.DEFAULT)).toString()
end

function fetchStreamingLinks(element, jsoup)
    url = Jsoup.parse(decode(element.select("option").attr("value")))
    .select("iframe").attr("data-src")
end

function fetchEpisodeList(document)
    local aelement = document.select("span.lchx > a")
    url = aelement.attr("href")
    title = aelement.text()
    date = "Uknown"
end

function fetchDownload(data, document)
    local strongElement = document.select("strong")
    if not tostring(strongElement):match("<strong>%d%d:%d%d:%d%d</strong>") then
        local url = document.select("a")
        local title = strongElement.text()
        updateDownload(data, url, title)
    end
end
