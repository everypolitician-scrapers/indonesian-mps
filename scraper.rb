#!/bin/env ruby
# encoding: utf-8

require 'everypolitician'
require 'wikidata/fetcher'

existing = EveryPolitician::Index.new.country("Indonesia").lower_house.popolo.persons.map(&:wikidata).compact

names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://id.wikipedia.org/wiki/Daftar_anggota_Dewan_Perwakilan_Rakyat_Republik_Indonesia_2014%E2%80%932019',
  xpath: '//table[.//tr[th[contains(.,"Nama")]]]//tr[td]//td[1]//a[not(@class="new")]/@title',
)

replaced = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://id.wikipedia.org/wiki/Daftar_anggota_Dewan_Perwakilan_Rakyat_Republik_Indonesia_2014%E2%80%932019',
  xpath: '//table[.//tr[th[contains(.,"Nama")]]]//tr[td]//td[4][contains(.,"Menggantikan")]//a[not(@class="new")]/@title',
)

category_2014 = WikiData::Category.new('Kategori:Anggota DPR 2014-2019', 'id').member_titles
category_2009 = WikiData::Category.new('Kategori:Anggota DPR 2009-2014', 'id').member_titles

query = 'SELECT DISTINCT ?item WHERE { ?item p:P39/ps:P39 wd:Q56057048 }'
p39s = EveryPolitician::Wikidata.sparql(query)


EveryPolitician::Wikidata.scrape_wikidata(ids: existing | p39s, names: { id: names | replaced | category_2014 | category_2009 })
