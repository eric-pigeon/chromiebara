module Chromiebara
  class Driver < Capybara::Driver::Base
    include Rammus::Promise::Await
    extend Forwardable

    def initialize(app, options = {})
      @app = app
      @options = options
    end

    def needs_server?
      true
    end

    def visit(url)
      await current_page.goto(url)
    end

    def current_url
      current_page.url
    end

    def refresh
      current_page.reload
    end

    # @param query [String]
    #
    def find_xpath(query, **options)
      current_page.xpath(query).map do |element_handle|
        Node.new self, element_handle, {}
      end
    end

    def find_css(query, **options)
      current_page.query_selector_all(query).map do |element_handle|
        Node.new self, element_handle, {}
      end
    end

    def html
      current_page.content
    end

    def go_back
      current_page.go_back
    end

    def go_forward
      current_page.go_forward
    end

    # @return [Rammus::Browser]
    #
    def browser
      @_browser ||= Rammus.launch headless: true
    end

    private

      def current_page
        @_current_page ||= browser.pages.first
      end
  end
end
