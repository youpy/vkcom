# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'xml'

describe Vkcom::Site do
  let(:url)  { 'http://vk.com/webwave' }
  let(:site) { Vkcom::Site.new(url) }

  before do
    stub_request(:get, url).
      to_return(:body => open(File.expand_path(File.dirname(__FILE__) + '/../content.html')).read)
  end

  describe '#tracks' do
    subject { site.tracks }

    it { should have(22).items }
  end

  describe '#tracks[0]' do
    subject { site.tracks[0] }

    its(:title)  { should eql('░▒▓TANLINES: melted Cd-R ~ a mix for マインドCTRL ') }
    its(:artist) { should eql('BOY MTN')}
  end

  describe '#to_xml' do
    subject { XML::Document.string(site.to_xml) }

    it { should be_an_instance_of(XML::Document) }

    it 'should have items' do
      puts subject.to_s
      items = subject.find('//item')
      items.should have(22).items
    end
  end
end
