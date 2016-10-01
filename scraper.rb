#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

replaced = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://id.wikipedia.org/wiki/Daftar_anggota_DPR_RI_2014–2019',
  xpath: '//table[.//tr[th[.="Nama"]]]//tr[td]//td[4][contains(.,"Menggantikan")]//a[not(@class="new")]/@title',
)

names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://id.wikipedia.org/wiki/Daftar_anggota_DPR_RI_2014–2019',
  xpath: '//table[.//tr[th[.="Nama"]]]//tr[td]//td[1]//a[not(@class="new")]/@title',
)

EveryPolitician::Wikidata.scrape_wikidata(names: { id: names | replaced }, output: false)
