
baseUrl = "https://kuramanime.com/anime/ongoing?order_by=updated"

streamable = true
useextractor = false

episodeSelector = false
downloadSelector = false

latestUpdateUrl = "%s&page=%s"
latestSelector = "div[id*=animeList] > div.col-lg-4.col-md-6.col-sm-6"
streamSelector = 'video#player > source'

local detailUrlSelector = "div.episode__navigations > a.center__nav"
local hasload = false

local function changeStatus(str)
    if tostring(str) == "Sedang Tayang" then
        return "Ongoing"
    end
    return "Completed"
end

function selectorEpisode(document)
    return Jsoup.parse(document.select("#episodeLists").attr("data-content")).select("a")
end

function selectorDownload(document)
    local element = document.select("#animeDownloadLink")
    return String(tostring(element)).split("<br>")
end

function detailUrl(document)
    return document.select(detailUrlSelector).attr("href")
end

function fetchLatestUpdate(element)
    url = element.select("a").attr("href")
    title = element.select("h5 > a").text()
    episode = element.select("div.ep > span").text():gsub("/.+", "")
    thumbnail = element.select("div.product__item__pic.set-bg").attr("data-setbg")
end

function fetchDetail(info, genre, document)
    local element = document.select("div.anime__details__content")
    local detailElement = element.select("div.col-lg-9 > div")
    local textElement = detailElement.select("div.anime__details__widget > div")

    info.trailer = nil
    info.description = detailElement.select("p").text()
    info.title = detailElement.select("div.anime__details__title > h3").text()
    info.cover = element.select("div.col-lg-3 > div").attr("data-setbg")
    info.status = changeStatus(textElement.select("div:nth-child(1) > ul > li:nth-child(3) > a").text())
    info.airdate = textElement.select("div:nth-child(1) > ul > li:nth-child(5) > a").text()

    local genreElement = textElement.select("div:nth-child(2) > ul > li:nth-child(1) > a").iterator()

    if not hasload then
        while genreElement.hasNext() do
            local element = genreElement.next()
            genre.url = element.attr("href")
            genre.title = element.text():gsub(",", "")
            updateGenre()
        end
        hasload = true
    end
    updateDetail()
end


function fetchEpisodeList(document)
    date = ""
    url = document.select("a").attr("href")
    title = document.text()
end

function fetchStreamingLinks(element, jsoup)
    url = element.select("source").attr("src")
end

function fetchDownload(data, document)
    local url = document.select("a")
    local title = document.select("h6").text()    
    updateDownload(data, url, title)
end