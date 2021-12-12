-- created by frrrrrits
-- on 2021/12/7 v1.0.0 created
-- on 2021/12/12 v1.0.1 changelog: add trailer elements.

baseUrl = 'https://neonime.cc'

latestUpdateUrl = '%s/episode/page/%s'
latestSelector = 'div[id=episodes] > table > tbody td.bb'
episodeSelector = 'ul.episodios> > li'
downloadSelector = 'div.linkstv > div.sbox li'

local genreSelector = 'div.metadatac b:contains(Genre) + span > a'
local detailUrlSelector = 'div.metadatac b:contains(Serie) + span > a'
local hasload = false

-- ambil url ke detail info animenya
function detailUrl(document)
  return document.select(detailUrlSelector).attr('href')
end

function fetchLatestUpdate(document)
  local aElement=document.select("a")
  url=aElement.attr("href")
  title=aElement.text()
  episode=document.select("span").text()
  thumbnail=document.select("img").attr("data-src")
end

function fetchDetail(info,genre,document)
  local genreElement=document.select(genreSelector).iterator()
  info.title=document.select("div.cover > h1").text():gsub("Subtitle Indonesia","")
  info.airdate=document.select("div.metadatac b:contains(Release Season) + span > a").text()
  info.status=document.select("div.metadatac b:contains(TV Status) + span").text()
  info.cover=document.select("div.imagen > img").attr("data-src")
  info.description=document.select("div.contenidotv > div > p").text()
  info.trailer=document.select("div[id=trailer] meta[itemprop=embedUrl]").attr("content")

  if !hasload then
    -- biar ga nambah genre nya ketika di refresh
    while genreElement.hasNext() do
      local element=genreElement.next()
      genre.url=element.select("a").attr("href")
      genre.title=element.select("a").text()
      updateGenre()
    end
    hasload=true
  end
  updateDetail()
end

function fetchEpisodeList(document)
  local urlElement=document.select('div.episodiotitle > a')
  url=urlElement.attr('href')
  title=urlElement.text():gsub("Subtitle Indonesia","")
  date=document.select('div.episodiotitle > span.date').text()
end

function fetchDownload(data,document)
  local liElement=document.select("li")
  if tostring(liElement):match("<li>MP4</li>") then
   elseif tostring(liElement):match("<li>MKV</li>") then
   else local labelElement=liElement.select("label")
    -- url elements harus utuh a nya ex:(<a href=url>teks</a>)
    local url=document.select("a")
    local title=labelElement.text()
    updateDownload(data,url,title)
   end
end
