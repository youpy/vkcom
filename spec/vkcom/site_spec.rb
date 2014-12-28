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

    it { should have(19).items }
  end

  describe '#tracks[0]' do
    subject { site.tracks[0] }

    its(:title)    { should eql('░▒▓TANLINES: melted Cd-R ~ a mix for マインドCTRL ') }
    its(:artist)   { should eql('BOY MTN')}
    its(:duration) { should eql(2302)}
    its(:pub_date) { should be_an_instance_of(Time) }
  end
end
