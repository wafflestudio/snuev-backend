require 'net/http'
require 'json'

module Crawler
  class Downloader
    def self.download(year, season)
      if !(year.to_i > 1994) then
        puts "[!] 'year' shuold be greater than 1994"
        return
      elsif !["1", "2", "S", "W"].include?(season) then
        puts "[!] 'season' should be in [1, 2, S, W]"
        return
      end

      ctime = Time.now.localtime().strftime("%Y-%m-%d_%H:%M:%S")
      xls_path=Rails.root+"crawl/data/#{year}_#{season}_#{ctime}.xls"

      puts "[*] Start fetching..."
      puts "[*] - #{year}/#{season}"

      shtm = {
        '1': 'U000200001U000300001',
        '2': 'U000200002U000300001',
        '3': 'U000200001U000300002',
        '4': 'U000200002U000300002',
      }[season]

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

      return xls_path.to_s
    end
  end
end
