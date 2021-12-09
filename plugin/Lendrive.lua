-- created by frrrrrits
-- on 2021/12/7 v1.0.0 created
-- on 2021/12/9 v1.0.1 changelog: fix cover image selector, add trailer elements.

baseUrl = "https://lendrive.web.id/"

latestUpdateUrl = "%s/page/%s"
latestSelector = "div.bixbox.bbnofrm > div.releases.latesthome + div.listupd.normal div.bsx"
episodeSelector = "div.bixbox.bxcl.epcheck li"
downloadSelector = "div.soraddlx.soradlg div.soraurlx"

local detailUrlSelector = "div.nvs.nvsc > a"
local hasload = false

function detailUrl(document)
    return document.select(detailUrlSelector).attr("href")
end

function fetchLatestUpdate(document)
    local aElement = document.select("a")
    url = aElement.attr("href")
    title = aElement.attr("title")
    episode = document.select("span.epx").text()
    thumbnail = document.select("img").attr("src")
end

function fetchDetail(info, genre, document)
    local infoElement = document.select("div.infox")
    local genreElement = infoElement.select("div.genxed a").iterator()

    info.title = infoElement.select("h1").text():gsub("–%sx265/HEVC%sSubtitle%sIndonesia", "")
    info.airdate = infoElement.select("div.spe span:contains(Season:)").text():gsub(".-:%s", "")
    info.status = infoElement.select("div.spe span:contains(Status:)").text():gsub(".-:%s", "")
    info.cover = document.select("div.bigcontent div.thumb img").attr("src")
    info.trailer = document.select("div.bigcontent div.rt a").attr("href")
    info.description = document.select("div.bixbox.synp p").text()

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

function fetchEpisodeList(document)
    url = document.select("a").attr("href")
    title = document.select("div.epl-title").text():gsub("%sSubtitle%sIndonesia%s&%sEnglish", "")
    date = document.select("div.epl-date").text()
end

function fetchDownload(data, document)
    local strongElement = document.select("strong")
    if not (tostring(strongElement):match("<strong>%d%d:%d%d:%d%d</strong>")) then
        local url = document.select("a")
        local title = strongElement.text()
        updateDownload(data, url, title)
    end
end
