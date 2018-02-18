require 'net/http'
require 'json'

if ARGV.length != 2 then
  puts "[!] Usage:"
  puts "[!] $ ruby download.rb <year ..|2013|..> <season 1: spring, S: summer, 2: autumn, W: winter>"
  exit!
end

year = ARGV[0]
season = ARGV[1] #1/S/2/W
ctime = Time.now.localtime().strftime("%Y-%m-%d_%H:%M:%S")
xls_path="crawl/data/#{year}_#{season}_#{ctime}.xls"

if !(year.to_i > 1994) then
  puts "[!] 'year' shuold be greater than 1994"
  exit!
elsif !["1", "2", "S", "W"].include?(season) then
  puts "[!] 'season' should be in [1, 2, S, W]"
  exit!
end

puts "[*] Start fetching..."
puts "[*] - #{year}/#{season}"

case season
when '1'
  shtm = 'U000200001U000300001'
when '2'
  shtm = 'U000200002U000300001'
when 'S'
  shtm = 'U000200001U000300002'
when 'W'
  shtm = 'U000200002U000300002'
end

path="/sugang/cc/cc100excel.action"
srchCptnCorsFg=""

data="srchCond=1&pageNo=1&workType=EX&sortKey=&sortOrder=&srchOpenSchyy=#{year}&currSchyy=#{year}&srchOpenShtm=#{shtm}&srchCptnCorsFg=#{srchCptnCorsFg}&srchOpenShyr=&srchSbjtCd=&srchSbjtNm=&srchOpenUpSbjtFldCd=&srchOpenSbjtFldCd=&srchOpenUpDeptCd=&srchOpenDeptCd=&srchOpenMjCd=&srchOpenSubmattCorsFg=&srchOpenSubmattFgCd=&srchOpenPntMin=&srchOpenPntMax=&srchCamp=&srchBdNo=&srchProfNm=&srchTlsnAplyCapaCntMin=&srchTlsnAplyCapaCntMax=&srchTlsnRcntMin=&srchTlsnRcntMax=&srchOpenSbjtTmNm=&srchOpenSbjtTm=&srchOpenSbjtTmVal=&srchLsnProgType=&srchMrksGvMthd=&srchFlag=&inputTextView=&inputText="

res = Net::HTTP.start('sugang.snu.ac.kr',80){|http|
  http.post(path, data)
}

open(xls_path, "wb") do |file|
  file.print(res.body)
end

puts "[*] Downloaded:"
puts "[*] - #{xls_path}"
