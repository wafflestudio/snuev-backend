require 'net/http'
require 'json'

module Crawler
  class Downloader
    def self.parse_config(year, season)
      ctime = Time.now.localtime().strftime("%Y-%m-%d_%H:%M:%S")
      xls_path = Rails.root+"crawl/data/#{year}_#{season}_#{ctime}.xls"

      path="/sugang/cc/cc100excel.action"

      shtm = {
        'spring': 'U000200001U000300001',
        'autumn': 'U000200002U000300001',
        'summer': 'U000200001U000300002',
        'winter': 'U000200002U000300002',
      }[season.to_sym]
      srchCptnCorsFg=""
      data="srchCond=1&pageNo=1&workType=EX&sortKey=&sortOrder=&srchOpenSchyy=#{year}&currSchyy=#{year}&srchOpenShtm=#{shtm}&srchCptnCorsFg=#{srchCptnCorsFg}&srchOpenShyr=&srchSbjtCd=&srchSbjtNm=&srchOpenUpSbjtFldCd=&srchOpenSbjtFldCd=&srchOpenUpDeptCd=&srchOpenDeptCd=&srchOpenMjCd=&srchOpenSubmattCorsFg=&srchOpenSubmattFgCd=&srchOpenPntMin=&srchOpenPntMax=&srchCamp=&srchBdNo=&srchProfNm=&srchTlsnAplyCapaCntMin=&srchTlsnAplyCapaCntMax=&srchTlsnRcntMin=&srchTlsnRcntMax=&srchOpenSbjtTmNm=&srchOpenSbjtTm=&srchOpenSbjtTmVal=&srchLsnProgType=&srchMrksGvMthd=&srchFlag=&inputTextView=&inputText="

      return {
        xls_path: xls_path,
        path: path,
        data: data,
      }
    end

    def self.download(year, season)
      if !(year.to_i > 1994) then
        puts "[!] 'year' shuold be greater than 1994"
        raise ArgumentError
      elsif !["spring", "autumn", "summer", "winter"].include?(season) then
        puts "[!] 'season' should be in [spring, autumn, summer, winter]"
        raise ArgumentError
      end

      config = self.parse_config(year, season)
      xls_path = config[:xls_path]
      path = config[:path]
      data = config[:data]

      puts "[*] Start fetching..."
      puts "[*] - #{year}/#{season}"

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
