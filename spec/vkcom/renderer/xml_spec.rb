# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Vkcom::Renderer::XML do
  let(:url)  { 'http://vk.com/webwave' }
  let(:site) { Vkcom::Site.new(url) }
  let(:renderer) { Vkcom::Renderer::XML.new(site) }

  describe '#render' do
    let(:rendered) {
      XML::Document.string(renderer.render)
    }

    before do
      stub_request(:get, url).
        to_return(:body => open(File.expand_path(File.dirname(__FILE__) + '/../../content.html')).read)
    end

    it 'should have items' do
      items = rendered.find('//item')
      items.should have(19).items
      items[0].find('.//itunes:duration')[0].to_s.should eql('<itunes:duration>00:38:22</itunes:duration>')
    end
  end
end
