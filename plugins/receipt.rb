require 'securerandom'

module Jekyll

  class ReceiptTag < Liquid::Block

    def initialize(tag_name, title, tokens)
      @id = SecureRandom.uuid()
      @title = title.strip!
      super
    end

    def render(context)
      output = super
      if context['site.markdown'] == 'kramdown'
        output = Kramdown::Document.new(output).to_html
      elsif context['site.markdown'] == 'rdiscount'
        output = RDiscount.new(output).to_html
      elsif context['site.markdown'] == 'maruku'
        output = Maruku.new(output).to_html
      else
        warn "WARNING: site.markdown=#{context['site.markdown']} is unkown."
        warn "         Use RubyPanths' method"
        output = RubyPants.new(output).to_html
      end
      printThis = "$('\##{@id}').printThis({pageTitle: '#{@title}'})"
      "<div id='#{@id}' class='receipt'><div class='header'><h3>#{@title}</h3><span class='print' title='Dieses Rezept ausdrucken' onclick=\"#{printThis}\"><i class='fa fa-print'></i></span></div>#{output}</div>"
    end

  end
end

Liquid::Template.register_tag('receipt', Jekyll::ReceiptTag)
