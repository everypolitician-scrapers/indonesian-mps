#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'colorize'
require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'


def noko_for(url)
  Nokogiri::HTML(open(URI.escape(URI.unescape(url))).read) 
end

def wikinames_from(url)
  noko = noko_for(url)
  names = noko.xpath('//table[.//tr[th[.="Nama"]]]//tr[td]//td[1]//a[not(@class="new")]/@title').map(&:text) 
  abort "No names" if names.count.zero?
  names
end

def fetch_info(names)
  WikiData.ids_from_pages('id', names).each do |name, id|
    data = WikiData::Fetcher.new(id: id).data('id') rescue nil
    unless data
      warn "No data for #{p}"
      next
    end
    data[:original_wikiname] = name
    warn data
    ScraperWiki.save_sqlite([:id], data)
  end
end

fetch_info wikinames_from('https://id.wikipedia.org/wiki/Daftar_anggota_DPR_RI_2014%E2%80%932019')
